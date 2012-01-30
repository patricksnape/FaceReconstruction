function visualize_sphere(points, index, count)
%VISUALIZE_SPHERE Summary of this function goes here
%   Detailed explanation goes here

first_object = reshape(points(:, index), [3 numel(points(:, index))/3]);

colormap([1  1  1; 1  1  1]);
sphere;
axis equal;

hold on;

plot3(first_object(1,1:count), first_object(2,1:count), first_object(3,1:count), 'r.');

hold off;

end

