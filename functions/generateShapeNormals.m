function normals = generateShapeNormals(shapes, tl)

%% Eg.  generateTrainingSet()
%%      generateShapeNormals(training_set.shapes, base_morphable_model,tl)

%% Generate Normals

disp('Generating Normals...');

% Empty training set
N = size(shapes, 2);
normals = zeros(size(shapes, 1), N);

parfor_progress(N);

parfor i = 1:N
    shape = reshape(shapes(:, i), [ 3 numel(shapes(:, i))/3 ]);
    % Assumes toolbox_graph, toolbox_general and toolbox_signal exist in
    % the path:
    % http://www.ceremade.dauphine.fr/~peyre/numerical-tour/tours/meshproc_2_basics_3d/
    normals(:, i) = reshape(compute_normal(shape, tl), [], 1);
    
    % For sanities sake
	parfor_progress;
end

parfor_progress(0);
disp('Normals Successfuly Generated');

end