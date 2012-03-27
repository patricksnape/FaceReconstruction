function [P] = project(W, projectionMatrix, projectionType)
    
    %   PROJECT Summary of this function goes here
    %   Detailed explanation goes here

    P = projectionMatrix * W;
    
    
    % If projection type is perspective, perpective division needs to be 
    % performed 
    if (projectionType == 1)
        
         P = P ./ repmat(P(4,:), 4, 1);
         
    end
    
end

