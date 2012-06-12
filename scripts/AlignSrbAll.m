srb1 = imread('data/images/srb1.ppm');
srbaligned1 = AlignFace(srb1, 335, 290, 287, 460, 342, 270, 413, 349);
srb2 = imread('data/images/srb2.ppm');
srbaligned2 = AlignFace(srb2, 335, 290, 287, 460, 342, 270, 413, 349);
srb3 = imread('data/images/srb3.ppm');
srbaligned3 = AlignFace(srb3, 335, 290, 287, 460, 342, 270, 413, 349);
srb4 = imread('data/images/srb4.ppm');
srbaligned4 = AlignFace(srb4, 335, 290, 287, 460, 342, 270, 413, 349);

srb(:, :, :, 1) = srbaligned1;
srb(:, :, :, 2) = srbaligned2;
srb(:, :, :, 3) = srbaligned3;
srb(:, :, :, 4) = srbaligned4;