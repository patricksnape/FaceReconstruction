function v = logmap(b, x)
%LOGMAP Returns a vector from n1 to n2 on projected on to the tangent plane
% at n1
%   Expects unit column vectors

% dist(-b,x)
dist_nbx = norm(b + x);
% dist(b,x)
dist_bx = norm(x - b);

alpha = acos((4 + (dist_nbx ^ 2) - (dist_bx ^ 2)) / (4 * dist_bx));

vprime = ((2 * (b + x)) / (dist_nbx * cos(alpha))) - b;

theta = acos(b .* x);

v = b + ((theta .* (vprime - b)) / norm(vprime - b));

end

