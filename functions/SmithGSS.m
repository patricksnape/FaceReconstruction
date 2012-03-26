function [ b, n ] = SmithGSS( texture, U, s )
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
    n = EstimateNormals(texture, theta);
    npp = n;

    while sum(acos(dot(reshape2colvector(n), reshape2colvector(npp)))) > eps
        % Loop until convergence
        n = npp;
        % avgN = mean_surface_norm(n);
        v0 = npp; %spherical2azimuthal(n, avgN);

        % vector of best-fit parameters
        b = U' * v0;
        % transformed coordinates
        vprime = U * b;

        %nprime = azimuthal2spherical(vprime);
        npp = OnConeRotation(theta, vprime, s);
    end
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
    
    % shift so it is in the range -1 to 1??
    d = dot(nprime, svec);
    % reshape theta to row vector
    theta = reshape(theta.' , 1, []);
    alpha = theta - acos(d);
    
    c = cos(alpha);
    cprime = 1 - c;
    s = sin(alpha);
    
    phi = [ 
            c + u.^2 .* cprime, -w .* s + u .* v .* cprime, v .* s + u .* w .* cprime;
            w .* s + u .* v .* cprime, c + v.^2 .* cprime, -u .* s + v .* w .* cprime;
            -v .* s + u .* w .* cprime, u .* s + v .* w .* cprime, c + w.^2 .* cprime;
          ];
      
    % extract the phi matrices back out (row cell of phis)
    phi = mat2cell(phi, 3, ones(1, size(phi, 2)/3) * 3);
    
    % multiple every phi matrix by each normal
    n = cell2mat(cellfun(@(x,y) x*y, phi, mat2cell(nprime, 3, ones(1, size(nprime, 2))), 'UniformOutput', false));
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
    
    nestimates = [
                  sin(theta) .* cosphi;
                  sin(theta) .* sinphi;
                  cos(theta);
                 ];

    nestimates = Image2ColVector(nestimates);
end