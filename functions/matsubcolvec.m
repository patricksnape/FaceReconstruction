function out = matsubcolvec(mat, vec)
%ADDCOLVEC2MAT Subtracts a column vector from every column in a matrix

out = mat - vec(:, ones(1, size(mat, 2)));

end

