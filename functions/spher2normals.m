function [xyz] = spher2normals(angles)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

if size(angles, 1) ~= 4
    angles = reshape(angles, [4 numel(angles) / 4]);
end

gx  = angles(1, :);
gy  = angles(2, :);
gz  = angles(3, :);
sgz = angles(4, :);

gzsgz = sqrt(gz.^2 + sgz.^2);

gxgy = sqrt(gx.^2 + gy.^2);

gx  = gx ./ gxgy;
gy  = gy ./ gxgy;
gz  = gz ./ gzsgz;
sgz = sgz ./ gzsgz;

phi = atan2(gy, gx);
theta = atan((gz ./ sgz));

[x, y, z] = sph2cart(phi, theta, ones(size(phi)));

xyz = reshape([x; y; z], [], 1);

end

