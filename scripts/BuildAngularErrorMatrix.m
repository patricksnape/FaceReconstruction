subjects = {'bej', 'bln', 'fav', 'mut', 'pet', 'rob' 'srb'};
errmat = zeros(7, 7);
for i=1:length(subjects)
    load(sprintf('data/results/%s/angularerror.mat', subjects{i}));
    errmat(:, i) = angular_error_all;
end