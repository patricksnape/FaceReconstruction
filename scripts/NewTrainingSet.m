Xnew = cellfun(@(x) getfield(x, 'alignedNormals'), I_model, 'UniformOutput', false);
Xnew = cellfun(@(x) Image2ColVector3(x), Xnew, 'UniformOutput', false);
Xnew = cell2mat(Xnew');
Xnew = Xnew(:, 1:196);

XNavg = sum(Xnew, 2);
XNavg = XNavg/size(Xnew, 2);

XNnorm = Xnew - repmat(XNavg, 1, 196);
Npcaerror = pca_error(Xnew, XNavg);

Un = myGPCA(XNnorm, 195, 0);

%% Texture - Assumes I_model exists

XTNew = cellfun(@(x) getfield(x, 'alignedTexture'), I_model, 'UniformOutput', false);
XTNew = cellfun(@(x) Image2ColVector(x), XTNew, 'UniformOutput', false);
XTNew = cell2mat(XTNew');
XTNew = XTNew(:, 1:196);

XTavg = sum(XTNew, 2);
XTavg = XTavg/size(XTNew, 2);

XTnorm = XTNew - repmat(XTavg, 1, 196);
Tpcaerror = pca_error(XTNew, XTavg);

Ut = myGPCA(XTnorm, 195, 0);