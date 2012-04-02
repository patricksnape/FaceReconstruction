function [ c ] = CountInverted(normals, plane)
%COUNTINVERTED Summary of this function goes here
%   Detailed explanation goes here

normals = reshape2colvector(normals);
plane = repmat(plane, 1, size(normals, 2));

d = dot(normals, plane);

c = length(find(d<0));

end

