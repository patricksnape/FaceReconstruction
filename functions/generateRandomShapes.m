function shapes = generateRandomShapes(base_morphable_model)

%% base_morphable_model = load_model('morphable_model.mat')

%% Define Shape Parameters

% This number defines how far from the mean face the training set deviates
model_size = 120;

alphas = randn(199, 199);
alphaArray = model_size * (alphas ./ repmat(sum(abs(alphas), 1), 199, 1));


%% Define Texture Parameters

% Currently unused (only need shape)
betas = randn(199, 199);
betaArray = model_size * (betas ./ repmat(sum(abs(betas), 1), 199, 1));


%% Generate Data

display('Creating face shapes...')

% Empty training set
shapes = zeros(size(base_morphable_model.shapeMU, 1), 200);

shapeMU = base_morphable_model.shapeMU;
shapePC = base_morphable_model.shapePC;
shapeEV = base_morphable_model.shapeEV;

parfor_progress(199);

parfor i = 1:199
    shapes(:, i) = coef2object(alphaArray(i), shapeMU, shapePC, shapeEV);
    parfor_progress;
end

parfor_progress(0);

%% Use the mean model as the last face in the dataset

shapes(:, 200) = coef2object(zeros(199, 1), shapeMU, shapePC, shapeEV);

display('Finished creating face shapes')

end

