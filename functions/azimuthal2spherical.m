function out = azimuthal2spherical( projections, mean_normal )
%AZIMUTHAL2SPHERICAL Given a set of points projected using azimuthal
%equidistant projection return their coordinates on a unit sphere

N = size(projections, 2);
% from x,y to x,y,z
out = zeros(size(projections, 1) * (3/2), size(projections, 2));

% reshape to vector matrix
vec_mean_normals = reshape(mean_normal, [3 numel(mean_normal)/3]);

thetaav = elevation(vec_mean_normals(3, :));
phiav = azimuth(vec_mean_normals(1, :), vec_mean_normals(2, :));

disp('Calculating Coordinates...');
parfor_progress(N);

for i = 1:N
    % as vector matrix
    kset = reshape(projections(:, i), [2 numel(projections(:, i))/2]);
    xs = kset(1, :);
    ys = kset(2, :);
    % theta,phi
    angles = zeros(2, size(kset, 2));
    
    c = sqrt(xs .^ 2 + ys .^ 2);
    recipc = rdivide(ones(1, numel(c)), c);
    
    % thetas = asin[cos(c) * sin(thetaav) - (1/c) * yk * sin(c) * % cos(thetav)]
    angles(1, :) = asin(cos(c) .* sin(thetaav) - recipc .* ys .* sin(c) .* cos(thetaav));
    % phis = phiav + atan(psi)
    angles(2, :) = phiav + atan(psi(c, thetaav, xs, ys));
    
    % convert angles to coordinates
    vectors = zeros(size(angles, 1) * (3/2), size(angles, 2));
    % xs = sin(phi) * cos(theta)
    vectors(1, :) = sin(angles(2, :)) .* cos(angles(1, :));
    % ys = cos(phi) * sin(theta)
    vectors(2, :) = cos(angles(2, :)) .* sin(angles(1, :));
    % zs = sin(theta)
    vectors(3, :) = sin(angles(1, :));
    
    % reshape back to column vector
    out(:, i) = reshape(vectors, [], 1);
    
    parfor_progress;
end
parfor_progress(0);
disp('Finished Calculating Coordinates...');

end

% theta = (pi / 2) - asin(nz)
function thetas = elevation(zs)
     thetas = (pi / 2) - asin(zs);
end

% phi = atan(ny/nx)
function phis = azimuth(xs, ys)
     phis = atan(rdivide(ys, xs));
end

% psi = thetaav != (pi / 2) -> 
%           xk * sin(c) / c * cos(thetaav) * cos(c) - yk * sin(thetav) * sin(c)
%       thetaav == (pi/2)   -> -(xk/yk)
%       thetaav == -(pi/2)  -> xk/yk
function psis = psi(c, thetaav, xs, ys)
    N = numel(thetaav);
    % row of zeros
    psis = zeros(1, N);
        
    for i = 1:N
        if (thetaav(i) == (pi/2))
            psis(i) = -(xs(i) / ys(i));
        elseif (thetaav(i) == -(pi/2))
            psis(i) = xs(i) / ys(i);
        else
            numer = xs(i) * sin(c(i));
            denom = c(i) * cos(thetaav(i)) * cos(c(i)) - ys(i) * sin(thetaav(i)) * sin(c(i));
            psis(i) = numer / denom;
        end
    end
end