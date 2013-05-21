function [xyz] = ele2normals(elevation, azimuth)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

xyz = azimuth2normals(azimuth, elevation);

end

