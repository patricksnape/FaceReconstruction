function [triangleArrayNormals, triangleArrayAreas] = computeTriangleNormals(S, triangleArray)
    
    %	COMPUTETRIANGLEARRAYNORMALS Summary of this function goes here
    %   Detailed explanation goes here
    
    Us = S(:,triangleArray(1,:)) - S(:,triangleArray(2,:));
    Vs = S(:,triangleArray(1,:)) - S(:,triangleArray(3,:));

    nTriangles = size(triangleArray,2);
    
    triangleArrayNormals = zeros(4, nTriangles);
    triangleArrayNormals(1:3,:) = cross(Us(1:3,:), Vs(1:3,:));
    
    triangleArrayAreas = 0.5 * sum(triangleArrayNormals.^2, 1);
    
    triangleArrayNormals = normc(triangleArrayNormals);
    
end

