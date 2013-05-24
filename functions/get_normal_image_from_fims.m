function [normal_images] = get_normal_image_from_fims(fim_folder_path, x_offset, x_size, y_offset, y_size)

%% Load model from fim files
file_names = arrayfun(@(x) getfield(x, 'name'), dir(sprintf('%s/*.fim', fim_folder_path)), 'UniformOutput', false);

K = size(file_names, 1);
images = zeros(y_size, x_size, 3, K);

for i=1:K
    images(:, :, :, i) = load_crop_fim(sprintf('%s/%s', fim_folder_path, file_names{i}), x_offset, x_size, y_offset, y_size);
end

normal_images = compute_normals_from_shape_images(images, x_size, y_size);