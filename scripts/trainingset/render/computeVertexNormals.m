function [N] = computeVertexNormals(S, triangleArray, triangleArrayNormals)
    
    %   COMPUTENORMALS Summary of this function goes here
    %   Detailed explanation goes here
    
    nVertices = size(S, 2);
    N = zeros(4, nVertices);
    
    parfor i = 1:nVertices 

        [~, index] = find(triangleArray == i);
        N(:,i) = sum(triangleArrayNormals(:, index), 2);

    end

    N = normc(N);
    
end

