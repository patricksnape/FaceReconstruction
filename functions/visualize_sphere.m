function visualize_sphere(points, index, count, col)
%VISUALIZE_SPHERE Plot a sphere and the points given
%   Expects points to be unit vectors. Color is optional

if ~exist('col','var'), col = 'r.'; end

first_object = reshape(points(:, index), [3 numel(points(:, index))/3]);

colormap([1  1  1; 1  1  1]);
sphere;
axis equal;

hold on;

plot3(first_object(1,1:count), first_object(2,1:count), first_object(3,1:count), col);

hold off;

end

