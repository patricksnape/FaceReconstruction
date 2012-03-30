%% Assumes I_model exists

X = cellfun(@(x) getfield(x, 'aligned'), I_model, 'UniformOutput', false);
X = cellfun(@(x) Image2ColVector3(x), X, 'UniformOutput', false);
X = cell2mat(X');

Xavg = sum(X, 2);
Xavg = Xavg/size(X, 2);

Xnorm = X - repmat(Xavg, 1, 199);
pcaerror = pca_error(X, Xavg);

U = myGPCA(Xnorm, 199, 0);