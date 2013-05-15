%% Normals - Assumes I_model exists

[Un_corrupt, Xn_corrupt_avg] = normal_pca_from_model(I_model_corrupt, 5, 'LS');

%% Texture - Assumes I_model exists

% Xt_corrupt = cellfun(@(x) getfield(x, 'alignedTexture'), I_model_corrupt, 'UniformOutput', false);
% Xt_corrupt = cellfun(@(x) Image2ColVector(x), Xt_corrupt, 'UniformOutput', false);
% Xt_corrupt = cell2mat(Xt_corrupt');
% 
% XT_corrupt_avg = sum(Xt_corrupt, 2);
% XT_corrupt_avg = XT_corrupt_avg/size(Xt_corrupt, 2);
% 
% XT_corrupt_norm = Xt_corrupt - repmat(XT_corrupt_avg, 1, 199);
% T_corrupt_pcaerror = pca_error(Xt_corrupt, XT_corrupt_avg);
% 
% Ut_corrupt = myGPCA(XT_corrupt_norm, 199, 0);