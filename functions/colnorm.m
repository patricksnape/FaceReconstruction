function m = colnorm(s)
%COLNORM Calculate magnitude of every column of a matrix
%   Given a matrix s calculate the magniture of each column eg.
%   s = [ 4 4 4; 3 3 3]
%   m = colnorm(s) = [ 5 5 5 ]

m = sqrt(sum(s.^2, 1));

end

