function [ image ] = load_crop_fim(path, x_offset, x_size, y_offset, y_size)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

offset_matrix = [1 0 x_offset; 0 1 y_offset; 0 0 1];

tmplt_coords = [1, 1; 1 y_size; x_size y_size; x_size 1;]';

fim = read_fim(path);
image(:, :, 1) = quadtobox(fim(:, :, 1), tmplt_coords, offset_matrix);
image(:, :, 2) = quadtobox(fim(:, :, 2), tmplt_coords, offset_matrix);
image(:, :, 3) = quadtobox(fim(:, :, 3), tmplt_coords, offset_matrix);

end

