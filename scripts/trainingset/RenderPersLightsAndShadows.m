%% Define projection parameters
    
% rhoArray = fitting.rhoArray;

rhoArray = zeros(7, 1);

rhoArray(1)  = 25;     % focal length
rhoArray(2)  = 0.0;      % phi
rhoArray(3)  = 0.0;      % theta
rhoArray(4)  = 0.0;      % varphi
rhoArray(5)  = 0.0;      % tw_x
rhoArray(6)  = 0.0;      % tw_y
rhoArray(7)  = 0.0;      % tw_z


%% Define illumination and color correction parameters
    
% iotaArray = fitting.iotaArray;

iotaArray = zeros(17, 1);

iotaArray(1)  = 1;       % g_r
iotaArray(2)  = 1;       % g_g
iotaArray(3)  = 1;       % g_b
iotaArray(4)  = 1;       % c
iotaArray(5)  = 0;       % o_r
iotaArray(6)  = 0;       % o_g
iotaArray(7)  = 0;       % o_b
iotaArray(8)  = 0.5;     % L_amb_r
iotaArray(9)  = 0.5;     % L_amb_g
iotaArray(10)  = 0.5;    % L_amb_b
iotaArray(11)  = 0.7;    % L_dir_r
iotaArray(12)  = 0.7;    % L_dir_g
iotaArray(13)  = 0.7;    % L_dir_b
iotaArray(14)  = 30.0;    % theta_l
iotaArray(15)  = 0.0;    % phi_l
iotaArray(16)  = 30;    % Ks
iotaArray(17)  = 40;   % v


%% Define shape parameters
   
% alphaArray = fitting.alphaArray;

% alphaArray = fitting.alphaArraySegments;

% alphaArray = zeros(199, 1);

% alphaArray(1:199,1) = randn(199, 1);
 
alphaArray = [randn(199, 1), randn(199, 1), randn(199, 1), rand(199, 1)];


%% Define texture parameters
    
% betaArray = fitting.betaArray;

% betaArray = fitting.betaArraySegments;

% betaArray = zeros(199, 1);

% betaArray(1:199,1) = randn(199, 1);

betaArray = [randn(199, 1), randn(199, 1), randn(199, 1), rand(199, 1)];


%% Define image resolution

resolution = [512 512];


%% Define type of projection

projectionType = 1; % perspective projection


%% Generate image

[I_input] = generateImageLightsAndShadows(model, resolution, rhoArray, iotaArray, alphaArray, betaArray, projectionType, fp);


%% Show image

figure();
imshow(I_input.textureBuffer);