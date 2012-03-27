function vec = Image2ColVector3(x, y, z)
%IMAGE2COLVECTOR Convert to 3 x N matrix by concatenating the rows of an
%image then convert to column vector

% convert to 3xN matrix by concatenating the rows of an image
x = reshape(x ,1, []);
y = reshape(y, 1, []);
z = reshape(z, 1, []);

vec = [x;y;z];

% convert 3xN rows to a column matrix
vec = reshape(vec, [], 1);
end
