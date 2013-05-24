function [ n, b, error ] = SmithGSS_generic(error_metric, texture, U, normal_avg, s, theta)
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
    
    n = EstimateNormalsAvg(normal_avg, theta);
    npp = zeros(size(n));
    error = zeros(1, 20);

    for i=1:20  
        error(i) = sum(real(acos(dot(reshape2colvector(n), reshape2colvector(npp)))));
        if i > 1
            n = npp;
        end
        
        % Loop until convergence
        switch error_metric
            case 'IP' 
                v0 = n;
                n_avg = zeros(size(v0, 1), 1);
            case 'AEP'    
                v0 = spherical2azimuthal(n, normal_avg);
                n_avg = zeros(size(v0, 1), 1);
            case 'LS'
                v0 = matsubcolvec(n, normal_avg);
                n_avg = normal_avg;
            case 'PGA'
                error('Not supported - use SmithGSSPGA');
            case 'AZI'
                [v0, X_spher] = normals2azimuth(n);
                n_avg = zeros(size(v0, 1), 1);
            case 'ELE'
                [v0, X_spher] = normals2ele(n);
                n_avg = zeros(size(v0, 1), 1);
            case 'SPHER'
                v0 = normals2spher(n);
                n_avg = zeros(size(v0, 1), 1);
        end

        % vector of best-fit parameters
        b = U' * v0;
        % transformed coordinates
        vprime = mataddcolvec(U * b, n_avg);
        
        switch error_metric
            case 'AEP'    
                nprime = azimuthal2spherical(vprime, normal_avg);
            case 'PGA'
                error('Not supported - use SmithGSSPGA')
            case 'AZI'
                X_spher = reshape(X_spher, 4, []);
                X_ele = X_spher(3:4, :);
                nprime = azimuth2normals(vprime, X_ele);
            case 'ELE'
                X_spher = reshape(X_spher, 4, []);
                X_azi = X_spher(1:2, :);
                nprime = ele2normals(vprime, X_azi);
            case 'SPHER'
                nprime = spher2normals(vprime);
            case 'LS'
                nprime = vprime;
            case 'IP'
                nprime = vprime;
        end
        
        % Normalize
        nprime = reshape2colvector(nprime);
        nprime = reshape(bsxfun(@rdivide, nprime, colnorm(nprime)), [], 1); 
        
        npp = OnConeRotation(theta, nprime, s);
    end
    
    n = ColVectorToImage3(npp, size(texture, 1), size(texture, 2));
end