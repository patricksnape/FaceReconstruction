function TexturizeRecoveredFace(texture, normals, albedo)
    Nx = normals(:, :, 1);
    Ny = normals(:, :, 2);
    Nz = normals(:, :, 3);

    color_mean =  [reshape(texture(:,:,1)', size(albedo,1) * size(albedo,2),1)'; ...
                   reshape(texture(:,:,2)', size(albedo,1) * size(albedo,2),1)'; ... 
                   reshape(texture(:,:,3)', size(albedo,1) * size(albedo,2),1)'];

    % create the mesh grid and perform the delauney triangulation 
    [ny_1 nx_1] = size(Nx);
    [X_1, Y_1]  = meshgrid(1:(ny_1), 1:(nx_1));
    triangles   = delaunay(X_1, Y_1);
    
    % extract the reconstructed height map
    hh = FrankotChellappa(-Nx, Ny, Nz);

    hh_1_T= (hh(1:(ny_1), 1:(nx_1)))';

    X_vertex = X_1(1:size(X_1, 1) * size(X_1, 2));
    Y_vertex = Y_1(1:size(Y_1, 1) * size(Y_1, 2));
    Z_vertex = hh_1_T(1:size(Y_1, 1) * size(Y_1, 2));

    vertices = [X_vertex ;Y_vertex ; Z_vertex];

    normals =  [ Nx(1:size(X_1,1) * size(X_1,2)); ...
                 Ny(1:size(X_1,1) * size(X_1,2)); ...
                 Nz(1:size(X_1,1) * size(X_1,2)) ];

    %options.normal = normals';
    options.face_vertex_color = color_mean';

    plot_mesh(vertices, triangles', options);
    shading interp;
end