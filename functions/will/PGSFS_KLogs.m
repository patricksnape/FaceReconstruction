function [ Us ] = PGSFS_KLogs( Ns,bp )
%PGSFS_KLOGS For each of k points on the manifold S^2(n) return the log map
%
%  Inputs: 
%       Ns  - 3*n*k matrix of k sets of n unit vectors
%       bp - Base point for log map, either 3*n or 3*1
%  Output:
%       Us  - 2*n*k matrix of k sets of vectors on T_{bp}S^2(n)
%
%  This function simply performs the log map k times on each of the k 
%  points on the manifold S^2(n). The inverse of this function is the k 
%  exponential map, see PGSFS_KExps.

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

for i=1:size(Ns, 3)
    Us(:, :, i) = PGSFS_Log(squeeze(Ns(:,:,i)'), bp')';
end