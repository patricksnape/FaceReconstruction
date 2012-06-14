fnames = dir('data/results/fav/*.fig');
numfids = length(fnames);
fnames = nestedSortStruct(fnames, 'name');
heights = cell(numfids, 1);
for K = 1:numfids
    f = open(fnames(K).name);
  
    ax = findall(f,'Type','patch');
    v = get(ax, 'Vertices');
    heights{K} = ColVectorToImage(v(:, 3), 150, 170);
end

diffs = zeros(numfids-1, 1);
ground = heights{2};

diffs(1) = sum(sum(abs(heights{1} - ground)));
diffs(2) = sum(sum(abs(heights{3} - ground)));
diffs(3) = sum(sum(abs(heights{4} - ground)));
diffs(4) = sum(sum(abs(heights{5} - ground)));

close all;
clear fnames numfids fnames f ax v K;