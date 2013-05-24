function [spher] = normals2spher(normals)
%SPHERICAL_CORR Summary of this function goes here
%   Detailed explanation goes here

if size(normals, 1) ~= 3
    normals = reshape2colvector(normals);
end

x = normals(1, :);
y = normals(2, :);
z = normals(3, :);

xyz = sqrt(x.^2 + y.^2 + z.^2);

xy = sqrt(x.^2 + y.^2);

gx  = x ./ xy;
gy  = y ./ xy;
gz  = z ./ xyz;
sgz = sqrt(1 - gz .^ 2);

spher = reshape([gx; gy; gz; sgz], [], 1);
spher(isnan(spher)) = 0;

end

