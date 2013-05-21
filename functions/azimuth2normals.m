function [xyz] = azimuth2normals(azimuth, elevation)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

if size(azimuth, 1) ~= 2
    azimuth = reshape(azimuth, [2 numel(azimuth) / 2]);
end
if size(elevation, 1) ~= 2
    elevation = reshape(elevation, [2 numel(elevation) / 2]);
end

gx  = reshape(azimuth(1, :), [], 1);
gy  = reshape(azimuth(2, :), [], 1);
gz  = reshape(elevation(1, :), [], 1);
sgz = reshape(elevation(2, :), [], 1);

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

