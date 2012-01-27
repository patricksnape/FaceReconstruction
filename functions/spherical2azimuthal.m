function [out, thetak, phik] = spherical2azimuthal(normals, mean_normal)
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
phiav = azmiuth(vec_mean_normals(1, :), vec_mean_normals(2, :));

disp('Calculating Azimuthal Equidistant Projection...');
parfor_progress(N);

for i = 1:N
    % as vector matrix
    kset = reshape(normals(:, i), [3 numel(normals(:, i))/3]);
    projected = zeros(2, size(kset, 2));
    
    thetak = elevation(kset(3, :));
    phik = azmiuth(kset(1, :), kset(2, :));
    
    cosc = sin(thetaav) .* sin(thetak) + cos(thetaav) .* cos(thetak) .* cos(phik - phiav);
    c = acos(cosc);
    kprime = rdivide(c, sin(c));
    
    % xs
    projected(1, :) = kprime .* cos(thetak) .* sin(phik - phiav);
    %ys
    projected(2, :) = kprime .* (cos(thetaav) .* sin(thetak) + cos(thetaav) .* cos(thetak) .* cos(phik - phiav));
    
    % reshape back to column vector
    out(:, i) = reshape(projected, [], 1);
    
    parfor_progress;
end
parfor_progress(0);

disp('Finished Calculating Azimuthal Equidistant Projection');

end

function thetas = elevation(zs)
     thetas = (pi / 2) - asin(zs);
end

function phis = azmiuth(xs, ys)
     phis = atan(rdivide(ys, xs));
end