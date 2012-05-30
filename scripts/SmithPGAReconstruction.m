load('data/trainingset')
load('data/lights')
light = lights(:,1) / colnorm(lights(:,1));
AlignMut1
calculatePGA
[ b n ] = SmithPGAGSS(rgb2gray(mutaligned), UPGA, mean_normals_set, mus, light');
TexturizeRecoveredFace(rgb2gray(mutaligned), n);