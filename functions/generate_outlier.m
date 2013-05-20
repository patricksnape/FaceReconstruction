function [ outlier ] = generate_outlier(width, height)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

random = rand(width, height, 3);
x = reshape(random(:, :, 1), 1, []);
y = reshape(random(:, :, 2), 1, []);
z = reshape(random(:, :, 3), 1, []);
vs = [x; y; z];
cnorm = colnorm(vs);
outlier = bsxfun(@rdivide, vs, cnorm);
outlier = reshape(outlier, [width, height, 3]);

