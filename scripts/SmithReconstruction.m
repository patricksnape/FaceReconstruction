load('data/trainingset')
load('data/lights')
light = lights(:,1) / colnorm(lights(:,1));
AlignTrainingSet
AlignMut1
GeneratePCAOnTrainingSet
[error b n] = SmithGSS(rgb2gray(mutaligned), Un, XNavg, light');
TexturizeRecoveredFace(rgb2gray(mutaligned), n)