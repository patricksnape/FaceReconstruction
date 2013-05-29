function [ D ] = calculate_D_wrapper(normals, mus)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% for all normals
vk = logmap(mus, normals);
D = reshape(vk, [], 1);