subjects = {'bej', 'bln', 'fav', 'mut', 'pet', 'rob' 'srb'};
height_errmat = zeros(7, 7);
for i=1:length(subjects)
    load(sprintf('data/results/%s/heighterror.mat', subjects{i}));
    height_errmat(:, i) = height_error_all;
end

%%
var = 1:7;
figure;
plot(var, height_errmat(1, :), 'r:s', ...
     var, height_errmat(4, :), 'r:+', ...
     var, height_errmat(5, :), 'b:*', ...
     var, height_errmat(6, :), 'b:o', ...
     var, height_errmat(7, :), 'm:^', ...
     'MarkerSize',11, 'linewidth', 2); 
%      var, height_errmat(2, :), 'magenta:^',  ...
%      var, height_errmat(3, :), 'magenta-.x', ...
grid on
set(gca, 'FontSize', 0.1)
set(gca, 'FontWeight', 'bold')
set(gca, 'xtick', var, 'XTickLabel', subjects);
% set(gca, 'ytick', ytick);

ylabel('Total Absolute Height Error', 'Interpreter','tex', 'fontsize', 15);
xlabel('Subject', 'Interpreter','tex', 'fontsize', 15);

% legend(gca, 'AEP', 'AZI', 'ELE', 'IP', 'LS', 'PGA', 'SPHER');
legend(gca, 'AEP', 'IP', 'LS', 'PGA', 'SPHER');

title('Height Error', 'Interpreter', 'tex', 'fontsize', 15);