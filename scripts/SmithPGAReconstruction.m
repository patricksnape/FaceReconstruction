load('data/trainingset')
load('data/pga')
load('data/lights')
light = lights(:,1) / colnorm(lights(:,1));
AlignMut1
[ b npga ] = SmithPGAGSS(rgb2gray(mutaligned), UPGA, XNavg, mus, light');
TexturizeRecoveredFace(rgb2gray(mutaligned), npga);