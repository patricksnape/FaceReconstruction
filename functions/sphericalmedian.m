function [delta_mu] = sphericalmedian(guess, normals)
%SPHERICALMEAN Summary of this function goes here
%   Detailed explanation goes here

% Collect the columns into cells
vec_normals = reshape(normals, [3 numel(normals)/3]);

N = size(vec_normals, 2);
delta_mu = 0;

for i = 1:N
    l = logmap(guess, vec_normals(:, i));
    delta_mu = delta_mu + norm(l);
end
delta_mu = delta_mu / N;

end