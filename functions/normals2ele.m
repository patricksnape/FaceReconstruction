function [ele, spher] = normals2ele(normals)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

spher = normals2spher(normals);
ele = reshape(spher, 4, []);
ele = reshape(ele(3:4, :), [], 1);

end

