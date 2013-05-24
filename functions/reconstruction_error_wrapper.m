function [ errors ] = reconstruction_error_wrapper(I_model_corrupt, D_corrupt, uncorrupted_image, corrupted_image, mus_corrupt, num_eigs)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

errors = cell(7, num_eigs);

% (1, aep), (2, azi), (3, ele), (4, ip), (5, ls), (6, pga), (7, spher)

for e=1:num_eigs
        errors{1, e} = sum(normal_reconstruction_error(I_model_corrupt, uncorrupted_image, corrupted_image, 'AEP', e));
        errors{2, e} = sum(normal_reconstruction_error(I_model_corrupt, uncorrupted_image, corrupted_image, 'AZI', e));
        errors{3, e} = sum(normal_reconstruction_error(I_model_corrupt, uncorrupted_image, corrupted_image, 'ELE', e));
        errors{4, e} = sum(normal_reconstruction_error(I_model_corrupt, uncorrupted_image, corrupted_image, 'IP', e));
        errors{5, e} = sum(normal_reconstruction_error(I_model_corrupt, uncorrupted_image, corrupted_image, 'LS', e));
        errors{6, e} = sum(normal_reconstruction_error(D_corrupt,       uncorrupted_image, corrupted_image, 'PGA', e, 'mus', mus_corrupt));
        errors{7, e} = sum(normal_reconstruction_error(I_model_corrupt, uncorrupted_image, corrupted_image, 'SPHER', e));
end

