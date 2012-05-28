load('data/trainingset')
light = [0;0;1];
AlignTrainingSet
GeneratePCAOnTrainingSet

figure(1);
clf;
[error b n] = SmithGSS(I_model{1}.alignedTexture, Un, XNavg, light');
TexturizeRecoveredFace(I_model{1}.alignedTexture, n);

figure(2);
clf;
[ a c ] = NewReconstruction(I_model{1}.alignedTexture,Un, Ut, light);
[nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
TexturizeRecoveredFace(I_model{1}.alignedTexture, nestimate, ones(size(nestimate)));

figure(3);
clf;
TexturizeRecoveredFace(I_model{1}.alignedTexture, I_model{1}.alignedNormals, ones(size(I_model{1}.alignedNormals)));

smithError = AngularError(I_model{1}.alignedNormals, n)
myError = AngularError(I_model{1}.alignedNormals, nestimate)