function [ D ] = calculate_D_wrapper(normals, mus, projection_type)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% for all normals
vk = logmap(mus, normals, projection_type);
D = reshape(vk, [], 1);