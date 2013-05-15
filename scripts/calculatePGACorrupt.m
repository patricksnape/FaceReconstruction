%% Assumes CreateData has been run. Calculates all spherical medians.
tic;
% Allows me to use a subset of the training_set
if (iscell(I_model_corrupt))
    normals_set = cellfun(@(x) getfield(x, 'alignedNormals'), I_model_corrupt, 'UniformOutput', false);
    normals_set = cellfun(@(x) Image2ColVector3(x), normals_set, 'UniformOutput', false);
    normals_set = cell2mat(normals_set');
else
    normals_set = I_model_corrupt;
end
%normals_set = normals_set(:, 1:3);

% Reshape so that every column is stacked behind one another
% This is so we can parfor the min finding
vec_normals = reshape(normals_set, [size(normals_set, 1), 1, size(normals_set, 2)]);
vec_normals = reshape(normals_set, [3, size(normals_set, 1) / 3, size(normals_set, 2)]);

mean_normals_set = mean(vec_normals, 3);

% N = number of vertices
N = size(vec_normals, 2);
% K = number of faces
K = size(vec_normals, 3);
mus = zeros(3, N);

disp('Generating intrinsic means for each normal');
parfor i = 1:N
    normalp = squeeze(vec_normals(:, i, :));
    
% Must also change sphericalmedian to reflect the change in minimisation
    mus(:, i) = fminsearch(@(x) sphericalmedian(x, normalp), mean_normals_set(:, i));
%     mus(:, i) = sphericalmedian(mean_normals_set(:, i), normalp);
end
clear i normalp mu options;

%% Calculate D
% Column vector
D_corrupt = zeros(N * 3, K);

disp('Generating D');
% for each face
for i = 1:K
    normals = squeeze(vec_normals(:, :, i));
    vk = zeros(3, N);
    % for all normals
    parfor k = 1:N
        vk(:, k) = logmap(mus(:, k), normals(:, k));
    end
    D_corrupt(:, i) = reshape(vk, [], 1);
end

clear normals;
clear vk;

%% Calculate Average D

disp('Generating DAvg');
D_corrupt_avg = zeros(N * 3, 1);
vk = zeros(3, N);

% for all normals
parfor k = 1:N   
    vk(:, k) = logmap(mus(:, k), mean_normals_set(:, k));
end
D_corrupt_avg(:, 1) = reshape(vk, [], 1);
disp('Finished generating DAvg');

clear normals vk i k;

save('pga_corrupt_F001_disgust.mat', 'D_corrupt', 'D_corrupt_avg', 'mus', 'I_model_corrupt');
toc;