function [I_model] = generateImage(model, resolution, rhoArray, alphaArray, betaArray, projectionType)
    
    %   GENERATEPERSPECTIVEIMAGE Summary of this function goes here
    %   Detailed explanation goes here

     %% Shape generation
    
    % Compute a shape using the shape linear model and the shape parameters
    [shape] = model2Object(alphaArray, model.shapeMean, model.shapePC, model.shapeEV, model.segMM, model.segMB);
    
    % Convert the shape data structure from 3Nv x 1 to 4 x Nv
    [S] = homogenize(shape);
    
    % Center the shape data around (0,0,0)
    s_m = repmat(mean(S(1:3,:),2), 1, size(S,2)); 
    S(1:3,:) = S(1:3,:) - s_m;
    
    
    %% Texture generation
    
    % Compute a texture using the texture linear model and the texture 
    % parameters
    [texture] = model2Object(betaArray, model.textureMean, model.texturePC, model.textureEV, model.segMM, model.segMB);
    
     % Convert the texture data structure from 3Nv x 1 to 4 x Nv
    [T] = homogenize(texture);
    
    
    %% Normals computation
    
    % Compute the normals at the center of the triangles
    [triangleArrayNormals] = computeTriangleNormals(S, model.triangleArray);
    
    
    %% Image rendering

    % Compute the view matrix and the projection matrix needed for 
    % rendering    
    [~, ~, ~, R_total, viewMatrix, projectionMatrix] = computeWarpAndProjectionMatrices(rhoArray, projectionType);

    % Warp the shape, triangle normals and shape normals using the 
    % view matrix and the total rotation matrix
    [W, ~, ~] = warp(S, triangleArrayNormals, triangleArrayNormals, viewMatrix, R_total);
    
    % Discard all those triangles whose normals are not facing the
    % camera
    [triangleArray, triangleArrayNormals] = cull(model.triangleArray, triangleArrayNormals);


    % Project the warped shape onto the image plane
    [P] = project(W, projectionMatrix, projectionType);
    
    % Discard all those triangles with at least one vertex outside of
    % the viewing volume
    [triangleArray, ~] = clip(P, triangleArray, triangleArrayNormals);

    % Rasterize
    [frameBuffer, tBuffer] = rasterize(model.triangleArray, P, T, resolution);
    
    
    %% Save Image 
    
    I_model.img = uint8(frameBuffer);
    I_model.rhoArray = rhoArray;
    I_model.alphaArray = alphaArray;
    I_model.betaArray = betaArray;
    I_model.tBuffer = tBuffer;
    

end

