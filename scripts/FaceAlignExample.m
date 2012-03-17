base_morphable_model = load_model('morphable_model.mat');
depthmap = convertMeshDepthMap(reshape2colvector(double(base_morphable_model.shapeMU)), 231);
texture = imread('data/images/mut1.ppm');

% Use the corner of the eye

figure(1);
clf;
aligned = AlignFace(depthmap, 155, 142, 40, 155, 52, 115, 115, 180);
mesh(aligned);

figure(2);
clf;
aligned = AlignFace(texture, 304, 349, 475, 294, 311, 390, 390, 458);
image(aligned);