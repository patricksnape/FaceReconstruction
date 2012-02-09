function [mu] = sphericalmedian(guess, normals)
%SPHERICALMEAN Summary of this function goes here
%   Detailed explanation goes here

% Collect the columns into cells
vec_normals = reshape(normals, [3 numel(normals)/3]);

N = size(vec_normals, 2);
mu = guess;
delta_mu = [0;0;0];

tol = 10 ^ -3;
not_done = true;

prev_mu = mu;

for i = 1:N
    l = logmap(mu, vec_normals(:, i));
    if (~any(isnan(l)))
        delta_mu = delta_mu + l;
    end
end
delta_mu = delta_mu / N;

mu = expmap(mu, delta_mu);
mu = norm(mu-prev_mu);

end