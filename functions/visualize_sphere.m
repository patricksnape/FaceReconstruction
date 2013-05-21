function visualize_sphere(points, index, count, col)
%VISUALIZE_SPHERE Plot a sphere and the points given
%   Expects points to be unit vectors in a column. Color is optional

if ~exist('col', 'var'), col = 'r.'; end

index_object = reshape(points(:, index), 3, []);

if ~exist('count', 'var'), count = size(index_object, 2); end

colormap([1  1  1; 1  1  1]);
sphere;
axis equal;

hold on;

plot3(index_object(1,1:count), index_object(2,1:count), index_object(3,1:count), col);

hold off;

end

