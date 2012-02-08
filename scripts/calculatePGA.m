%% Assumes generateTrainingSet has been run. Calculates all spherical medians.

N = size(training_set.normals, 1) / 3;
mus = zeros(3, N);

disp('Generating intrinsic means for each normal...');

for i = 1:3:N
    normalp = [training_set.normals(i, :); training_set.normals(i+1, :); training_set.normals(i+2, :)];
    % column vector
    normalp = reshape(normalp, [], 1);
    mu = sphericalmedian(normalp);

    mus(:, ceil(i / 3)) = mu;  
    progressbar(i, N);
end
disp(' ');
disp('Finished generating intrinsic means for each normal.');

% column vector
%mus = reshape(mus, [], 1);

clear i;
clear normalp;
clear mu;

%% Calculate D

K = size(training_set.normals, 2);
D = zeros(N * 3, K);
normals = reshape(training_set.normals, [3 numel(training_set.normals)/3]);

disp('Generating D...');
% for each face
for i = 1:K
    vk = zeros(3, N);
    % for all normals
    parfor k = 1:N
        vk(:, k) = logmap(mus(:, k), normals(:, k));
    end
    D(:, i) = reshape(vk, [], 1);
    progressbar(i, K);
end
disp(' ');
disp('Finished generating D.');

clear normals;
clear vk;

%% Calculate Average D

disp('Generating DAvg...');
DAvg = zeros(N * 3, 1);
normals = reshape(training_set.mean_surface_norm, [3 numel(training_set.mean_surface_norm)/3]);
vk = zeros(3, N);

% for all normals
parfor k = 1:N   
    vk(:, k) = logmap(mus(:, k), normals(:, k));
end
DAvg(:, 1) = reshape(vk, [], 1);
disp('Finished generating DAvg...');

clear normals;
clear vk;