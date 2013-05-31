subjects = {'bej', 'bln', 'fav', 'mut', 'pet', 'rob' 'srb'};
ang_errmat = zeros(7, 7);
for i=1:length(subjects)
    load(sprintf('data/results/%s/angularerror.mat', subjects{i}));
    ang_errmat(:, i) = angular_error_all;
end

%%
var = 1:7;
f = figure;
plot(var, ang_errmat(1, :), 'r:s', ...
     var, ang_errmat(4, :), 'r:+', ...
     var, ang_errmat(5, :), 'b:*', ...
     var, ang_errmat(6, :), 'b:o', ...
     var, ang_errmat(7, :), 'm:^', ...
     'MarkerSize',11, 'linewidth', 2); 
%      var, ang_errmat(2, :), 'magenta:^',  ...
%      var, ang_errmat(3, :), 'magenta-.x', ...
grid on
set(gca, 'xtick', var, 'XTickLabel', subjects);
% set(gca, 'ytick', ytick);

ylabel('Total Angular Error', 'Interpreter','tex', 'fontsize', 15);
xlabel('Subject', 'Interpreter','tex', 'fontsize', 15);

% legend(gca, 'Ideal', 'AEP-PCA', 'AZI-PCA', 'ELE-PCA', 'IP-PCA', 'L2-PCA', 'PGA', 'SPHER-PCA', 'Location', 'NorthWest');
legend(gca, 'AEP-PCA', 'IP-PCA', 'L2-PCA', 'PGA', 'SPHER-PCA', 'Location', 'NorthWest');
set(f, 'Position', [0, 0, 640, 480]);