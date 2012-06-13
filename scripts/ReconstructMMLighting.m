RenderPersLightsAndShadows;
tex = I_light.alignedTexture;
name = 'litmm-0--30';
light(1) = sin(deg2rad(iotaArray(14))) * cos(deg2rad(iotaArray(15)));
light(2) = sin(deg2rad(iotaArray(14))) * sin(deg2rad(iotaArray(15)));
light(3) = cos(deg2rad(iotaArray(15)));
light = light / colnorm(light);

%%
[error b n] = SmithGSS(tex, Un, XNavg, light');
SaveFigures(name, 'smith', n, tex);
%%
[b naep] = SmithAEPGSS(tex, UAEPn, XNavg, light');
SaveFigures(name, 'aep', naep, tex);
%%
[ a c ] = NewReconstruction(tex,Un, Ut, XTavg, XNavg, light);
[nestimate testimate] = ReconstructFromWeights(XNavg, XTavg, Un, Ut, c, a);
SaveFigures(name, 'novel', nestimate, tex, testimate);
%%
[ b npga ] = SmithPGAGSS(tex, UPGA, XNavg, mus, light');
SaveFigures(name, 'pga', npga, tex);
%%
nground = I_light.alignedNormals;
SaveFigures(name, 'ground', nground, tex);
%%
figure(2);
dataPath = 'data/results';

smithError = AngularError(nground, n);
imshow(smithError, 'Border','tight');
filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, name, 'smith', name);
print('-dpng',filePath);

AEPError = AngularError(nground, naep);
imshow(AEPError, 'Border','tight');
filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, name, 'aep', name);
print('-dpng',filePath);

PGAError = AngularError(nground, npga);
imshow(PGAError, 'Border','tight');
filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, name, 'pga', name');
print('-dpng',filePath);

novelError = AngularError(nground, nestimate);
imshow(novelError, 'Border','tight');
filePath = sprintf('%s/%s/%s-%s-angularerror.png', dataPath, name, 'novel', name);
print('-dpng',filePath);

close all;