%% Assumes I_model exists

for i=1:199
    shape = I_model{i}.shape;
    normbuffer = I_model{i}.normBuffer;

    aligned = AlignFace(normbuffer, ...
                                   shape(1,2), ... % Nose Y
                                   shape(2,2), ... % Left Eye Y
                                   shape(3,2), ... % Right Eye Y
                                   shape(4,2), ... % Chin Y
                                   shape(1,1), ... % Nose X
                                   shape(2,1), ... % Left Eye X
                                   shape(3,1), ... % Right Eye X
                                   shape(4,1));    % Chin X
    
    ysize = size(aligned, 2);
    xsize = size(aligned, 1);
                               
    aligned = reshape2colvector(Image2ColVector3(aligned));
    cnorm = colnorm(aligned);
    aligned = reshape(bsxfun(@rdivide, aligned, cnorm), [], 1);
    aligned(isnan(aligned)) = 0;
    aligned = ColVectorToImage3(aligned, xsize, ysize);
    
    I_model{i}.aligned = aligned;
end

clear i shape normbuffer aligned