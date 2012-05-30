load('data/trainingset')
load('data/lights')
light = lights(:,1) / colnorm(lights(:,1));
AlignTrainingSet
AlignMut1
GeneratePCAOnTrainingSet
[error baep naep] = SmithAEPGSS(rgb2gray(mutaligned), UAEPn, XNavg, light');
TexturizeRecoveredFace(rgb2gray(mutaligned), naep)