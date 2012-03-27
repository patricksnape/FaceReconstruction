function [W, triangleArrayNormals, shapeNormals] = warp(S, triangleArrayNormals, shapeNormals, viewMatrix, R_total)
    
    %   WARP Summary of this function goes here
    %   Detailed explanation goes 
    
    W = viewMatrix * S;
    triangleArrayNormals = R_total * triangleArrayNormals;
    shapeNormals = R_total * shapeNormals;
    
end

