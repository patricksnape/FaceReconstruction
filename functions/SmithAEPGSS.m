function [ b n ] = SmithAEPGSS( texture, U, mu, s, theta)
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

% Texture must be converted to greyscale

    if (nargin < 6)
        % normalize so it is in the range 0 to 1
        % intensity can never be < 0
        theta = abs(acos(((double(texture) / double(max(max(texture)))))));
        theta(theta < 0) = 0;
    end
    
    n = EstimateNormalsAvg(mu, theta);
    npp = zeros(size(n));

    for i=1:3      
        if i > 1;
            n = npp;
        end
        
        % Loop until convergence
        v0 = spherical2azimuthal(n, mu);

        % vector of best-fit parameters
        b = U' * v0;
        % transformed coordinates
        vprime = U * b;
        
        nprime = azimuthal2spherical(vprime, mu);
        
        % Normalize
        nprime = reshape2colvector(nprime);
        nprime = reshape(bsxfun(@rdivide, nprime, colnorm(nprime)), [], 1); 
        
        npp = OnConeRotation(theta, nprime, s);
    end
    
    n = ColVectorToImage3(npp, size(texture, 1), size(texture, 2));
end

function nestimates = EstimateNormals(texture, theta)
    % n ??
    [dx, dy] = longRangeGradient(double(texture), 170);
    
    % Could have some division by zero...
    norm = sqrt(dx.^2 + dy.^2);
    sinphi = dy ./ norm;
    sinphi(isnan(sinphi)) = 0;
    cosphi = dx ./ norm;
    cosphi(isnan(cosphi)) = 0;
    clear norm;
    
    nestimates(:,:,1) = sin(theta) .* cosphi;
    nestimates(:,:,2) = sin(theta) .* sinphi;
    nestimates(:,:,3) = cos(theta);

    nestimates = Image2ColVector3(nestimates(:,:,1), nestimates(:,:,2), nestimates(:,:,3));
end