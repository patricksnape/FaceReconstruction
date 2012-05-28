function [ks, v, L_amb, L_dir, L_spec, G, C, M, colorMatrix] = computeIlluminationAndColorCorrectionParameters(iotaArray)

    %   UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    %% Color Gain and Contrast
    
    G = eye(4);
    G(1,1) = iotaArray(1);
    G(2,2) = iotaArray(2);
    G(3,3) = iotaArray(3);
    
    L = [0.3  0.59  0.11  0; ...
         0.3  0.59  0.11  0; ...
         0.3  0.59  0.11  0; ...
         0    0     0     1];
    
    C = eye(4) + (1 - iotaArray(4)) * L;
    
    M = G * C;
    
 
    %% Color Offset 
    
    offset = [iotaArray(5) iotaArray(6) iotaArray(7) 1]';
    
    M_o = eye(4);
    M_o(:,4) = offset;
    
    
    %% Color Correction Matrix
    
    colorMatrix = M_o * M;
    
    
    %% Ambient Light Matrix
    
    L_amb = eye(4);
    L_amb(1,1) = iotaArray(8);
    L_amb(2,2) = iotaArray(9);
    L_amb(3,3) = iotaArray(10);
    
    
    %% Directed Light Matrix

    L_dir = eye(4);
    L_dir(1,1) = iotaArray(11);
    L_dir(2,2) = iotaArray(12);
    L_dir(3,3) = iotaArray(13);
    
    %% Specular Light Matrix

    L_spec = eye(4);
    L_spec(1,1) = 1 - iotaArray(11);
    L_spec(2,2) = 1 - iotaArray(12);
    L_spec(3,3) = 1 - iotaArray(13);
    
    
    %% Specular Light Parameters
    
    ks = iotaArray(16);
    v = iotaArray(17);

    
end

