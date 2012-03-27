function [O] = homogenize(object)
    
    %   HOMOGENIZE Summary of this function goes here
    %   Detailed explanation goes here
    
    nPoints = size(object, 1) / 3;
    nObjects = size(object, 2);
    
    O = ones(4, nPoints, nObjects);
    
    O(1:3,:,:) = reshape(object, [3 nPoints nObjects]);
    
end