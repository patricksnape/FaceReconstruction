function vec = Image2ColVector(texture)
%IMAGE2COLVECTOR Convert to 3 x N matrix by concatenating the rows of an
%image then convert to column vector

% convert to 3xN matrix by concatenating the rows of an image
vec = mat2cell(texture, 3 * ones(1, size(texture, 1) / 3), ones(1, size(texture, 2)));
vec = vec.';
vec = horzcat(vec{:});

% convert 3xN rows to a column matrix
vec = reshape(vec, [], 1);
end

