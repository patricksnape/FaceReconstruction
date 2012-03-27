function [R_phi, R_theta, R_varphi, R_total, viewMatrix, projectionMatrix] = computeWarpAndProjectionMatrices(rhoArray, projectionType)
    
    %   COMPUTERENDERPARAMETERS Summary of this function goes here
    %   Detailed explanation goes here
    
    %% 3D Rotation 
    
    R_phi = eye(4);
    R_phi(2:3,2:3) = [cos(rhoArray(2))  -sin(rhoArray(2))
                      sin(rhoArray(2))   cos(rhoArray(2))];

   
    R_theta = eye(4);
    R_theta(1:3,1:3) = [cos(rhoArray(3))  0  -sin(rhoArray(3))
                             0             1        0      
                        sin(rhoArray(3))  0   cos(rhoArray(3))];

    
    R_varphi = eye(4);
    R_varphi(1:2,1:2) = [cos(rhoArray(4))  -sin(rhoArray(4))
                         sin(rhoArray(4))   cos(rhoArray(4))];            

    
    R_total = R_varphi * R_theta * R_phi;

    
    %% 3D Translation
    
    if (projectionType == 0)
    
        tw = [rhoArray(5) rhoArray(6) 0 1]';
    
    else
        
        tw = [rhoArray(5) rhoArray(6) rhoArray(7) 1]'; 
        
    end
    
    to = [0 0 0 1]';
    tc = [0, 0, -20 1]';
    
    Translation_tw = eye(4);
    Translation_tw(:,4) = (R_total * to + tw - tc);
    
    
    %% View Matrix
    
    viewMatrix = Translation_tw * R_total;
    
    
    %% Projection Matrix
    
    farPlane = 50;
    nearPlane = rhoArray(1);
    
    uMax = 2;
    uMin = -2;

    vMax = 2;
    vMin = -2;
    
    M_pers1a = eye(4);
    M_pers1a(1,3) = (uMax + uMin) / (uMax - uMin);
    M_pers1a(2,3) = (vMax + vMin) / (uMax - uMin);

    M_pers1b = eye(4);
    M_pers1b(1,1) = 2 * rhoArray(1) / (uMax - uMin);
    M_pers1b(2,2) = 2 * rhoArray(1) / (vMax - vMin);

    if (projectionType == 0)
        
        M_pers2 = eye(4);
        M_pers2(3,3) = 2 * rhoArray(1) / (farPlane - nearPlane);
        M_pers2(3,4) = - (farPlane + nearPlane) / (farPlane - nearPlane);
        
    else
       
        M_pers2 = eye(4);
        M_pers2(3,3) = (farPlane + nearPlane) / (farPlane - nearPlane);
        M_pers2(3,4) = - 2 * farPlane * nearPlane / (farPlane - nearPlane);
        M_pers2(4,3) = 1;
        M_pers2(4,4) = 0;

    end

    projectionMatrix = M_pers2 * M_pers1b * M_pers1a;
    
    
end