function [xyz] = spher2normals( angles )
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

if size(angles, 1) ~= 4
    angles = reshape(angles, [4 numel(angles) / 4]);
end

gx  = reshape(angles(1, :), [], 1);
gy  = reshape(angles(2, :), [], 1);
gz  = reshape(angles(3, :), [], 1);
sgz = reshape(angles(4, :), [], 1);

gzsgz = sqrt(gz.^2  + sgz.^2);

gxgy = sqrt(gx.^2 + gy.^2);

gx  = gx ./ gxgy; 
gy  = gy ./ gxgy;
gz  = gz ./ gzsgz;
sgz = sgz ./ gzsgz;

phi = atan2(gy, gx);
theta = atan((gz ./ sgz));

x = sin(theta) .* cos(phi);
y= sin(theta) .* sin(phi);
z = cos(theta);

xyz = reshape([x, y, z]', [], 1);

end

