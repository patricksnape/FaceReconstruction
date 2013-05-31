function [ U ] = PGSFS_Log( N,bp )
%PGSFS_LOG Log Map for N from manifold S^2(n) to tangent plane T_{bp}S^2(n)
%
%  Inputs: 
%       N  - n*3 matrix of unit vectors
%       bp - Base point for log map, either n*3 or 1*3
%  Output:
%       U  - n*2 matrix of vectors on T_{bp}S^2(n)
%
%  This function returns the log map of a matrix of unit vectors. This can
%  be interpreted in 2 ways. If the base point is a member of S^2(n) then
%  the log map is on the space S^2(n). If the base point is a member of
%  S^2 then the log map is n copies of the log map in S^2 each with base point
%  bp. The inverse of the log map is the exponential map, see PGSFS_Exp.

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

[TH,PHI,R] = cart2sph(-N(:,2),N(:,1),N(:,3));

%if (sum(R~=1)~=0)
%    error('Each row of N must be a unit vector');
%end

longlat(:,1) = TH+pi;
longlat(:,2) = PHI;

[TH,PHI,R] = cart2sph(-bp(:,2),bp(:,1),bp(:,3));

%if (sum(R~=1)~=0)
%    error('Each row of bp must be a unit vector');
%end

long0lat1(:,1) = TH+pi;
long0lat1(:,2) = PHI;

c = acos(sin(long0lat1(:,2)).*sin(longlat(:,2))+cos(long0lat1(:,2)).*cos(longlat(:,2)).*cos(longlat(:,1)-long0lat1(:,1)));

k = 1./sin(c);
k(isnan(k)) = 0;
k = c.*k;

U(:,1) = k.*(cos(longlat(:,2)).*sin(longlat(:,1)-long0lat1(:,1)));
U(:,2) = k.*(cos(long0lat1(:,2)).*sin(longlat(:,2))-sin(long0lat1(:,2)).*cos(longlat(:,2)).*cos(longlat(:,1)-long0lat1(:,1)));