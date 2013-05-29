function n = expmap(b, v, varargin)
%EXPMAP Exponential map function
%   Detailed explanation goes here

% Use the inputParser class to validate input arguments.
inp = inputParser;

% Default to sphere projection
validProjection = {'stereographic','sphere'};
inp.addOptional('Projection', validProjection{2}, @(x)any(strcmpi(x,validProjection)));

inp.parse(varargin{:});
arg = inp.Results;
clear('inp');

% Else perform the chosen projection
switch arg.Projection
    case validProjection{1} % Stereographic
        n = stereographic(b, v);
    case validProjection{2} % Sphere projection
        n = sphere_projection(b, v);

end

% TODO: Vectorise me
function n = stereographic(b, v)
% theta = norm(b - v);
% 
% % dist(-b,x)
% dist_nbx = sqrt(2 * (1 + cos(theta)));
% % dist(b,x)
% dist_bx = 2 * sin(theta / 2);
% 
% alpha = acos((4 + dist_nbx ^ 2 - dist_bx ^ 2) / (4 * dist_nbx));
% 
% vprime = b + (((v - b) * 2 * tan(alpha)) / norm(v - b));
% 
% n = dist_nbx * ((vprime + b) / norm(vprime + b)) - b;

function n = sphere_projection(b, v)
% Any zero length vectors should remain the base vector
zero_indices = find(sum(abs(v)) == 0);

vnorm = repmat(colnorm(v), 3, []);
n = cos(vnorm) .* b + sin(vnorm) .* (v ./ vnorm);

% Map base vectors back
n(:, zero_indices) = b(:, zero_indices);