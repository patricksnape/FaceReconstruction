function [ mu ] = PGSFS_IntrinsicMean( Ns,iterations )
%PGSFS_INTRINSICMEAN Returns the intrinsic mean of k points on the manifold
%S^2(n)
%
%  Input: 
%       Ns         - 3*n*k matrix of k points on manifold S^2(n)
%       iterations - Number of iterations to use (default: 10)
%  Output:
%       mu         - 3*n matrix of intrinsic mean, a point on S^2(n)
%
%  This function returns the intrinsic mean of a sample of k points lying
%  on the manifold S^2(n). We commence from an initialisation which uses
%  the extrinsic mean and use Pennec's [1] iterative algorithm to solve for
%  mu.
%
%  [1] X. Pennec. "Probabilities and statistics on Riemannian manifolds: 
%      basic tools for geometric measurements," In IEEE Workshop on 
%      Nonlinear Signal and Image Processing, 1999.

% Part of the Principal Geodesic Shape-from-shading Package
%
% Copyright: William Smith,
% Department of Computer Science,
% The University of York,
% UK.
%
% Email: wsmith@cs.york.ac.uk
% Web: http://www-users.cs.york.ac.uk/~wsmith
%
% November 2005

if (nargin==1)
    iterations = 5;
end

% Compute initial estimate (Euclidian mean of data)
mu = mean(Ns, 3);

% Remap Euclidian mean to closest point on sphere
norms(1, :) = sqrt(mu(1,: ) .^2 + mu(2, :) .^2 + mu(3, :) .^2);
norms(2, :) = norms(1, :);
norms(3, :) = norms(1, :);
mu = mu./norms;

% Iteratively improve estimate of intrinsic mean
for i=1:iterations
    mu = PGSFS_KExps(mean(PGSFS_KLogs(Ns, mu), 3), mu);
end