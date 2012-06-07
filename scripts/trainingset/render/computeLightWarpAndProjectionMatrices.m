function [lightR, lightViewMatrix, lightProjectionMatrix] = computeLightWarpAndProjectionMatrices(lightVector, rhoArray, projectionType)
    
    %   COMPUTERENDERPARAMETERS Summary of this function goes here
    %   Detailed explanation goes here
    
    %% 3D Rotation 
    
    V_aux = [0 1 0 0]';
    V = V_aux - (V_aux' * lightVector) * lightVector;
    V = normc(V);
    
    U = zeros(4,1);
    U(1:3,1) = cross(V(1:3,1),lightVector(1:3,1));
    U = normc(U);
    
    lightR = eye(4);
    lightR(1,:) = U';
    lightR(2,:) = V';
    lightR(3,:) = lightVector';

    
    %% 3D Translation
    
%     lightTranslation= eye(4);
%     lightTranslation(1:3,4) = -lightVector(1:3,1);
    
    Translation_tw = eye(4);
    Translation_tw(:,4) = [0, 0, 12, 1]';
    
    
    %% View Matrix
    
    lightViewMatrix = Translation_tw * lightR; %* lightTranslation;
    
    
    %% Projection Matrix
    
    farPlane = 50;
    if (projectionType == 0)
      nearPlane = 1;
    else
      nearPlane = 20;
    end
    
    uMax = 2;
    uMin = -2;

    vMax = 2;
    vMin = -2;
    
    M_pers1a = eye(4);
    M_pers1a(1,3) = (uMax + uMin) / (uMax - uMin);
    M_pers1a(2,3) = (vMax + vMin) / (uMax - uMin);

    M_pers1b = eye(4);
    M_pers1b(1,1) = 2 * nearPlane / (uMax - uMin);
    M_pers1b(2,2) = 2 * nearPlane / (vMax - vMin);

    if (projectionType == 0)
        
        M_pers2 = eye(4);
        M_pers2(3,3) = 2 * nearPlane / (farPlane - nearPlane);
        M_pers2(3,4) = - (farPlane + nearPlane) / (farPlane - nearPlane);
        
    else
       
        M_pers2 = eye(4);
        M_pers2(3,3) = (farPlane + nearPlane) / (farPlane - nearPlane);
        M_pers2(3,4) = - 2 * farPlane * nearPlane / (farPlane - nearPlane);
        M_pers2(4,3) = 1;
        M_pers2(4,4) = 0;

    end

    lightProjectionMatrix = M_pers2 * M_pers1b * M_pers1a;
    
    
end