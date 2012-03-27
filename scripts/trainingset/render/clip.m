function [triangleArray, triangleArrayNormals] = clip(P, triangleArray, triangleArrayNormals)
    
    %	CLIP Summary of this function goes here
    %   Detailed explanation goes here
    
    %Triangles
    index = P(1, triangleArray(1,:)) < 0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    index = P(1, triangleArray(1,:)) > -0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    
    index = P(1, triangleArray(2,:)) < 0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    index = P(1, triangleArray(2,:)) > -0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    
    index = P(1, triangleArray(3,:)) < 0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    index = P(1, triangleArray(3,:)) > -0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    
    
    index = P(2, triangleArray(1,:)) < 0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    index = P(2, triangleArray(1,:)) > -0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    
    index = P(2, triangleArray(2,:)) < 0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    index = P(2, triangleArray(2,:)) > -0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    
    index = P(2, triangleArray(3,:)) < 0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    index = P(2, triangleArray(3,:)) > -0.99;
    triangleArray = triangleArray(:,index);
    triangleArrayNormals = triangleArrayNormals(:,index);
    
end

