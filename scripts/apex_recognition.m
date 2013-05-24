[Un, Xn_avg] =  normal_pca_from_model(I_model, 102, 'LS');
Xavg = Xn_avg;
% Xavg = zeros(size(Un, 1), 1);

transform = @(x) x;

projected_apexes = zeros(size(Un, 1), size(apexes, 4));
projected_neutrals = zeros(size(Un, 1), size(neutrals, 4));

for i=1:size(apexes, 4)
    vector = transform(Image2ColVector3(apexes(:,:,:,i)));
    Y = Un' * vector;
    projected_apexes(:, i) = mataddcolvec(Un * Y, Xavg);
    
    if i <= size(I_model, 2)
        Y = Un' * transform(I_model(:, i));
        projected_neutrals(:, i) = mataddcolvec(Un * Y, Xavg);
    end
end

%%
% % Nearest Neigbour Classifier for IGO-PCA
distance = 'cosine';
k = 1;
class = knnclassify(projected_apexes', projected_neutrals', 1:102, k, distance);
LS_correct_PCA = length(find(class-labels == 0));
% recognition rate for IGO-PCA
LS_correct_PCA = LS_correct_PCA ./ length(labels)