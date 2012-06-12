pet1 = imread('data/images/pet1.ppm');
petaligned1 = AlignFace(pet1, 362, 285, 258, 515, 366, 252, 438, 368);
pet2 = imread('data/images/pet2.ppm');
petaligned2 = AlignFace(pet2, 362, 285, 258, 515, 366, 252, 438, 368);
pet3 = imread('data/images/pet3.ppm');
petaligned3 = AlignFace(pet3, 362, 285, 258, 515, 366, 252, 438, 368);
pet4 = imread('data/images/pet4.ppm');
petaligned4 = AlignFace(pet4, 362, 285, 258, 515, 366, 252, 438, 368);

pet(:, :, :, 1) = petaligned1;
pet(:, :, :, 2) = petaligned2;
pet(:, :, :, 3) = petaligned3;
pet(:, :, :, 4) = petaligned4;