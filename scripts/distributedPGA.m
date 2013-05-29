%% Assumes CreateData has been run. Calculates all spherical medians.
clc;
worker_count = 25;
% Get a handle to the job manager:
cluster =  parcluster('beehive');

% Create a job:
djob = createJob(cluster, 'NumWorkersRange', [1 worker_count]);

tic;
% Allows me to use a subset of the training_set
if (iscell(I_model))
    normals_set = cellfun(@(x) getfield(x, 'alignedNormals'), I_model, 'UniformOutput', false);
    normals_set = cellfun(@(x) Image2ColVector3(x), normals_set, 'UniformOutput', false);
    normals_set = cell2mat(normals_set');
else
    normals_set = I_model;
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
% amount of distribution
stride = floor(N / (worker_count - 1));
i = 1;

try
    disp('Generating intrinsic means for each normal');
    while i < N
        maxval = min(i + stride, N);
        normalp = squeeze(vec_normals(:, i:maxval, :));
        mean_normalp = mean_normals_set(:, i:maxval);
        createTask(djob, @spherical_median_wrapper, 1, {normalp, mean_normalp});
        i = i + stride + 1;
    end

    submit(djob);

    % Have the program wait for it to finish:
    wait(djob, 'finished');

    % Get the output arguments:
    mus_cell = fetchOutputs(djob);
    save('mus_cell.mat', 'mus_cell');
catch err
    % Destroy the job after you're finished:
    delete(djob);
    rethrow(err);
end

% Delete if job hasn't been deleted
if exist('djob', 'var') && strcmp(djob.State, 'deleted') == 0
    % Delete and eat any exceptions
    try
        delete(djob);
    catch
    end
end
clear i mean_normalp normalp stride maxval normals_set;

mus = zeros(3, N);
n = 1;

for i=1:size(mus_cell, 1)
   d = mus_cell{i};
   count = min(size(d, 2), N);
   mus(:, n:n+count-1) = d;
   n = n + count;
end

clear n mu count i mus_cell;

%% Create a new job and calculate Ds
djob = createJob(cluster, 'NumWorkersRange', [1 worker_count]);


% Calculate D
disp('Generating D');

% for each face
try
    for i = 1:K
        normals = squeeze(vec_normals(:, :, i));
        createTask(djob, @calculate_D_wrapper, 1, {normals, mus});
    end
    submit(djob);
    % Have the program wait for it to finish:
    wait(djob, 'finished');

    % Get the output arguments:
    D_cell = fetchOutputs(djob);
    save('D_cell.mat', 'D_cell');
catch err
    % Destroy the job after you're finished:
    delete(djob);
    rethrow(err);
end

% Delete if job hasn't been deleted
if exist('djob', 'var') && strcmp(djob.State, 'deleted') == 0
    % Delete and eat any exceptions
    try
        delete(djob);
    catch
    end
end

% Column vector
D = zeros(N * 3, K);

for i=1:K
   D(:, i) = D_cell{i};
end

clear normals i D_cell;

% Calculate Average D

disp('Generating DAvg');

% for all normals
vk = logmap(mus, mean_normals_set);
D_avg = reshape(vk, [], 1);
disp('Finished generating PGA');

% Clean-up workspace
clear normals vk i k vec_normals worker_count base djob cluster K N err mean_normals_set;

save('pga_trainingset.mat', 'D', 'D_avg', 'mus');
toc;