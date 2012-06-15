if (~exist('I_model', 'var'))
    load('data/trainingset')
end
if (~exist('D', 'var'))
    load('data/pga');
end
if (~exist('lights', 'var'))
    load('data/lights');
end
close all;
light = lights(:,1) / colnorm(lights(:,1));
subjects = {'bej', 'bln', 'fav', 'mut', 'pet', 'rob' 'srb'};

% light1(:, 2) = lights(:,2) / colnorm(lights(:,2));
% light1(:, 3) = lights(:,3) / colnorm(lights(:,3));
% light1(:, 4) = lights(:,4) / colnorm(lights(:,4));
% light1 = [0;0;1];

AlignAllAlex
if (~exist('Un', 'var'))
    GeneratePCAOnTrainingSet
end
if (~exist('UAEPn', 'var'))
    GenerateAEPPCAOnTrainingSet
end

for i=1:length(subjects)
    tex = eval(sprintf('%saligned1', subjects{i}));
    %%
    [error b n] = SmithGSS(rgb2gray(tex), Un, XNavg, light');
    SaveFigures(subjects{i}, 'smith', n, rgb2gray(tex));
    %%
    [b naep] = SmithAEPGSS(rgb2gray(tex), UAEPn, XNavg, light');
    SaveFigures(subjects{i}, 'aep', naep, rgb2gray(tex));
    %%
    [ a c ] = NewReconstruction(rgb2gray(tex),Un, Ut, XTavg, XNavg, light);
    [nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
    SaveFigures(subjects{i}, 'novel', nestimate, rgb2gray(tex), testimate);
%     figure;
%     clf;
%     textures(:, :, 1) = rgb2gray(mutaligned1);
%     textures(:, :, 2) = rgb2gray(mutaligned2);
%     textures(:, :, 2) = rgb2gray(mutaligned3);
%     textures(:, :, 2) = rgb2gray(mutaligned4);
%     [ amulti cmulti ] = NewReconstructionMulti(textures, Un, Ut, XTavg, XNavg, lights);
%     [nestimatemulti testimatemulti] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, cmulti, amulti);
%     TexturizeRecoveredFace(tex, nestimatemulti);
%     figure;
%     imshow(testimatemulti);
    %%
    [ b npga ] = SmithPGAGSS(rgb2gray(tex), UPGA, XNavg, mus, light');
    SaveFigures(subjects{i}, 'pga', npga, rgb2gray(tex));
    %%
    [nground groundtex] = FourImagePhotometricStereo(eval(subjects{i}));
    SaveFigures(subjects{i}, 'ground', nground, rgb2gray(tex));
    %%
    figure(2);
    dataPath = 'data/results';
    
    smithError = AngularError(nground, n);
    imshow(smithError, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'smith', subjects{i});
    print('-dpng',filePath);
    
    AEPError = AngularError(nground, naep);
    imshow(AEPError, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'aep', subjects{i});
    print('-dpng',filePath);
    
    PGAError = AngularError(nground, npga);
    imshow(PGAError, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'pga', subjects{i});
    print('-dpng',filePath);
    
    novelError = AngularError(nground, nestimate);
    imshow(novelError, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, subjects{i}, 'novel', subjects{i});
    print('-dpng',filePath);
    
    angerr = zeros(4, 1);
    angerr(1, 1) = sum(sum(smithError));
    angerr(2, 1) = sum(sum(AEPError));
    angerr(3, 1) = sum(sum(PGAError));
    angerr(4, 1) = sum(sum(novelError));
    filePath = sprintf('%s/%s/angularerror.mat', dataPath, subjects{i});
    save(filePath, 'angerr');
end
