function [ error ] = HeightError(groundtruth, nestimate)
%HEIGHTERROR Calculates the sum of the absolute difference in height between
%the two given normals fields after integration

    % construct mesh vertices
    [m, n, ~] = size(nestimate);
    Z_vertex_estimate = integrate_normals(nestimate);
    Z_vertex_ground = integrate_normals(groundtruth);
    
    error = abs(Z_vertex_estimate - Z_vertex_ground);

    error = reshape(error, [], 1);
    error = ColVectorToImage(error, m, n);
end

function z = integrate_normals(normals)
    Nx = normals(:, :, 1);
    Ny = normals(:, :, 2);
    Nz = normals(:, :, 3);

    % extract the reconstructed height map
    z = FrankotChellappa(-Nx, Ny, Nz);
end