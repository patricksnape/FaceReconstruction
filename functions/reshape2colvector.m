function [ vecs ] = reshape2colvector(mat, col_length)
%RESHAPE2COLVECTOR Summary of this function goes here
%   Detailed explanation goes here

if ~exist('col_length', 'var')
    col_length = 3;
end

vecs = double(reshape(mat, col_length, []));

end

