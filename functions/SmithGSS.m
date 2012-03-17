function [ b, n ] = SmithGSS( image, P, s )
%SMITHGSS Summary of this function goes here
% 1. Calculate an initial estimate of the field of surface normals n using (12).
% 2. Each normal in the estimated field n undergoes an
%    azimuthal equidistant projection ((3)) to give a
%    vector of transformed coordinates v0.
% 3. The vector of best fit model parameters is given by
%    b = P' * v0 .
% 4. The vector of transformed coordinates corresponding
%    to the best-fit parameters is given by vprime = (PP')v0.
% 5. Using the inverse azimuthal equidistant projection
%    ((4)), find the off-cone best fit surface normal nprime from vprime.
% 6. Find the on-cone surface normal nprimeprime by rotating the
%    off-cone surface normal nprime using nprimeprime(i,j) = theta * nprime(i,j)
% 7. Test for convergence. If sum over i,j arccos(n(i,j) . nprimeprime(i,j)) < eps,
%    where eps is a predetermined threshold, then stop and
%    return b as the estimated model parameters and nprimeprime as
%    the recovered needle map.
% 8. Make n(i,j) = nprimeprime(i,j) and return to Step 2.


    n = EstimateNormals(image);
    imtheta = calcTheta(image);
    npp = n;

    while sum(acos(dot(reshape2colvector(n), reshape2colvector(npp)))) > eps
        % Loop until convergence
        n = npp;
        avgN = mean_surface_norm(n);
        v0 = spherical2azimuthal(n, avgN);

        b = P' * v0;
        vprime = (P * P') * v0;

        nprime = azimuthal2spherical(vprime);
        npp = OnConeRotation(imtheta, nprime, s);
    end
end

function t = calcTheta(image)
    t = acos(image);
end

function n = OnConeRotation(theta, nprime, s)
    [u, v, w] = cross(nprime, s);
    alpha = theta - acos(dot(nprime, s));
    
    c = cos(alpha);
    cprime = 1 - c;
    s = sin(alpha);
    
    phi = [ 
            c + u^2 * cprime, -w * s + u * v * cprime, v * s + u * w * cprime;
            w * s + u * v * cprime, c + v^2 * cprime, -u * s + v * w * cprime;
            -v * s + u * w * cprime, u * s + v * w * cprime, c + w^2 * cprime;
          ];
    
    n = phi * nprime;
end

function nestimates = EstimateNormals(image)
    [dx, dy] = gradient(image);
    phi = atan2(-dy, -dx);
    theta = acos(image);
    
    nestimates = [
                  sin(theta) .* cos(phi); 
                  sin(theta) .* sin(phi);
                  cos(theta);
                 ];

    % convert to 3 x N matrix by concatenating the rows of an image
    nestimates = mat2cell(nestimates, 3 * ones(1, size(nestimates, 1) / 3), ones(1, size(nestimates, 2)));
    nestimates = nestimates.';
    nestimates = horzcat(nestimates{:});
    
    % convert 3xN rows to a column matrix
    nestimates = reshape(nestimates, [], 1);
end