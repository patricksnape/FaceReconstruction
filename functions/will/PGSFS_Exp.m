function [ N ] = PGSFS_Exp( U,bp )
%PGSFS_EXP Exponential map for U from tangent plane T_{bp}S^2(n) to
%manifold S^2(n)
%
%  Inputs: 
%       U  - n*2 matrix of vectors on T_{bp}S^2(n)
%       bp - Base point for log map, either n*3 or 1*3
%  Output:
%       N  - n*3 matrix of unit vectors
%
%  This function returns the exponential map of a matrix of unit vectors. 
%  This can be interpreted in 2 ways. If the base point is a member of 
%  S^2(n) then the exponential map is on the tangent plance T_{bp}S^2(n). 
%  If the base point is a member of S^2 then the exponential map is n 
%  copies of the exponential map in T_{bp}S^2 each with base point bp. The 
%  inverse of the exponential map is the log map, see PGSFS_Log.

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

[TH,PHI,R] = cart2sph(-bp(:,2),bp(:,1),bp(:,3));

%if (sum(R~=1)~=0)
%    error('Each row of bp must be a unit vector');
%end

long0lat1(:,1) = TH+pi;
long0lat1(:,2) = PHI;

rho=sqrt(U(:,1).^2+U(:,2).^2);
Z=exp(i*(atan2(U(:,2),U(:,1))));
V1=rho.*real(Z);
V2=rho.*imag(Z);
ir=rho==0;  % To prevent /0 warnings when rho is 0
rho(ir)=eps;
c=rho;

c(ir)=eps;

Y=asin(cos(c).*sin(long0lat1(:,2)) + cos(long0lat1(:,2)).*sin(c).*V2./rho);
X=long0lat1(:,1)+atan2( V1.*sin(c), cos(long0lat1(:,2)).*cos(c).*rho - sin(long0lat1(:,2)).*V2.*sin(c) ) ;

longlat(:,1) = real(X);
longlat(:,2) = real(Y);

[N(:,2),N(:,1),N(:,3)] = sph2cart(longlat(:,1)-pi,longlat(:,2),1);
N(:,2) = -N(:,2);
