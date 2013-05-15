function err = pca_error( X, Xavg )
%PCA_ERROR Calculates the normalized error of computing the principal
%components

if (~exist('Xavg', 'var'))
    Xavg = zeros(size(X, 1), 1);
end

normalized_normals = matsubcolvec(X, Xavg);

U = myGPCA(normalized_normals, size(X, 2) - 1, 0);

Y = U' * normalized_normals;
Xtilde = mataddcolvec(U * Y, Xavg);

err = norm(Xtilde - X, 2);

end

