function mu = sphericalmean(normals)
%SPHERICALMEAN Summary of this function goes here
%   Detailed explanation goes here

% Collect the columns into cells
vec_normals = reshape(normals, [3 numel(normals)/3]);

N = size(vec_normals, 2);
mu = vec_normals(:, 1);
delta_mu = [0;0;0];

tol = 10 ^ -5;
not_done = true;

while not_done
    for i = 1:N
        delta_mu = delta_mu + logmap(mu, vec_normals(:, i));
    end
    delta_mu = delta_mu / N;
    
    mu = expmap(mu, delta_mu);
    
    not_done = (norm(delta_mu) > tol);
end

