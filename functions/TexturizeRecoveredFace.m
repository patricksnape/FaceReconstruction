function TexturizeRecoveredFace(texture, normals, albedo)
    Nx = normals(:, :, 1);
    Ny = normals(:, :, 2);
    Nz = normals(:, :, 3);
    
    [sizeY sizeX] = size(Nx);
    totalLength = sizeX * sizeY;

    if (ndims(texture) == 3)
        color_mean =  [ reshape(texture(:,:,1)', totalLength, 1)'; ...
                        reshape(texture(:,:,2)', totalLength, 1)'; ... 
                        reshape(texture(:,:,3)', totalLength, 1)' ];
    else
        color_mean =  [ reshape(texture(:,:)', totalLength, 1)'; ...
                        reshape(texture(:,:)', totalLength, 1)'; ...
                        reshape(texture(:,:)', totalLength, 1)'; ];
    end

    % create the mesh grid and perform the delauney triangulation 
    [X_1, Y_1]  = meshgrid(1:(sizeY), 1:(sizeX));
    triangles   = delaunay(X_1, Y_1);
    
    % extract the reconstructed height map
    hh = FrankotChellappa(-Nx, Ny, Nz);
    hh_1_T= (hh(1:(sizeY), 1:(sizeX)))';

    % construct mesh vertices
    X_vertex = X_1(1:totalLength);
    Y_vertex = Y_1(1:totalLength);
    Z_vertex = hh_1_T(1:totalLength);

    vertices = [ X_vertex; ...
                 Y_vertex; ...
                 Z_vertex ];

    % reconstruct normals to 3xN
    normals =  [ Nx(1:totalLength); ...
                 Ny(1:totalLength); ...
                 Nz(1:totalLength) ];

    %options.normal = normals';
    options.face_vertex_color = color_mean';

    plot_mesh(vertices, triangles', options);
    shading interp;
end