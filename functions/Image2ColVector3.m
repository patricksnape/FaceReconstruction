function vec = Image2ColVector3(xs, ys, zs)
%IMAGE2COLVECTOR Convert to 3 x N matrix by concatenating the rows of an
%image then convert to column vector

% Allow a single NxMx3 image to be passed in (method overload)
if (ndims(xs) == 3)
    x = reshape(xs(:,:,1), 1, []);
    y = reshape(xs(:,:,2), 1, []);
    z = reshape(xs(:,:,3), 1, []);
else
    x = reshape(xs ,1, []);
    y = reshape(ys, 1, []);
    z = reshape(zs, 1, []);
end

% convert to 3xN matrix by concatenating the rows of an image
vec = [x;y;z];

% convert 3xN rows to a column matrix
vec = reshape(vec, [], 1);
end
