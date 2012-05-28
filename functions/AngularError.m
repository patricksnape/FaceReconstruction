function [ error ] = AngularError(groundtruth, estimate)
%ANGULARERROR Calculates the sum of the absolute difference in angle between
%the two given normals fields

    groundtruth = reshape2colvector(Image2ColVector3(groundtruth));
    estimate = reshape2colvector(Image2ColVector3(estimate));

    error = 0;
    
    for i = 1:size(estimate, 2)
        error = error + abs(atan2(norm(cross(groundtruth(:, i), estimate(:, i))), dot(groundtruth(:, i), estimate(:, i))));
    end
end

