function nestimates = EstimateNormalsAvg(mu, theta)   
    muim = reshape2colvector(mu);
    muim = bsxfun(@rdivide, muim, colnorm(muim));
    muim = ColVectorToImage3(reshape(muim,[],1), size(theta, 1), size(theta, 2));
    
    % Could have some division by zero...
    norm = sqrt(muim(:,:,1).^2 + muim(:,:,2).^2);
    sinphi = muim(:,:,2) ./ norm;
    sinphi(isnan(sinphi)) = 0;
    cosphi = muim(:,:,1) ./ norm;
    cosphi(isnan(cosphi)) = 0;
    clear norm;
    
    nestimates(:,:,1) = sin(theta) .* cosphi;
    nestimates(:,:,2) = sin(theta) .* sinphi;
    nestimates(:,:,3) = cos(theta);

    % normalize and reshape to column
    nestimates = Image2ColVector3(nestimates(:,:,1), nestimates(:,:,2), nestimates(:,:,3));
    nestimates = reshape2colvector(nestimates);
    nestimates = bsxfun(@rdivide, nestimates, colnorm(nestimates));
    nestimates = reshape(nestimates, [], 1);
end