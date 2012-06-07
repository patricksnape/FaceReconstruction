function [ model ] = AlignMorphableModel( model )
%ALIGNMORPHABLEMODEL Summary of this function goes here
%   Detailed explanation goes here

shape = model.shape;
normbuffer = model.normBuffer;
texture = rgb2gray(model.textureBuffer);

alignedNormals = AlignFace(normbuffer, ...
                               shape(1,2), ... % Nose Y
                               shape(2,2), ... % Left Eye Y
                               shape(3,2), ... % Right Eye Y
                               shape(4,2), ... % Chin Y
                               shape(1,1), ... % Nose X
                               shape(2,1), ... % Left Eye X
                               shape(3,1), ... % Right Eye X
                               shape(4,1));    % Chin X

alignedTexture = AlignFace(texture, ...
                               shape(1,2), ... % Nose Y
                               shape(2,2), ... % Left Eye Y
                               shape(3,2), ... % Right Eye Y
                               shape(4,2), ... % Chin Y
                               shape(1,1), ... % Nose X
                               shape(2,1), ... % Left Eye X
                               shape(3,1), ... % Right Eye X
                               shape(4,1));    % Chin X

ysize = size(alignedNormals, 2);
xsize = size(alignedNormals, 1);

alignedNormals = reshape2colvector(Image2ColVector3(alignedNormals));
cnorm = colnorm(alignedNormals);
alignedNormals = reshape(bsxfun(@rdivide, alignedNormals, cnorm), [], 1);
alignedNormals(isnan(alignedNormals)) = 0;
alignedNormals = ColVectorToImage3(alignedNormals, xsize, ysize);

model.alignedNormals = alignedNormals;
model.alignedTexture = alignedTexture;

end

