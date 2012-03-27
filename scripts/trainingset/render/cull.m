function [triangleArray, triangleArrayNormals] = cull(triangleArray, triangleArrayNormals)
    
    %	CULL Summary of this function goes here
    %   Detailed explanation goes here
    
    nTriangles = size(triangleArray, 2);
    [~, index] = find(dot(triangleArrayNormals, repmat([0 0 1 0]', 1, nTriangles)) > 0);

    triangleArray = triangleArray(:, index);
    triangleArrayNormals = triangleArrayNormals(:, index);

end

