function [ Ns ] = PGSFS_KExps( Us,bp )
%PGSFS_KEXPS For each of k points on the manifold S^2(n) return the log map
%
%  Inputs: 
%       Us  - 2*n*k matrix of k sets of vectors on T_{bp}S^2(n)
%       bp - Base point for log map, either 3*n or 3*1
%  Output:
%       Ns  - 3*n*k matrix of k sets of n unit vectors
%
%  This function simply performs the exponential map k times on each of the k 
%  points on the manifold S^2(n). The inverse of this function is the k 
%  logs map, see PGSFS_KExps.

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

for i=1:size(Us, 3)
    Ns(:,:,i) = PGSFS_Exp(squeeze(Us(:,:,i))', bp')';
end