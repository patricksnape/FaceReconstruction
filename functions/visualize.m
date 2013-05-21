function visualize( training_set, tl, index )
%VISUALIZE_FIRST Visualizes the face at the specified index
%   Assumes plot_mesh is available

if (index > size(training_set, 2))
    error('Index is out of range of training set')
end

shape = reshape(training_set.shapes(:, index), 3, []);
normals = reshape(training_set.normals(:, index), 3, []);

options = [];
options.normal = normals;

plot_mesh(shape, tl, options);

end

