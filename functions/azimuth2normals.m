function [xyz] = azimuth2normals(azimuth, elevation)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

if size(azimuth, 1) ~= 2
    azimuth = reshape(azimuth, 2, []);
end
if size(elevation, 1) ~= 2
    elevation = reshape(elevation, 2, []);
end

angles = [azimuth; elevation];

xyz = spher2normals(angles);

end

