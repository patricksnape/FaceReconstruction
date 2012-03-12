function [ vecs ] = reshape2colvector( mat )
%RESHAPE2COLVECTOR Summary of this function goes here
%   Detailed explanation goes here

vecs = reshape(mat, [3 numel(mat)/3]);

end

