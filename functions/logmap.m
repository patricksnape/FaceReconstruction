function v = logmap(b, q, varargin)
%LOGMAP Returns a vector from n1 to n2 on projected on to the tangent plane
% at n1
%   Expects unit column vectors

% Use the inputParser class to validate input arguments.
inp = inputParser;

% Default to sphere projection
validProjection = {'stereographic', 'sphere', 'william'};
inp.addOptional('Projection', validProjection{3}, @(x) any(strcmpi(x, validProjection)));

inp.parse(varargin{:});
arg = inp.Results;
clear('inp');

switch arg.Projection
    case validProjection{1} % Stereographic
        v = stereographic(b, q);
    case validProjection{2} % Sphere projection
        v = sphere_projection(b, q);
    case validProjection{3} % William A.P. Smith's projection
        v = william_projection(b, q);
end

v = real(v);

% TODO: Vectorise me
function v = stereographic(b, q)
q = reshape2colvector(q, 3);
% Any zero length vectors should remain the base vector
zero_indices = find(sum(abs(q)) == 0);

% dist(-b,x)
dist_nbx = repmat(colnorm(b + q), 3, 1);
% dist(b,x)
dist_bx = repmat(colnorm(q - b), 3, 1);

alpha = acos((4 + (dist_nbx .^ 2) - (dist_bx .^ 2)) ./ (4 * dist_nbx));

vprime = ((2 * (b + q)) ./ (dist_nbx .* cos(alpha))) - b;

theta = repmat(acos(dot(b, q)), 3, 1);

v = b + ((theta .* (vprime - b)) ./ repmat(colnorm(vprime - b), 3, 1));

% Map base vectors back
v(:, zero_indices) = b(:, zero_indices);
v(isnan(v)) = b(isnan(v));

function v = sphere_projection(b, q)
q = reshape2colvector(q, 3);
% Any zero length vectors should remain the base vector
zero_indices = find(sum(abs(q)) == 0);

theta = repmat(acos(dot(b, q)), 3, 1);
v = (theta ./ sin(theta)) .* (q - b .* cos(theta));

% Map base vectors back
v(:, zero_indices) = b(:, zero_indices);

function v = william_projection(b, q)
q = reshape2colvector(q, 3);

v = PGSFS_KLogs(q, b);