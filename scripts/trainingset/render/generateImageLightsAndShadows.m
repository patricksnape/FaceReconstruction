function [I_model] = generateImageLightsAndShadows(model, resolution, rhoArray, iotaArray, alphaArray, betaArray, projectionType)
    
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
    
    % Compute the normals at the vertices
    [N, triangleArrayNormals] = compute_normal(S(1:3,:), model.triangleArray);
    
    N = -N;
    triangleArrayNormals = -triangleArrayNormals;
    
    N(4,:) = 0;
    triangleArrayNormals(4,:) = 0;
    
    
    %% Shadow buffer computation
    
    % Compute the direction of the light
    [lightVector] = computeLightVector(iotaArray);
    
    diff = 0.01;
    times = 9;
    sb_resolution = [512, 512];
    shadowBuffer = zeros(sb_resolution(1), sb_resolution(2), times);
    lightP = zeros(4, size(S, 2), times);
    
    noisyLightVector(1,1) = lightVector(1) + diff;
    noisyLightVector(2,1) = lightVector(2) + diff;
    noisyLightVector(3,1) = lightVector(3);
    noisyLightVector(4,1) = 0;
    
    noisyLightVector(1,2) = lightVector(1);
    noisyLightVector(2,2) = lightVector(2) + diff;
    noisyLightVector(3,2) = lightVector(3);
    noisyLightVector(4,2) = 0;
    
    noisyLightVector(1,3) = lightVector(1) - diff;
    noisyLightVector(2,3) = lightVector(2) + diff;
    noisyLightVector(3,3) = lightVector(3);
    noisyLightVector(4,3) = 0;
    
    noisyLightVector(1,4) = lightVector(1) + diff;
    noisyLightVector(2,4) = lightVector(2);
    noisyLightVector(3,4) = lightVector(3);
    noisyLightVector(4,4) = 0;
    
    noisyLightVector(1,5) = lightVector(1);
    noisyLightVector(2,5) = lightVector(2);
    noisyLightVector(3,5) = lightVector(3);
    noisyLightVector(4,5) = 0;
    
    noisyLightVector(1,6) = lightVector(1) - diff;
    noisyLightVector(2,6) = lightVector(2);
    noisyLightVector(3,6) = lightVector(3);
    noisyLightVector(4,6) = 0;
    
    noisyLightVector(1,7) = lightVector(1) + diff;
    noisyLightVector(2,7) = lightVector(2) - diff;
    noisyLightVector(3,7) = lightVector(3);
    noisyLightVector(4,7) = 0;

    noisyLightVector(1,8) = lightVector(1);
    noisyLightVector(2,8) = lightVector(2) - diff;
    noisyLightVector(3,8) = lightVector(3);
    noisyLightVector(4,8) = 0;

    noisyLightVector(1,9) = lightVector(1) - diff;
    noisyLightVector(2,9) = lightVector(2) - diff;
    noisyLightVector(3,9) = lightVector(3);
    noisyLightVector(4,9) = 0;
    
    noisyLightVector = normc(noisyLightVector);

    triangles = model.triangleArray;

    parfor i = 1:times  

        % Compute the view matrix and the projection matrix needed for 
        % rendering    
        [lightR, lightViewMatrix, lightProjectionMatrix] = computeLightWarpAndProjectionMatrices(noisyLightVector(:,i), rhoArray, projectionType);

        % Warp the shape, triangle normals and shape normals using the 
        % light source matrix and the total light source rotation matrix
        [lightW, lightTriangleArrayNormals, ~] = warp(S, triangleArrayNormals, N, lightViewMatrix, lightR);

        % Discard all those triangles whose normals are not facing the
        % camera
        [lightTriangleArray, lightTriangleArrayNormals] = cull(triangles, lightTriangleArrayNormals);

        % Project the warped shape onto the image plane
        [lightP(:,:,i)] = project(lightW, lightProjectionMatrix, projectionType);

        % Discard all those triangles with at least one vertex outside of
        % the viewing volume
        [lightTriangleArray, ~] = clip(lightP(:,:,i), lightTriangleArray, lightTriangleArrayNormals);

        % Rasterize
        [shadowBuffer(:,:,i)] = rasterize_z(lightTriangleArray, lightP(:,:,i), sb_resolution);
        
    end
    
    
    %% Image rendering

    % Compute the view matrix and the projection matrix needed for 
    % rendering    
    [~, ~, ~, R_total, viewMatrix, projectionMatrix] = computeWarpAndProjectionMatrices(rhoArray, projectionType);
    
    % Compute the color correction matrix
    [ks, v, L_amb,  L_dir, ~, ~, ~, colorMatrix] = computeIlluminationAndColorCorrectionParameters(iotaArray);

    % Warp the shape, triangle normals and shape normals using the 
    % view matrix and the total rotation matrix
    [W, triangleArrayNormals, N] = warp(S, triangleArrayNormals, N, viewMatrix, R_total);

    % Discard all those triangles whose normals are not facing the
    % camera
    [triangleArray, triangleArrayNormals] = cull(model.triangleArray, triangleArrayNormals);

    % Project the warped shape onto the image plane
    [P] = project(W, projectionMatrix, projectionType);
    
    % Discard all those triangles with at least one vertex outside of
    % the viewing volume
    [triangleArray, ~] = clip(P, triangleArray, triangleArrayNormals);
    
    % Compute the direction of the light vector, the light reflection
    % vector, and viewing vector needed to apply the Phong illumination
    % model
    [reflectionVector, viewVector] = computeIlluminationVectors(W, N, lightVector);

    % Rasterize
    [img] = rasterize_lights_shadows(triangleArray, P, T, colorMatrix, L_amb,  L_dir, lightVector, viewVector, reflectionVector, N, ks, v, shadowBuffer, lightP(:,:,5), resolution, sb_resolution, projectionType);
    
    
    %% Save Image 
    
    I_model.img = uint8(img);
    I_model.resolution = resolution;
    I_model.rhoArray = rhoArray;
    I_model.alphaArray = alphaArray;
    I_model.betaArray = betaArray;

end

