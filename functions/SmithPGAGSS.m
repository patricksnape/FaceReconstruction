function [ b n ] = SmithPGAGSS(texture, U, normal_avg, mus, s)
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
% 7. Make n(i,j) = nprimeprime(i,j) and return to Step 2 - Repeat as
%    required

% Texture must be converted to greyscale

    % normalize so it is in the range 0 to 1
    % intensity can never be < 0
    theta = abs(acos(((double(texture) / double(max(max(texture)))))));
    theta(theta < 0) = 0;
    
    n = EstimateNormalsAvg(normal_avg, theta);
    npp = zeros(size(n));

    for i = 1:20       
        if i > 1;
            n = npp;
        end
        
        % Loop until convergence
        ncol = reshape2colvector(n);
        v0 = ncol;
        for p = 1:size(ncol, 2)
            v0(:, p) = logmap(mus(:, p), ncol(:, p));
        end
        v0 = reshape(v0, [], 1); 

        % vector of best-fit parameters
        b = U' * v0;
        % transformed coordinates
        vprime = U * b;

        vcol = reshape2colvector(vprime);
        nprime = vcol;
        for p = 1:size(vcol, 2)
            nprime(:, p) = expmap(mus(:, p), vcol(:, p));
        end
        nprime = reshape(nprime, [], 1); 
        
        % Normalize
        nprime = reshape2colvector(nprime);
        nprime = reshape(bsxfun(@rdivide, nprime, colnorm(nprime)), [], 1); 
        
        npp = OnConeRotation(theta, nprime, s);
        i
    end
    
    n = real(ColVectorToImage3(npp, size(texture, 1), size(texture, 2)));
end

function n = OnConeRotation(theta, nprime, s)
    % 3 x N format
    nprime = reshape2colvector(nprime);
    % repmat to match 3 x N format above
    svec = repmat(s', 1, size(nprime, 2));
    
    % cross product and break in to row vectors
    C = cross(nprime, svec);
    reshape(bsxfun(@rdivide, C, colnorm(C)), [], 1);
    
    u = C(1, :);
    v = C(2, :);
    w = C(3, :);
    
    % expects |nprime|  = |sec| = 1
    % represents intensity and can never be < 0
    d = dot(nprime, svec);
    d(d < 0) = 0;
    
    % reshape theta to row vector
    theta = Image2ColVector(theta)';
    
    beta = acos(d);    
    alpha = theta - beta;
    % flip alpha so that it rotates along the correct axis
    alpha = -alpha;
    
    c = cos(alpha);
    cprime = 1 - c;
    s = sin(alpha);
    
    % setup structures
    N = size(u, 2);  
    n = zeros(size(nprime));
    phi = zeros(3, 3);
    
    for i=1:N
        phi(1,1) = c(i) + u(i)^2 * cprime(i);
        phi(1,2) = -w(i) * s(i) + u(i) * v(i) * cprime(i);
        phi(1,3) = v(i) * s(i) + u(i) * w(i) * cprime(i);
        
        phi(2,1) = w(i) * s(i) + u(i) * v(i) * cprime(i);
        phi(2,2) = c(i) + v(i)^2 * cprime(i);
        phi(2,3) = -u(i) * s(i) + v(i) * w(i) * cprime(i);
        
        phi(3,1) = -v(i) * s(i) + u(i) * w(i) * cprime(i);
        phi(3,2) = u(i) * s(i) + v(i) * w(i) * cprime(i);
        phi(3,3) = c(i) + w(i)^2 * cprime(i);
          
        n(:, i) = phi * nprime(:, i);
    end
    
    % Normalize the result ??
    n = bsxfun(@rdivide, n, colnorm(n));
    
    % reshape back to column vector
    n = reshape(n, [], 1);
end

function nestimates = EstimateNormalsAvg(mu, theta)   
    muim = reshape2colvector(mu);
    muim = bsxfun(@rdivide, muim, colnorm(muim));
    muim = ColVectorToImage3(reshape(muim,[],1), size(theta, 1), size(theta, 2));
    
    % Could have some division by zero...
    norm = sqrt(muim(:,:,1).^2 + muim(:,:,2).^2);
    sinphi = muim(:,:,2) ./ norm;
    sinphi(isnan(sinphi)) = 0;
    cosphi = muim(:,:,1) ./ norm;
    cosphi(isnan(cosphi)) = 0;
    clear norm;
    
    nestimates(:,:,1) = sin(theta) .* cosphi;
    nestimates(:,:,2) = sin(theta) .* sinphi;
    nestimates(:,:,3) = cos(theta);

    % normalize and reshape to column
    nestimates = Image2ColVector3(nestimates(:,:,1), nestimates(:,:,2), nestimates(:,:,3));
    nestimates = reshape2colvector(nestimates);
    nestimates = bsxfun(@rdivide, nestimates, colnorm(nestimates));
    nestimates = reshape(nestimates, [], 1);
end