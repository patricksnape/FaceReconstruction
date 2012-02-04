function pgreat_circle(x1, x2, center)
%PGREAT_CIRCLE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('center', 'var'), center = [0;0;0]; end

 v1 = x1 - center; % Vector from center to 1st point
 r = norm(v1); % The radius
 
 v2 = x2 - center; % Vector from center to 2nd point
 v3 = cross(cross(v1, v2), v1); % v3 lies in plane of v1 & v2 and is orthog. to v1
 v3 = r * v3 / norm(v3); % Make v3 of length r
 
 % Let t range through the inner angle between v1 and v2
 t = linspace(0, atan2(norm(cross(v1, v2)),dot(v1, v2))); 
 v = v1 * cos(t) + v3 * sin(t); % v traces great circle path, relative to center
 
 plot3(v(1,:) + center(1),v(2,:) + center(2),v(3,:) + center(3)) % Plot it in 3D

end

