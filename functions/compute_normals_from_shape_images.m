function [ normal_images ] = compute_normals_from_shape_images(images, x_size, y_size)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

K = size(images, 4);
normal_images = zeros(y_size, x_size, 3, K);
[xg, yg] = meshgrid(1:x_size, 1:y_size);
tri = delaunay(xg, yg);

for i=1:K
   x = reshape(images(:, :, 1, i), 1, []);
   y = reshape(images(:, :, 2, i), 1, []);
   z = reshape(images(:, :, 3, i), 1, []);
   vs = [x; y; z];
   n = compute_normal(vs, tri);
   normal_images(:, :, 1, i) = reshape(n(1, :), [y_size, x_size]);
   normal_images(:, :, 2, i) = reshape(n(2, :), [y_size, x_size]);
   normal_images(:, :, 3, i) = reshape(n(3, :), [y_size, x_size]);
end

end

