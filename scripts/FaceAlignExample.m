depthmap = convertMeshDepthMap(reshape2colvector(double(base_morphable_model.shapeMU)), 231);
texture = imread('data/images/mut1.ppm');

figure(1);
clf;
aligned = AlignFace(depthmap, 155, 142, 40, 155, 75, 113, 113, 145);
mesh(aligned);

figure(2);
clf;
aligned = AlignFace(texture, 301, 348, 474, 301, 336, 390, 390, 437);
image(aligned);