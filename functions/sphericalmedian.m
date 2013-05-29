function [delta_mu] = sphericalmedian(guess, normals)
%SPHERICALMEAN Summary of this function goes here
%   Detailed explanation goes here

% Function body if we are using fminsearch
K = size(normals, 2);

guess_vec = repmat(guess, 3, []);

l = logmap(guess_vec, normals);
delta_mu = sum(colnorm(l)) / K;

% K = size(normals, 2);
% delta_mu = [0;0;0];
% prev_mu = [0;0;0];
% mu = guess;
% 
% while norm(prev_mu - mu) > 10^-3
%     prev_mu = mu;
%     for i = 1:K
%         l = logmap(prev_mu, normals(:, i));
%         delta_mu = delta_mu + l;
%     end
%     delta_mu = delta_mu / K;
%     mu = expmap(prev_mu, delta_mu);
% end