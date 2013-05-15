function [Un, XNavg] = normal_pca_from_model(model, k, error_metric)

if iscell(model)
    Xn = cellfun(@(x) getfield(x, 'alignedNormals'), model, 'UniformOutput', false);
    Xn = cellfun(@(x) Image2ColVector3(x), Xn, 'UniformOutput', false);
    Xn = cell2mat(Xn');
else
    Xn = model;
end

XNavg = mean(Xn, 2);

switch error_metric
    case 'IP' 
        XN_norm = Xn;
    case 'AEP'    
        XAEPn = spherical2azimuthal(Xn, XNavg);
        XN_norm = XAEPn;
    case 'LS'
        XN_norm = matsubcolvec(Xn, XNavg);
    case 'PGA'
        % calculatePGA(model)
        XN_norm = Xn;
    case 'AZI'
        C = num2cell(Xn, 1);
        C = cellfun(@(x) normals2azimuth(x), C, 'UniformOutput', false);
        XN_norm = cell2mat(C);
    case 'ELE'
        C = num2cell(Xn, 1);
        C = cellfun(@(x) normals2ele(x), C, 'UniformOutput', false);
        XN_norm = cell2mat(C);
    case 'SPHER'
        C = num2cell(Xn, 1);
        C = cellfun(@(x) normals2spher(x), C, 'UniformOutput', false);
        XN_norm = cell2mat(C);
end

Un = myGPCA(XN_norm, k, 0);