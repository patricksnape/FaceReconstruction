tic;
clc;
num_images = floor(size(I_model_corrupt, 2) * 0.2);
num_eigs = 10;
worker_count = 40;
% Get a handle to the job manager:
cluster =  parcluster('beehive');

% Create a job:
djob = createJob(cluster, 'NumWorkersRange', [1 worker_count]);

try
    for k=1:num_images
        createTask(djob, @reconstruction_error_wrapper, 1, {I_model_corrupt, D_corrupt, I_model(:, k), I_model_corrupt(:, k), mus_corrupt, num_eigs, projection_type});
    end
    submit(djob);

    % Have the program wait for it to finish:
    wait(djob, 'finished');

    % Get the output arguments:
    reconstructions_cell = fetchOutputs(djob);
    save('reconstructions_cell.mat', 'reconstructions_cell');
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
toc;
% Reshape outputs - every cell is a single result

%% Generate Figure
aep = zeros(num_images, num_eigs);
% azi = zeros(num_images, num_eigs);
% ele = zeros(num_images, num_eigs);
ip = zeros(num_images, num_eigs);
ls = zeros(num_images, num_eigs);
pga = zeros(num_images, num_eigs);
spher = zeros(num_images, num_eigs);

for k=1:num_images
    im = reconstructions_cell{k};
    aep(k, :) = cell2mat(im(1, :));
%     azi(k, :) = cell2mat(im(2, :));
%     ele(k, :) = cell2mat(im(3, :));
    ip(k, :) = cell2mat(im(4, :));
    ls(k, :) = cell2mat(im(5, :));
    pga(k, :) = cell2mat(im(6, :));
    spher(k, :) = cell2mat(im(7, :));
end

clear k im;

%% Generate Figure
var = 1:num_eigs;

aep_mean = mean(aep, 1);
% azi_mean = mean(azi, 1);
% ele_mean = mean(ele, 1);
ip_mean = mean(ip, 1);
ls_mean = mean(ls, 1);
pga_mean = mean(pga, 1);
spher_mean = mean(spher, 1);

f = figure; 
plot(   var, aep_mean, 'r:s', ...
        var, ip_mean, 'r:+', ...
        var, ls_mean, 'b:*',  ...
        var, pga_mean, 'b:o', ...
        var, spher_mean, 'm:^', ...
     'MarkerSize',11, 'linewidth', 2); 
%         var, azi_mean, 'g:*', ...
%         var, ele_mean, 'm:*', ...
ylabel('Angular error from reconstruction', 'fontsize', 15);
xlabel('Number of components k', 'fontsize', 15);
% legend(gca, 'AEP-PCA', 'AZI-PCA', 'ELE-PCA', 'IP-PCA', 'L2-PCA', 'PGA', 'SPHER-PCA');
legend(gca, 'AEP-PCA', 'IP-PCA', 'L2-PCA', 'PGA', 'SPHER-PCA', 'Location', 'SouthEast');
set(f, 'Position', [0, 0, 640, 480]);