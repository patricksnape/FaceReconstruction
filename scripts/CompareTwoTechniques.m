load('data/trainingset')
light = [0;0;1];
GeneratePCAOnTrainingSet
calculatePGA

figure(1);
clf;
[error b n] = SmithGSS(I_model{1}.alignedTexture, Un, XNavg, light');
TexturizeRecoveredFace(I_model{1}.alignedTexture, n);

figure(2);
clf;
[ a c ] = NewReconstruction(I_model{1}.alignedTexture,Un, Ut, light);
[nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
TexturizeRecoveredFace(I_model{1}.alignedTexture, nestimate);

figure(3);
clf;
[ b npga ] = SmithPGAGSS(I_model{1}.alignedTexture, UPGA, mean_normals_set, mus, light');
TexturizeRecoveredFace(I_model{1}.alignedTexture, npga);

figure(4);
clf;
TexturizeRecoveredFace(I_model{1}.alignedTexture, I_model{1}.alignedNormals);

smithError = AngularError(I_model{1}.alignedNormals, n)
PGAError = AngularError(I_model{1}.alignedNormals, npga)
myError = AngularError(I_model{1}.alignedNormals, nestimate)