function [ error, b, n ] = SmithGSS( texture, U, mu, s )
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

    % shift so it is in the range -1 to 1
    theta = acos(((double(texture) / double(max(max(texture)))) * 2) - 1);
    n = EstimateNormalsAvg(mu, theta);
    npp = zeros(size(n));
    i = 1;

    while sum(real(acos(dot(reshape2colvector(n), reshape2colvector(npp))))) > 30
        error(i) = sum(real(acos(dot(reshape2colvector(n), reshape2colvector(npp)))));
        sum(real(acos(dot(reshape2colvector(n), reshape2colvector(npp)))))
        
        if i > 1;
            n = npp;
        end
        
        % Loop until convergence
        v0 = n;%spherical2azimuthal(n, mu);

        % vector of best-fit parameters
        b = U' * (v0);% - mu);
        % transformed coordinates
        vprime = (U * b);% + mu;

        %nprime = azimuthal2spherical(vprime, mu);
        npp = OnConeRotation(theta, vprime, s);
        i = i + 1;
    end
    
    n = ColVectorToImage3(npp, size(texture, 1), size(texture, 2));
end

function n = OnConeRotation(theta, nprime, s)
    % 3 x N format
    nprime = reshape2colvector(nprime);
    % repmat to match 3 x N format above
    svec = repmat(s', 1, size(nprime, 2));
    
    % cross product and break in to row vectors
    C = cross(nprime, svec);
    u = C(1, :);
    v = C(2, :);
    w = C(3, :);
    
    % cos(q) = a.b/|a||b| ??
    nnorm = bsxfun(@rdivide, nprime, colnorm(nprime));
    d = dot(nnorm, svec);
    
    % reshape theta to row vector
    theta = Image2ColVector(theta)';
    alpha = theta - acos(d);
    
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

function nestimates = EstimateNormals(texture, theta)
    [dx, dy] = gradient(double(texture));
    
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

function nestimates = EstimateNormalsAvg(mu, theta)   
    muim = ColVectorToImage3(mu, size(theta, 1), size(theta, 2));
    
    % Could have some division by zero...
    norm = sqrt(muim(:,:,1).^2 + muim(:,:,2).^2 +muim(:,:,3));
    sinphi = muim(:,:,2) ./ norm;
    sinphi(isnan(sinphi)) = 0;
    cosphi = muim(:,:,1) ./ norm;
    cosphi(isnan(cosphi)) = 0;
    clear norm;
    
    nestimates(:,:,1) = sin(theta) .* cosphi;
    nestimates(:,:,2) = sin(theta) .* sinphi;
    nestimates(:,:,3) = cos(theta);

    nestimates = Image2ColVector3(nestimates(:,:,1), nestimates(:,:,2), nestimates(:,:,3));
end