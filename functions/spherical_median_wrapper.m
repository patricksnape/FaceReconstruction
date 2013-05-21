function [ mus ] = spherical_median_wrapper(normals, mean_normals)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

count = size(normals, 2);
mus = zeros(3, count);

for i = 1:count
    normalp = squeeze(normals(:, i, :));
    mus(:, i) = fminsearch(@(x) sphericalmedian(x, normalp), mean_normals(:, i));
end