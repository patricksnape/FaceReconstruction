function [reflectionVector, viewVector] = computeIlluminationVectors(W, N, lightVector)

    %   UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
               
    reflectionVector = 2 * repmat((lightVector' * N), [4, 1]) .* N -  repmat(lightVector, [1, size(N,2)]);
    reflectionVector = normc(reflectionVector);
    
    

    W(4,:) = 0;
    viewVector = -normc(W);
    
%     reflectionVector = N + viewVector;
%     reflectionVector = normc(reflectionVector);

end

