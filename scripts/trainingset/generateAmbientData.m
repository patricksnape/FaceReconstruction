function [I_model] = generateAmbientData(model, fp, rhoArray, alphaArray, betaArray, resolution, projectionType)
    
    %   generateData Summary of this function goes here
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
    
    % Compute the normals at the vertices
    [N, triangleArrayNormals] = compute_normal(S(1:3,:), model.triangleArray);
    
    N = -N;
    triangleArrayNormals = -triangleArrayNormals;
    
    N(4,:) = 0;
    triangleArrayNormals(4,:) = 0;
    
    
    %% Image rendering

    % Compute the view matrix and the projection matrix needed for 
    % rendering    
    [~, ~, ~, R_total, viewMatrix, projectionMatrix] = computeWarpAndProjectionMatrices(rhoArray, projectionType);

    % Warp the shape, triangle normals and shape normals using the 
    % view matrix and the total rotation matrix
    [W, triangleArrayNormals, N] = warp(S, triangleArrayNormals, N, viewMatrix, R_total);
    
    % Discard all those triangles whose normals are not facing the
    % camera
    [triangleArray, triangleArrayNormals] = cull(model.triangleArray, triangleArrayNormals);
    %triangleArray = model.triangleArray;

    % Project the warped shape onto the image plane
    [P] = project(W, projectionMatrix, projectionType);
    
    % Discard all those triangles with at least one vertex outside of
    % the viewing volume
    [triangleArray, ~] = clip(P, triangleArray, triangleArrayNormals);
    
    % Rasterize Image
    [frameBuffer, ~] = rasterize(triangleArray, P, T, resolution);
    
    % Rasterize Image
    [normalBuffer, ~] = rasterize(triangleArray, P, N, resolution);
    
    % Rasterize Image
    [~, W2, ~] = warp(S, S, S, viewMatrix, R_total);
    [xyzBuffer, ~] = rasterize(triangleArray, P, W2 - repmat([0 0 min(S(3,:)) 0]', 1, size(S,2)), resolution);
    
    % Project the shape
    [xy] = compute_anchor_points_projection(P(:,fp), resolution);
    xy = xy(1:2,:);

    
    %% Save Image 
    
    I_model.textureBuffer= uint8(frameBuffer);
    I_model.normBuffer = normalBuffer;
    I_model.xyzBuffer = xyzBuffer;
    I_model.shape = xy';
    

end