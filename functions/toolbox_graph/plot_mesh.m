function h = plot_mesh(vertex,face,options)

% plot_mesh - plot a 3D mesh.
%
%   plot_mesh(vertex,face, options);
%
%   'options' is a structure that may contains:
%       - 'normal' : a (nvertx x 3) array specifying the normals at each vertex.
%       - 'edge_color' : a float specifying the color of the edges.
%       - 'face_color' : a float specifying the color of the faces.
%       - 'face_vertex_color' : a color per vertex or face.
%       - 'vertex'
%
%   See also: mesh_previewer.
%
%   Copyright (c) 2004 Gabriel Peyr�


if nargin<2
    error('Not enough arguments.');
end

options.null = 0;

name            = getoptions(options, 'name', '');
normal          = getoptions(options, 'normal', []);
face_color      = getoptions(options, 'face_color', .7);
edge_color      = getoptions(options, 'edge_color', 0);
normal_scaling  = getoptions(options, 'normal_scaling', .8);
sanity_check = getoptions(options, 'sanity_check', 1);

if size(vertex,1)==2
    % 2D triangulation
    % vertex = cat(1,vertex, zeros(1,size(vertex,2)));
    plot_graph(triangulation2adjacency(face),vertex);
    return;
end

% can flip to accept data in correct ordering
[vertex,face] = check_face_vertex(vertex,face);

if size(face,1)==4
    %%%% tet mesh %%%%

    % normal to the plane <x,w><=a
    w = getoptions(options, 'cutting_plane', [0.2 0 1]');
    w = w(:)/sqrt(sum(w.^2));
    t = sum(vertex.*repmat(w,[1 size(vertex,2)]));
    a = getoptions(options, 'cutting_offs', median(t(:)) );
    b = getoptions(options, 'cutting_interactive', 0);
    plot_points = getoptions(options, 'plot_points', 0);
    
    while true;

        % in/out
        I = ( t<=a );
        % trim
        e = sum(I(face));
        J = find(e==4);
        facetrim = face(:,J);

        % convert to triangular mesh
        hold on;
        if not(isempty(facetrim))
            face1 = tet2tri(facetrim, vertex, 1);
            % options.method = 'slow';
            face1 = perform_faces_reorientation(vertex,face1, options);
            h{1} = plot_mesh(vertex,face1, options);
        end
        view(3); % camlight;
        shading faceted;
        if plot_points
            K = find(e==0);
            K = face(:,K); K = unique(K(:));
            h{2} = plot3(vertex(1,K), vertex(2,K), vertex(3,K), 'k.');
        end
        hold off;
        
        if b==0
            break;
        end

        [x,y,b] = ginput(1);
        
        if b==1
            a = a+.03;
        elseif b==3
            a = a-.03;
        else
            break;
        end
    end
    return;    
end


vertex = vertex';
face = face';

if sanity_check && (size(face,2)~=3 || (size(vertex,2)~=3 && size(vertex,2)~=2))
    error('face or vertex does not have correct format.');
end

if ~isfield(options, 'face_vertex_color') || isempty(options.face_vertex_color)
    options.face_vertex_color = zeros(size(vertex,1),1);
end
face_vertex_color = options.face_vertex_color;

shading_type = 'interp';
if isempty(face_vertex_color)
    h = patch('vertices',vertex,'faces',face,'facecolor',[face_color face_color face_color],'edgecolor',[edge_color edge_color edge_color]);
else
    nverts = size(vertex,1);
    % vertex_color = rand(nverts,1);
    if size(face_vertex_color,1)==size(vertex,1)
        shading_type = 'interp';
    else
        shading_type = 'flat';
    end
    h = patch('vertices',vertex,'faces',face,'FaceVertexCData',face_vertex_color, 'FaceColor',shading_type);
end
colormap gray(256);
lighting none;
% camlight infinite; 
camproj('perspective');
axis square; 
axis off;

if ~isempty(normal)
    % plot the normals
    n = size(vertex,1);
    subsample_normal = getoptions(options, 'subsample_normal', 1);
    sel = randperm(n); sel = sel(1:floor(end*subsample_normal));    
    hold on;
    quiver3(vertex(sel,1),vertex(sel,2),vertex(sel,3),normal(1,sel)',normal(2,sel)',normal(3,sel)',normal_scaling);
    hold off;
end

cameramenu;
view_param = getoptions(options, 'view_param', []);
if not(isempty(view_param))
    view(view_param(1),view_param(2));
end

axis tight;
axis equal;
shading(shading_type);
camlight;