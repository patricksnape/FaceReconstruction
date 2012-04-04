function out = spherical2azimuthal(normals, mean_normal)
%SPHERICAL2AZIMUTHAL Calculates the Azimuthal Equidistant Projection for each set of normals
%
% Given a set of training image normals project them on to a euclidean
% plane using the azimuthal equidistant projection. Requires the mean
% surface normal at each point to have already been calculated
%
% normals should be a column vector divisible by three 
% (x1, y1, y2, x2, y2, y3, ...)
% mean_normal should be a column vector divisible by three
% (x1, y1, y2, x2, y2, y3, ...)
%
% Returns a column vector of the projections
% (x1, y1, x2, y2, ...)

N = size(normals, 2);
% from x,y,z to x,y
out = zeros(size(normals, 1) * (2/3), size(normals, 2));

% reshape to vector matrix
vec_mean_normals = reshape(mean_normal, [3 numel(mean_normal)/3]);
vec_mean_normals = bsxfun(@rdivide, vec_mean_normals, colnorm(vec_mean_normals));

thetaav = elevation(vec_mean_normals(3, :));
% round thetas back in to the range [-pi/2, pi/2]
thetaav(thetaav > pi/2) = thetaav(thetaav > pi/2) - pi;
phiav = azimuth(vec_mean_normals(1, :), vec_mean_normals(2, :));

for i = 1:N
    % as vector matrix
    kset = reshape(normals(:, i), [3 numel(normals(:, i))/3]);
    projected = zeros(2, size(kset, 2));
    
    thetak = elevation(kset(3, :));
    % round thetas back in to the range [-pi/2, pi/2]
    thetak(thetak > pi/2 ) = thetak(thetak > pi/2) - pi;
    phik = azimuth(kset(1, :), kset(2, :));
    
    % cos(c) = sin(thetaav) * sin(thetak) + cos(thetaav) * cos(thetak) * cos[phik - phiav]
    cosc = sin(thetaav) .* sin(thetak) + cos(thetaav) .* cos(thetak) .* cos(phik - phiav);
    c = acos(cosc);
    % kprime = c / sin(c)
    kprime = rdivide(c, sin(c));
    
    % xs = kprime * cos(thetak) * sin[phik - phiav]
    projected(1, :) = kprime .* cos(thetak) .* sin(phik - phiav);
    % ys = kprime * (cos(thetaav) * sin(phik) - sin(thetaav) * cos(thetak) * cos[phik - phiav]
    projected(2, :) = kprime .* (cos(thetaav) .* sin(thetak) - sin(thetaav) .* cos(thetak) .* cos(phik - phiav));
    
    % reshape back to column vector
    out(:, i) = reshape(projected, [], 1);
end

end

% theta = (pi / 2) - asin(nz)
function thetas = elevation(zs)
     thetas = (pi / 2) - asin(zs); %% elevation between 0, pi and 0 at z=1
end

% phi = atan(ny,nx)
function phis = azimuth(xs, ys)
     phis = atan2(ys, xs);
end