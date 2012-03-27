function [ im ] = ColVectorToImage3( vec, m, n )
%COLVECTORTOIMAGE Summary of this function goes here
%   Detailed explanation goes here

temp = reshape(vec, [3 numel(vec)/3]);

x = temp(1,:);
y = temp(2,:);
z = temp(3,:);

im(:,:,1) = reshape(x, m, n);
im(:,:,2) = reshape(y, m, n);
im(:,:,3) = reshape(z, m, n);

end

