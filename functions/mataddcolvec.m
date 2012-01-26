function out = mataddcolvec(mat, vec)
%ADDCOLVEC2MAT Add a column vector to every column in a matrix

out = mat + vec(:, ones(1, size(mat, 2)));

end

