% Assumes morphable model is loaded as base_morphable_model

%% NOSE
shape = reshape(base_morphable_model.shapeMU, [3 numel(base_morphable_model.shapeMU)/3])';
noseInd = find(shape(:, 1) > -24740 & shape(:, 1) < 20003 & shape(:, 2) < 17370 & shape(:, 2) > -12900);
[row ~] = ind2sub(size(shape), noseInd);
row = find(ismember(base_morphable_model.tl, row));
[row ~] = ind2sub(size(base_morphable_model.tl), row);

FV.faces = base_morphable_model.tl(row, :);
FV.vertices = shape;
FV = smoothpatch(FV, 1, 5, 0.5);

%% MOUTH
shape = reshape(base_morphable_model.shapeMU, [3 numel(base_morphable_model.shapeMU)/3])';
mouthInd = find(shape(:, 1) > -42080 & shape(:, 1) < 40840 & shape(:, 2) > -52880 & shape(:, 2) < -19000);
[row ~] = ind2sub(size(shape), mouthInd);
row = find(ismember(base_morphable_model.tl, row));
[row ~] = ind2sub(size(base_morphable_model.tl), row);

FV.faces = base_morphable_model.tl(row, :);
FV = smoothpatch(FV, 1, 25, 0.5);

depthmap = convertMeshDepthMap(FV.vertices', 231);
mesh(depthmap);