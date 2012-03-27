function vec = Image2ColVector(texture)
%IMAGE2COLVECTOR Convert to 3 x N matrix by concatenating the rows of an
%image then convert to column vector

% convert to 3xN matrix by concatenating the rows of an image
vec = reshape(texture, 1, []);
vec = reshape(vec, [], 1);

end

