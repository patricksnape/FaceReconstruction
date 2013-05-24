if (~exist('I_model', 'var'))
    load('data/trainingset')
end
% if (~exist('D', 'var'))
%     load('data/pga');
% end
if (~exist('lights', 'var'))
    load('data/lights');
end
close all;
light = (lights(:,1) / colnorm(lights(:,1)))';
subjects = {'bej', 'bln', 'fav', 'mut', 'pet', 'rob' 'srb'};

AlignAllAlex
if (~exist('Un_ls', 'var'))
    GenerateAllPCAOnTrainingSet
end

for i=1:length(subjects)
    tex = eval(sprintf('%saligned1', subjects{i}));
    %%
    n_ls = SmithGSS_generic('LS', rgb2gray(tex), Un_ls, Xn_avg, light);
    SaveFigures(subjects{i}, 'ls', n_ls, rgb2gray(tex));
    %%
    n_aep = SmithGSS_generic('AEP', rgb2gray(tex), Un_aep, Xn_avg, light);
    SaveFigures(subjects{i}, 'aep', n_aep, rgb2gray(tex));
    %%
    n_spher = SmithGSS_generic('SPHER', rgb2gray(tex), Un_spher, Xn_avg, light);
    SaveFigures(subjects{i}, 'spher', n_spher, rgb2gray(tex));
    %%
    n_ip = SmithGSS_generic('IP', rgb2gray(tex), Un_ip, Xn_avg, light);
    SaveFigures(subjects{i}, 'ip', n_ip, rgb2gray(tex));
    %%
    n_azi = SmithGSS_generic('AZI', rgb2gray(tex), Un_azi, Xn_avg, light);
    SaveFigures(subjects{i}, 'azi', n_azi, rgb2gray(tex));
    %%
    n_ele = SmithGSS_generic('ELE', rgb2gray(tex), Un_ele, Xn_avg, light);
    SaveFigures(subjects{i}, 'ele', n_ele, rgb2gray(tex));
    %% TODO
%     n_pga = SmithPGAGSS(rgb2gray(tex), Un_pga, Xn_avg, mus, light);
%     SaveFigures(subjects{i}, 'pga', n_pga, rgb2gray(tex));
    %%
    [nground, groundtex] = FourImagePhotometricStereo(eval(subjects{i}));
    SaveFigures(subjects{i}, 'ground', nground, rgb2gray(tex));
    %%
    afig = figure(2);
    dataPath = 'data/results';
    
    set(afig,...
        'InvertHardcopy','off',...
        'Position',[300 300 170 150],... %[left, bottom, width, height]
        'PaperPositionMode','auto',...
        'Color',[0 0 0]); % black
    
    angular_error_ls = AngularError(nground, n_ls);
    imshow(angular_error_ls, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'ls', subjects{i});
    print('-dpng',filePath);
    
    angular_error_aep = AngularError(nground, n_aep);
    imshow(angular_error_aep, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'aep', subjects{i});
    print('-dpng',filePath);
    
    angular_error_spher = AngularError(nground, n_spher);
    imshow(angular_error_spher, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'spher', subjects{i});
    print('-dpng',filePath);
    
    angular_error_azi = AngularError(nground, n_azi);
    imshow(angular_error_azi, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'azi', subjects{i});
    print('-dpng',filePath);
    
    angular_error_ele = AngularError(nground, n_ele);
    imshow(angular_error_ele, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'ele', subjects{i});
    print('-dpng',filePath);
    
    angular_error_ip = AngularError(nground, n_ip);
    imshow(angular_error_ip, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'ip', subjects{i});
    print('-dpng',filePath);
%% TODO    
%     angular_error_pga = AngularError(nground, n_pga);
%     imshow(angular_error_pga, 'Border','tight');
%     filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'pga', subjects{i});
%     print('-dpng',filePath);  
    imshow(tex, 'Border','tight');
    filePath = sprintf('%s/%s/%sfull.png', dataPath, subjects{i}, subjects{i});
    print('-dpng',filePath);
    
    imshow(rgb2gray(tex), 'Border','tight');
    filePath = sprintf('%s/%s/%sgrayscale.png', dataPath, subjects{i}, subjects{i});
    print('-dpng',filePath);
    
    angular_error_all = zeros(7, 1);
    angular_error_all(1, 1) = sum(sum(angular_error_aep));
    angular_error_all(2, 1) = sum(sum(angular_error_azi));
    angular_error_all(3, 1) = sum(sum(angular_error_ele));
    angular_error_all(4, 1) = sum(sum(angular_error_ip));
    angular_error_all(5, 1) = sum(sum(angular_error_ls));
% TODO     angular_error_all(6, 1) = sum(sum(angular_error_pga));
    angular_error_all(7, 1) = sum(sum(angular_error_spher));

    filePath = sprintf('%s/%s/angularerror.mat', dataPath, subjects{i});
    save(filePath, 'angular_error_all');
end
