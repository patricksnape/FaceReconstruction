function [ mus ] = spherical_median_wrapper_will(normals, mean_normals, type, iterations)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    iterations = 10;
end

count = size(normals, 2);
mus = zeros(3, count);

for i = 1:count
    mu = mean_normals(:, i);

    % Remap Euclidian mean to closest point on sphere
    norms(1, :) = sqrt(mu(1,: ) .^2 + mu(2, :) .^2 + mu(3, :) .^2);
    norms(2, :) = norms(1, :);
    norms(3, :) = norms(1, :);
    mu = mu./norms;
    
    normalp = squeeze(normals(:, i, :));
    
    mu_vec = repmat(mu, 1, size(normalp, 2));

    % Iteratively improve estimate of intrinsic mean
    for k=1:iterations
        mus(:, i) = expmap(mu, mean(logmap(mu_vec, normalp, type), 2), type);
    end
end