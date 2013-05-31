function n = expmap(b, v, varargin)
%EXPMAP Exponential map function
%   Detailed explanation goes here

% Use the inputParser class to validate input arguments.
inp = inputParser;

% Default to sphere projection
validProjection = {'stereographic','sphere', 'william'};
inp.addOptional('Projection', validProjection{3}, @(x)any(strcmpi(x,validProjection)));

inp.parse(varargin{:});
arg = inp.Results;
clear('inp');

% Else perform the chosen projection
switch arg.Projection
    case validProjection{1} % Stereographic
        n = stereographic(b, v);
    case validProjection{2} % Sphere projection
        n = sphere_projection(b, v);
    case validProjection{3} % William A.P. Smith's projection
        n = william_projection(b, v);
end

n = real(n);

% TODO: Vectorise me
function n = stereographic(b, v)
% Any zero length vectors should remain the base vector
zero_indices = find(sum(abs(v)) == 0);

theta = repmat(colnorm(b - v), 3, 1);

% dist(-b,x)
dist_nbx = sqrt(2 * (1 + cos(theta)));
% dist(b,x)
dist_bx = 2 * sin(theta / 2);

alpha = acos((4 + dist_nbx .^ 2 - dist_bx .^ 2) ./ (4 * dist_nbx));

vprime = b + (((v - b) * 2 .* tan(alpha)) ./ norm(v - b));

n = dist_nbx .* ((vprime + b) ./ repmat(colnorm(vprime + b), 3, 1)) - b;

% Map base vectors back
n(:, zero_indices) = b(:, zero_indices);
n(isnan(n)) = b(isnan(n));

function n = sphere_projection(b, v)
% Any zero length vectors should remain the base vector
zero_indices = find(sum(abs(v)) == 0);

vnorm = repmat(colnorm(v), 3, 1);
n = cos(vnorm) .* b + sin(vnorm) .* (v ./ vnorm);

% Map base vectors back
n(:, zero_indices) = b(:, zero_indices);

n = n ./ repmat(colnorm(n), 3, 1);

function n = william_projection(b, v)

v = reshape2colvector(v, 2);

n = PGSFS_KExps(v, b);