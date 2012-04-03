color_mean =  [reshape(texture(:,:,1)', size(albedo,1) * size(albedo,2),1)'; ...
               reshape(texture(:,:,2)', size(albedo,1) * size(albedo,2),1)'; ... 
               reshape(texture(:,:,3)', size(albedo,1) * size(albedo,2),1)'];
%color_mean = color_mean / 255;

% create the mesh grid and perform the delauney triagulation 
[ny_1 nx_1] = size(Nx); % [ny nx] = size(Nx);
[X_1, Y_1]  = meshgrid(1:(ny_1), 1:(nx_1)); % [X ,Y] = meshgrid(1:(ny),1:(nx)); 
triangles   = delaunay(X_1, Y_1);  %this are the triangles 

hh_1_T= (hh(1:(ny_1), 1:(nx_1)))';

X_vertex = X_1(1:size(X_1,1) * size(X_1,2));
Y_vertex = Y_1(1:size(Y_1,1) * size(Y_1,2));
Z_vertex = hh_1_T(1:size(Y_1,1) * size(Y_1,2));

vertices = [X_vertex ;Y_vertex ; Z_vertex];

normals =  [ Nx(1:size(X_1,1) * size(X_1,2)); ...
             Ny(1:size(X_1,1) * size(X_1,2)); ...
             Nz(1:size(X_1,1) * size(X_1,2)) ];

figure;
clear options;
%options.normal = normals';
options.face_vertex_color = color_mean';

plot_mesh(vertices, triangles', options);
%plot_mesh(vertices, triangles');
shading interp;
