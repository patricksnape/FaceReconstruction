function [P] = perspectiveDivision(P)
    
    %   PROJECT Summary of this function goes here
    %   Detailed explanation goes here

    P = P ./ repmat(P(4,:), 4, 1);
    
end

