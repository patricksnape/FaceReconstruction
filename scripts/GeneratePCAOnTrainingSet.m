%% Normals - Assumes I_model exists

[Un_ls, Xn_avg] = normal_pca_from_model(I_model, 10, 'LS');

%% Texture - Assumes I_model exists

% Xt = cellfun(@(x) getfield(x, 'alignedTexture'), I_model, 'UniformOutput', false);
% Xt = cellfun(@(x) Image2ColVector(x), Xt, 'UniformOutput', false);
% Xt = cell2mat(Xt');
% 
% XTavg = sum(Xt, 2);
% XTavg = XTavg/size(Xt, 2);
% 
% XTnorm = Xt - repmat(XTavg, 1, 199);
% Tpcaerror = pca_error(Xt, XTavg);
% 
% Ut = myGPCA(XTnorm, 199, 0);
