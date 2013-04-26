load('data/trainingset')
load('data/lights')
light = lights(:,1) / colnorm(lights(:,1));
AlignTrainingSet
AlignMut1
GeneratePCAOnTrainingSet
[ a c ] = NewReconstruction(rgb2gray(mutaligned),Un, Ut, XTavg, XNavg, light);
[nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
TexturizeRecoveredFace(testimate, nestimate)