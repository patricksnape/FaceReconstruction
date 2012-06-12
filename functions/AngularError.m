function [ error ] = AngularError(groundtruth, nestimate)
%ANGULARERROR Calculates the sum of the absolute difference in angle between
%the two given normals fields

    [m n ~] = size(nestimate);
    groundtruth = reshape2colvector(Image2ColVector3(groundtruth));
    estimate = reshape2colvector(Image2ColVector3(nestimate));

    error = zeros(size(estimate, 2), 1);
    
    for i = 1:size(estimate, 2)
        error(i) = abs(atan2(norm(cross(groundtruth(:, i), estimate(:, i))), dot(groundtruth(:, i), estimate(:, i))));
    end
    
    error = reshape(error, [], 1);
    error = error / max(error);
    error = ColVectorToImage(error, m, n);
end

