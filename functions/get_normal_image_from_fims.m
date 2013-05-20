function [normal_images] = get_normal_image_from_fims(fim_folder_path, x_offset, x_size, y_offset, y_size)

%% Load model from fim files
file_names = arrayfun(@(x) getfield(x, 'name'), dir(sprintf('%s/*.fim', fim_folder_path)), 'UniformOutput', false);

K = size(file_names, 1);
images = zeros(y_size, x_size, 3, K);

offset_matrix = [1 0 x_offset; 0 1 y_offset; 0 0 1];

tmplt_coords = [1, 1; 1 y_size; x_size y_size; x_size 1;]';

for i=1:K
    fim = read_fim(sprintf('%s/%s', fim_folder_path, file_names{i}));
    images(:, :, 1, i) = quadtobox(fim(:, :, 1), tmplt_coords, offset_matrix);
    images(:, :, 2, i) = quadtobox(fim(:, :, 2), tmplt_coords, offset_matrix);
    images(:, :, 3, i) = quadtobox(fim(:, :, 3), tmplt_coords, offset_matrix);
end

%% Compute normals
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