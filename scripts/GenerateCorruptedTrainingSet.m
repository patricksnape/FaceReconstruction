%% Assumes I_model exists

I_model_corrupt = cell(199, 1);

for i=1:199
    I_model_corrupt{i} = AlignMorphableModel(I_model{i});
    
    % Corrupt 20% of the imagess
    if (i < 40)
        x_offset = randi(size(I_model_corrupt{i}.alignedTexture, 2) - size(outlier, 2));
        y_offset = randi(size(I_model_corrupt{i}.alignedTexture, 1) - size(outlier, 1));
        I_model_corrupt{i}.alignedTexture(y_offset:y_offset + size(outlier, 1) - 1, x_offset:x_offset + size(outlier, 2) - 1)    = rgb2gray(outlier);
        I_model_corrupt{i}.alignedNormals(y_offset:y_offset + size(outlier, 1) - 1, x_offset:x_offset + size(outlier, 2) - 1, :) = outlier;
    end
end

clear i x_offset y_offset;