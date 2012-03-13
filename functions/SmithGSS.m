function [ output ] = SmithGSS( image, P )
%SMITHGSS Summary of this function goes here
%   Detailed explanation goes here

n = EstimateNormals(image);
v0 = spherical2azimuthal(n, n);

b = P' * v0;
end

function t = Theta(image)
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