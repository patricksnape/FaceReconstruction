function [ D ] = calculate_D_wrapper(normals, mus)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

N = size(normals, 2);

vk = zeros(3, N);
% for all normals
parfor k = 1:N
    vk(:, k) = logmap(mus(:, k), normals(:, k));
end
D = reshape(vk, [], 1);