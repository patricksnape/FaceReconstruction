mut1 = imread('data/images/mut1.ppm');
mutaligned1 = AlignFace(mut1, 349, 304, 294, 475, 390, 311, 458, 390);
mut2 = imread('data/images/mut2.ppm');
mutaligned2 = AlignFace(mut2, 349, 304, 294, 475, 390, 311, 458, 390);
mut3 = imread('data/images/mut3.ppm');
mutaligned3 = AlignFace(mut3, 349, 304, 294, 475, 390, 311, 458, 390);
mut4 = imread('data/images/mut4.ppm');
mutaligned4 = AlignFace(mut4, 349, 304, 294, 475, 390, 311, 458, 390);

mut(:, :, :, 1) = mutaligned1;
mut(:, :, :, 2) = mutaligned2;
mut(:, :, :, 3) = mutaligned3;
mut(:, :, :, 4) = mutaligned4;