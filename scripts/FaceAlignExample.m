load('morphable_model.mat');
depthmap = convertMeshDepthMap(reshape2colvector(double(model.shapeMean)), 231);
texture = imread('data/images/mut1.ppm');

% Use the corner of the eye

figure(1);
clf;
depthmap = AlignFace(depthmap, 142, 155, 155, 40, 115, 52, 180, 115);
mesh(depthmap);

figure(2);
clf;
aligned = AlignFace(texture, 349, 304, 294, 475, 390, 311, 458, 390);
imshow(aligned);