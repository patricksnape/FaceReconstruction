function [ theta ] = estimate_theta_from_intensity(intensity_image)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

theta = acos(double(intensity_image));
theta(theta < 0) = 0;
end

