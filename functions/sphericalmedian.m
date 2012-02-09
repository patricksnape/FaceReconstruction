function [mu] = sphericalmedian(normals)
%SPHERICALMEAN Summary of this function goes here
%   Detailed explanation goes here

% Collect the columns into cells
vec_normals = reshape(normals, [3 numel(normals)/3]);

N = size(vec_normals, 2);
mu = vec_normals(:, 1);
delta_mu = [0;0;0];

tol = 10 ^ -3;
not_done = true;

while not_done
    mu1 = mu;
    for i = 1:N
        l = logmap(mu, vec_normals(:, i));
        if (~any(isnan(l)))
            delta_mu = delta_mu + logmap(mu, vec_normals(:, i));
        end
    end
    delta_mu = delta_mu / N;
    
    mu = expmap(mu, delta_mu);
    not_done = (norm(mu-mu1) > tol);
end

end

