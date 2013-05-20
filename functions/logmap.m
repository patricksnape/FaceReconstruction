function v = logmap(b, q, varargin)
%LOGMAP Returns a vector from n1 to n2 on projected on to the tangent plane
% at n1
%   Expects unit column vectors

% Use the inputParser class to validate input arguments.
inp = inputParser;

% Default to sphere projection
validProjection = {'stereographic', 'sphere'};
inp.addOptional('Projection', validProjection{2}, @(x) any(strcmpi(x, validProjection)));

inp.parse(varargin{:});
arg = inp.Results;
clear('inp');

switch arg.Projection
    case validProjection{1} % Stereographic
        v = stereographic(b, q);
    case validProjection{2} % Sphere projection
        v = sphere_projection(b, q);

end

function v = stereographic(b, q)
% dist(-b,x)
dist_nbx = norm(b + q);
% dist(b,x)
dist_bx = norm(q - b);

alpha = acos((4 + (dist_nbx ^ 2) - (dist_bx ^ 2)) / (4 * dist_nbx));

vprime = ((2 * (b + q)) / (dist_nbx * cos(alpha))) - b;

theta = acos(dot(b,q));

v = b + ((theta .* (vprime - b)) / norm(vprime - b));

function v = sphere_projection(b, q)
theta = dot(b, q);

v = (theta / sin(theta)) * (q - b * cos(theta));