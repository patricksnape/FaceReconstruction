function [azi, spher] = normals2azimuth(normals)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

spher = normals2spher(normals);
azi = reshape(spher, [4 numel(spher) / 4]);
azi = reshape(azi(1:2, :), [], 1);

end

