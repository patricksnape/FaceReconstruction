function [ shape texture ] = randomFace( model )
%RANDOMFACE Summary of this function goes here
%   Create one random face

model_size = 150;
alphas = randn(199, 199);
alphas2 = (alphas .* repmat(sqrt(model.shapeEV'), 199, 1)).^2;

betas = randn(199, 199);
betas2 = (betas .* repmat(sqrt(model.textureEV'), 199, 1)).^2;

alphaArray = model_size * (alphas2 ./ repmat(sum(abs(alphas2), 1), 199, 1));
betaArray = model_size * (betas2 ./ repmat(sum(abs(betas2), 1), 199, 1));

shape = model.shapeMean * ones([1 199]) + model.shapePC(:,1:199) * (alphaArray .* (model.shapeEV(1:199) * ones([1 199])));
shape = shape(:,1);
texture = model.textureMean * ones([1 199]) + model.texturePC(:,1:199) * (betaArray .* (model.textureEV(1:199) * ones([1 199])));
texture = texture(:,1);
end

