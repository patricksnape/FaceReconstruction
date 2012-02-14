function error = reconstruct(normals, count)
%RECONSTRUCT Randomly sample *count* columns from the matrix normals and
%then attempt to reconstruct the remaining columns. Expects normals to be
%concatenated column vectors.

[~, train_indices] = datasample(normals, count, 2, 'Replace', false);
indices = 1:size(normals, 2);
test_indices = setdiff(indices, train_indices);

XTrain = normals(:, train_indices);
%XTrainAv = mean_surface_norm(XTrain);
%XTrain = matsubcolvec(XTrain, XTrainAv);

XTest = normals(:, test_indices);
%XTestAv = mean_surface_norm(XTrain);
%XTest = matsubcolvec(XTest, XTestAv);

UTrain = myGPCA(XTrain, size(XTrain, 2) - 1, 0);

Y = UTrain' * XTest;
XTildeTest = UTrain * Y;

error = norm(XTest - XTildeTest);

end

