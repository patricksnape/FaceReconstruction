function pplane(point, normal, size )
%PPLANE Plot a plane, expects column vectors

%# a plane is a*x+b*y+c*z+d=0
%# [a,b,c] is the normal. Thus, we have to calculate
%# d and we're set

point = point';
normal = normal';

d = -point * normal'; %'# dot product for less typing

%# create x,y
[xx, yy] = ndgrid(1:size, 1:size);

xx = xx + (point(1) / 2) - (size / 2);
yy = yy + (point(2) / 2) - (size / 2);

%# calculate corresponding z
z = (-normal(1) * xx - normal(2) * yy - d) / normal(3);

%# plot the surface
surf(xx, yy, z)

end

