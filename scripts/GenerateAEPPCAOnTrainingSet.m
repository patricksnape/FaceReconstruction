%% Normals - Assumes I_model exists

Xn = cellfun(@(x) getfield(x, 'alignedNormals'), I_model, 'UniformOutput', false);
Xn = cellfun(@(x) Image2ColVector3(x), Xn, 'UniformOutput', false);
Xn = cell2mat(Xn');

XNavg = sum(Xn, 2);
XNavg = XNavg/size(Xn, 2);

Xn = spherical2azimuthal(Xn, XNavg);
Naeppcaerror = pca_error(Xn, XNavg);
UAEPn = myGPCA(Xn, 199, 0);