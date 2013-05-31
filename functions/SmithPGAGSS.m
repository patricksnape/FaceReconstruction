function [ n, b, error ] = SmithPGAGSS(texture, U, normal_avg, s, mus, theta)
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

    if (nargin < 6)
        % normalize so it is in the range 0 to 1
        % intensity can never be < 0
        theta = acos(double(texture));
        theta(theta < 0) = 0;
    end
    
    n = EstimateNormalsAvg(normal_avg, theta);
    npp = zeros(size(n));
    error = zeros(1, 10);
    theta_vec = repmat(Image2ColVector(theta)', 3, []);

    s_vec = repmat(s, 1, size(mus, 2));

    for i = 1:10
        error(i) = sum(real(acos(dot(reshape2colvector(n), reshape2colvector(npp)))));
        if i > 1
            n = npp;
        end
        
        % Loop until convergence
        v0 = logmap(mus, n);
        v0 = reshape(v0, [], 1);

        % vector of best-fit parameters
        b = U' * v0;
        % transformed coordinates
        vprime = U * b;

        % Convert backt o normals
        nprime = expmap(mus, reshape2colvector(vprime));
        
        % Normalize
        nprime = nprime ./ repmat(colnorm(nprime), 3, []);
        
        % Rotate back to on cone normal by projecting on to the tangent
        % plane defined by the light vector
        log_s_npp = logmap(s_vec, nprime);
        vec = theta_vec .* (log_s_npp ./ repmat(colnorm(log_s_npp), 3, []));
        npp = expmap(s_vec, vec);
        npp = reshape(npp, [], 1);
    end
    
    n = real(ColVectorToImage3(npp, size(texture, 1), size(texture, 2)));
end