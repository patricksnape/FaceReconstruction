fnames = dir('data/results/litmm-0--45/*angularerror.png');
numfids = length(fnames);
fnames = nestedSortStruct(fnames, 'name');
vals = cell(numfids, 1);
for K = 1:numfids
  im = double(rgb2gray(imread(fnames(K).name)))/255;
  im = im(:, 203:997);
  vals{K} = sum(sum(im));
end