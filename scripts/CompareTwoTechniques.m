% load('data/trainingset')
% load('data/pga');
load('data/lights');
light1(:, 1) = lights(:,1) / colnorm(lights(:,1));
light1(:, 2) = lights(:,2) / colnorm(lights(:,2));
light1(:, 3) = lights(:,3) / colnorm(lights(:,3));
light1(:, 4) = lights(:,4) / colnorm(lights(:,4));
% light = [0;0;1];
texture = rgb2gray(mutaligned);
close all;
% GeneratePCAOnTrainingSet
% GenerateAEPPCAOnTrainingSet
% 
% figure;
% clf;
% [error b n] = SmithGSS(texture, Un, XNavg, light');
% TexturizeRecoveredFace(texture, n);

% figure;
% clf;
% [b naep] = SmithAEPGSS(texture, UAEPn, XNavg, light');
% TexturizeRecoveredFace(texture, naep);

figure;
clf;
[ a c ] = NewReconstruction(texture,Un, Ut, XTavg, XNavg, light1);
[nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
TexturizeRecoveredFace(texture, nestimate);
figure;
imshow(testimate);

figure;
clf;
textures(:, :, 1) = rgb2gray(mutaligned1);
textures(:, :, 2) = rgb2gray(mutaligned2);
textures(:, :, 2) = rgb2gray(mutaligned3);
textures(:, :, 2) = rgb2gray(mutaligned4);
[ amulti cmulti ] = NewReconstructionMulti(textures, Un, Ut, XTavg, XNavg, light1);
[nestimatemulti testimatemulti] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, cmulti, amulti);
TexturizeRecoveredFace(texture, testimatemulti);
figure;
imshow(testimatemulti);

% figure;
% clf;
% [ b npga ] = SmithPGAGSS(texture, UPGA, XNavg, mus, light');
% TexturizeRecoveredFace(texture, npga);

% figure;
% clf;
% TexturizeRecoveredFace(texture, I_model{197}.alignedNormals);

% smithError = AngularError(I_model{197}.alignedNormals, n)
% AEPError = AngularError(I_model{197}.alignedNormals, naep)
% PGAError = AngularError(I_model{197}.alignedNormals, npga)
% myError = AngularError(I_model{197}.alignedNormals, nestimate)