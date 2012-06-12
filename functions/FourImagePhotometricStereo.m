function [normals meanImage] = FourImagePhotometricStereo(I1)
     Lights = [0.5   0.4    2;
              -0.5   0.4    2;
              -0.5  -0.4    2;
               0.5  -0.4    2];


    [Nx Ny Nz AA] = Call_StandardPS(I1, Lights, 4);

    normals(:, :, 1) = Nx;
    normals(:, :, 2) = Ny;
    normals(:, :, 3) = Nz;

    [n1 n2]       = size(Nx);
    meanImage    = zeros(n1,n2,3);

    for j=1:3
        for i=1:4
            meanImage(:,:,j)  =  meanImage(:,:,j) + double((I1(:,:,j,i)));
        end

        meanImage(:,:,j)      = (meanImage(:,:,j)/4);
        max_mean_image(:,:,j)  = (max(max(meanImage(:,:,j))));
        meanImage(:,:,j)      = meanImage(:,:,j)/max_mean_image(:,:,j);
    end
end