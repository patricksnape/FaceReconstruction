function n = expmap(b, v)
%EXPMAP Exponential map function
%   Detailed explanation goes here

theta = norm(b - v);

% dist(-b,x)
dist_nbx = sqrt(2 * (1 + cos(theta)));
% dist(b,x)
dist_bx = 2 * sin(theta / 2);

% otherwise we end up with a divide by 0
if (dist_bx == 0)
    n = b;
    return;
end


alpha = acos((4 + dist_nbx ^ 2 - dist_bx ^ 2) / (4 * dist_nbx));

vprime = b + (((v - b) * 2 * tan(alpha)) / norm(v - b));

n = dist_nbx * ((vprime + b) / norm(vprime + b)) - b;

end