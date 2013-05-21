function [ msn ] = mean_surface_norm(normals)
%MEAN_SURFACE_NORM Calculate the mean surface normal of a set of normals
%   Given the normals of k images (k = size(normals, 2))
%   calculates the mean surface normal at each point - as a unit vector
%   returns result as a single column matrix representing 
%   ( x1; y1; z1; x2; ...)

nbar = sum(normals, 2) / size(normals, 2);
nbar = reshape(nbar, 3, []);

mag = colnorm(nbar);
msn = reshape(bsxfun(@rdivide, nbar, mag), [], 1]);

end