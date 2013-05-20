function [I_model, I_model_corrupt ] = models_from_normal_images(normal_images, percentage_x, percentage_y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Compute I_model
K = size(normal_images, 4);
x_size = size(normal_images, 1);
y_size = size(normal_images, 2);
I_model = zeros(x_size * y_size * 3, K);

for i=1:K
   x = reshape(normal_images(:, :, 1, i), 1, []);
   y = reshape(normal_images(:, :, 2, i), 1, []);
   z = reshape(normal_images(:, :, 3, i), 1, []);
   vs = [x; y; z];
   I_model(:, i) = reshape(vs, [y_size * x_size * 3, 1]);
end

%% Corrupt images
coord_x = size(normal_images, 1);
coord_y = size(normal_images, 2);
sample_count = size(normal_images, 4);
I_model_corrupt = zeros(coord_x * coord_y * 3, sample_count);

normal_images_corrupt = zeros(coord_x, coord_y, 3, sample_count);
outlier_width = round(percentage_x * coord_x);
outlier_height = round(percentage_y * coord_y);

outlier = generate_outlier(outlier_width, outlier_height);

for i=1:sample_count
    normal_images_corrupt(:, :, :, i) = normal_images(:, :, :, i);
    % Corrupt 20% of the imagess
    if (i < (0.2 * sample_count))
        x = randi(coord_x - outlier_width - 1);
        y = randi(coord_y - outlier_height - 1);
        normal_images_corrupt(x:(x+(outlier_width - 1)), y:(y+(outlier_height - 1)), :, i) = outlier;
    end
   
    x = reshape(normal_images_corrupt(:, :, 1, i), 1, []);
    y = reshape(normal_images_corrupt(:, :, 2, i), 1, []);
    z = reshape(normal_images_corrupt(:, :, 3, i), 1, []);
    vs = [x; y; z];
    I_model_corrupt(:, i) = reshape(vs, [y_size * x_size * 3, 1]);
end

