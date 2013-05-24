%% Setup environment
x_size = 250;
x_offset = 138;
y_size = 350;
y_offset = 64;

apexes = zeros(y_size, x_size, 3, size(apex, 1));
neutrals = zeros(y_size, x_size, 3, size(apex, 2));

for i=1:size(apex, 1)
    cropped = load_crop_fim(deblank(apex(i, :)), x_offset, x_size, y_offset, y_size);
    apexes(:, :, :, i) = compute_normals_from_shape_images(cropped, x_size, y_size);
    if i <= size(neutral, 1)
        cropped = load_crop_fim(deblank(neutral(i, :)), x_offset, x_size, y_offset, y_size);
        neutrals(:, :, :, i) = compute_normals_from_shape_images(cropped, x_size, y_size);
    end
end

[I_model, I_model_corrupt] = models_from_normal_images(neutrals, 0.2, 0.2);