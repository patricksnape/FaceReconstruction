function [angular_error] = normal_reconstruction_error(I_model, X, X_corrupted, error_metric, k, varargin)
%PCA_ERROR Calculates the normalized error of computing the principal
%components

inp = inputParser;

% Default feature vectors
inp.addOptional('mus', [], @(x) size(x,1) == 3);

inp.parse(varargin{:});
opts = inp.Results;
clear('inp');

% Calculate PCA
% If we are calculating PGA, we assume we have been provided with D
[Un, Un_avg] = normal_pca_from_model(I_model, k, error_metric);

% Transform in to appropriate space
switch error_metric
    case 'IP' 
        Xn_norm = X_corrupted;
        Xn_avg = zeros(size(Xn_norm, 1), 1);
    case 'AEP'    
        XAEPn = spherical2azimuthal(X_corrupted, Un_avg);
        Xn_norm = XAEPn;
        Xn_avg = zeros(size(Xn_norm, 1), 1);
    case 'LS'
        Xn_norm = matsubcolvec(X_corrupted, Un_avg);
        Xn_avg = Un_avg;
    case 'PGA'
        mus = opts.mus;
        col = reshape2colvector(X_corrupted);
        Xn_norm = zeros(size(col));
        for i=1:size(col, 2)
            Xn_norm(:, i) = logmap(mus(:, i), col(:, i));
        end
        Xn_norm = Xn_norm(:);
        Xn_avg = zeros(size(Xn_norm, 1), 1);
    case 'AZI'
        [Xn_norm, X_spher] = normals2azimuth(X_corrupted);
        Xn_avg = zeros(size(Xn_norm, 1), 1);
    case 'ELE'
        [Xn_norm, X_spher] = normals2ele(X_corrupted);
        Xn_avg = zeros(size(Xn_norm, 1), 1);
    case 'SPHER'
        Xn_norm = normals2spher(X_corrupted);
        Xn_avg = zeros(size(Xn_norm, 1), 1);
end

% Project
Y = Un' * Xn_norm;
Xtilde = mataddcolvec(Un * Y, Xn_avg);

% Transform back in to normals, if needed
switch error_metric
    case 'AEP'    
        Xtilde = azimuthal2spherical(Xtilde, Un_avg);
    case 'PGA'
        col = reshape2colvector(Xtilde);
        Xtilde = zeros(size(col));
        for i=1:size(col, 2)
            Xtilde(:, i) = expmap(mus(:, i), col(:, i));
        end
        Xtilde = Xtilde(:);
    case 'AZI'
        X_spher = reshape(X_spher, 4, []);
        X_ele = X_spher(3:4, :);
        Xtilde = azimuth2normals(Xtilde, X_ele);
    case 'ELE'
        X_spher = reshape(X_spher, 4, []);
        X_azi = X_spher(1:2, :);
        Xtilde = ele2normals(Xtilde, X_azi);
    case 'SPHER'
        Xtilde = spher2normals(Xtilde);
end

% Normalize Xtilde
Xtilde = reshape2colvector(Xtilde);
cnorm = colnorm(Xtilde);
Xtilde = bsxfun(@rdivide, Xtilde, cnorm);

X = reshape2colvector(X);

angular_error = real(acos(dot(Xtilde, X)));

end

