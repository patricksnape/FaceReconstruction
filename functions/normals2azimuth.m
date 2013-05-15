function [G, xy] = normals2azimuth( normals )
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

if size(normals, 1) ~= 3
    normals = reshape2colvector(normals);
end

x = reshape(normals(1, :), [], 1);
y = reshape(normals(2, :), [], 1);
z = reshape(normals(3, :), [], 1);

xyz = sqrt(x.^2 + y.^2 + z.^2);

xy = sqrt(x.^2 + y.^2);

gx  = x ./ xy; 
gy  = y ./ xy;
gz  = z ./ xyz;
sgz = sqrt(1 - gz .^ 2);

G = [gx; gy;];
G(isnan(G)) = 0;

end

