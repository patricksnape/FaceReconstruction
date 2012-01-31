function out = spherical2azimuthal(normals, mean_normal)
%AEP Calculates the Azimuthal Equidistant Projection for each set of normals
%   Given a set of training image normals project them on to a euclidean
%   plane using the azimuthal equidistant projection. Requires the mean
%   surface normal at each point to have already been calculated

N = size(normals, 2);
% from x,y,z to x,y
out = zeros(size(normals, 1) * (2/3), size(normals, 2));

% reshape to vector matrix
vec_mean_normals = reshape(mean_normal, [3 numel(mean_normal)/3]);

thetaav = elevation(vec_mean_normals(3, :));
phiav = azimuth(vec_mean_normals(1, :), vec_mean_normals(2, :));

disp('Calculating Azimuthal Equidistant Projection...');
parfor_progress(N);

for i = 1:N
    % as vector matrix
    kset = reshape(normals(:, i), [3 numel(normals(:, i))/3]);
    projected = zeros(2, size(kset, 2));
    
    thetak = elevation(kset(3, :));
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
    
    parfor_progress;
end
parfor_progress(0);

disp('Finished Calculating Azimuthal Equidistant Projection');

end

% theta = (pi / 2) - asin(nz)
function thetas = elevation(zs)
     thetas = (pi / 2) - asin(zs);
end

% phi = atan(ny,nx)
function phis = azimuth(xs, ys)
     phis = atan2(ys, xs);
end