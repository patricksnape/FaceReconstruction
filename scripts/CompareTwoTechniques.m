load('data/trainingset')
% % load('data/pga');
% load('data/lights');
% light = lights(:,1) / colnorm(lights(:,1));
light = [0;0;1];
texture = I_model{1}.alignedTexture;
GeneratePCAOnTrainingSet
% % GenerateAEPPCAOnTrainingSet
% 
% figure(1);
% clf;
% [error b n] = SmithGSS(texture, Un, XNavg, light');
% TexturizeRecoveredFace(texture, n);

% figure(2);
% clf;
% [b naep] = SmithAEPGSS(texture, UAEPn, XNavg, light');
% TexturizeRecoveredFace(texture, naep);

figure(3);
clf;
[ a c ] = NewReconstruction(texture,Un, Ut, XTavg, XNavg, light);
[nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
TexturizeRecoveredFace(texture, nestimate);

% figure(4);
% clf;
% [ b npga ] = SmithPGAGSS(texture, UPGA, XNavg, mus, light');
% TexturizeRecoveredFace(texture, npga);

% figure(5);
% clf;
% TexturizeRecoveredFace(texture, I_model{197}.alignedNormals);

% smithError = AngularError(I_model{197}.alignedNormals, n)
% AEPError = AngularError(I_model{197}.alignedNormals, naep)
% PGAError = AngularError(I_model{197}.alignedNormals, npga)
% myError = AngularError(I_model{197}.alignedNormals, nestimate)