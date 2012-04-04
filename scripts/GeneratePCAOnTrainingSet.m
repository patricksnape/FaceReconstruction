%% Normals - Assumes I_model exists

Xn = cellfun(@(x) getfield(x, 'alignedNormals'), I_model, 'UniformOutput', false);
Xn = cellfun(@(x) Image2ColVector3(x), Xn, 'UniformOutput', false);
Xn = cell2mat(Xn');

XNavg = sum(Xn, 2);
XNavg = XNavg/size(Xn, 2);

XNnorm = Xn - repmat(XNavg, 1, 199);
Npcaerror = pca_error(Xn, XNavg);

Un = myGPCA(XNnorm, 199, 0);

%% Texture - Assumes I_model exists

Xt = cellfun(@(x) getfield(x, 'alignedTexture'), I_model, 'UniformOutput', false);
Xt = cellfun(@(x) Image2ColVector3(x), Xt, 'UniformOutput', false);
Xt = cell2mat(Xt');

XTavg = sum(Xt, 2);
XTavg = XTavg/size(Xt, 2);

XTnorm = Xt - repmat(XTavg, 1, 199);
Tpcaerror = pca_error(Xt, XTavg);

Ut = myGPCA(XTnorm, 199, 0);