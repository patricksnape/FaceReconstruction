clear all
close all
clc

%% Define Data Path

data_path = 'data';


%% Load 3D Morphable Model

load([data_path '/morphable_model']);


%% Define Projection Parameters
    
rhoArray = zeros(7, 1);
rhoArray(1)  = 30;       % focal length
rhoArray(2)  = 0.0;      % phi
rhoArray(3)  = 0.0;      % theta
rhoArray(4)  = 0.0;      % varphi
rhoArray(5)  = 0.0;      % tw_x
rhoArray(6)  = 0.0;      % tw_y
rhoArray(7)  = 0.0;      % tw_z

%% Define light parameters

iotaArray = zeros(17, 1);

iotaArray(1)  = 1;       % g_r - color correction?
iotaArray(2)  = 1;       % g_g - color correction?
iotaArray(3)  = 1;       % g_b - color correction?
iotaArray(4)  = 1;       % c - color correction?
iotaArray(5)  = 0;       % o_r - color offset?
iotaArray(6)  = 0;       % o_g - color offset?
iotaArray(7)  = 0;       % o_b - color offset?
iotaArray(8)  = 0.5;     % Ambient Light Red Channel
iotaArray(9)  = 0.5;     % Ambient Light Green Channel
iotaArray(10)  = 0.5;    % Ambient Light Blue Channel
iotaArray(11)  = 0.5;    % Directed Light Red Channel
iotaArray(12)  = 0.5;    % Directed Light Green Channel
iotaArray(13)  = 0.5;    % Directed Light Blue Channel
iotaArray(14)  = 0.0;    % theta - Azimuth
iotaArray(15)  = 0.0;    % phi - Elevation
iotaArray(16)  = 30;    % Ks - specular?
iotaArray(17)  = 40;   % v - specular?


%% Define Shape Parameters

model_size = 100;

alphas = randn(199, 199);

alphas2 = (alphas .* repmat(sqrt(model.shapeEV'), 199, 1)).^2;

alphaArray = model_size * (alphas2 ./ repmat(sum(abs(alphas2), 1), 199, 1));

if rank(alphaArray) == 199
  
  disp('shape coefficient matrix is full rank!');
  
  
  %% Define Texture Parameters

  betas = randn(199, 199);

  betas2 = (betas .* repmat(sqrt(model.shapeEV'), 199, 1)).^2;

  betaArray = model_size * (betas2 ./ repmat(sum(abs(betas2), 1), 199, 1));
  
  if rank(betaArray) == 199
  
    disp('texture coefficient matrix is full rank!');


    %% Define Control Parameters

    display = true;
    verbose = true;


    %% Define Image Resolution

    resolution =  [256 256];


    %% Define Type of Projection

    projectionType = 1; % perspective projection


    %% Load Feature Points

    load([data_path '/fp.mat']);
    
    I_model = cell(199, 1);

    %% Generate Data

    for i = 1:199
    
      I_model{i} = generateData(model, fp, rhoArray, iotaArray, alphaArray(:,i), betaArray(:,i), resolution, projectionType);

      % Define path
      synthetic_path = [data_path '/images/trainingset'];

      % Save buffers
      %imwrite(frame_buffer, [synthetic_path '/00' int2str(i) 'f.png'] , 'png');
      %imwrite(xyz_buffer(:,:,3), [synthetic_path '/00' int2str(i) 'z.png'] , 'png');
      %imwrite(norm_buffer, [synthetic_path '/00' int2str(i) 'n.png'] , 'png');

      if display

        figure(1);
        subplot(1,3,1)
        imshow(I_model{i}.textureBuffer);
        drawnow;
        
        subplot(1,3,2)
        imshow(-I_model{i}.xyzBuffer(:,:,3),[]);
        drawnow;

        subplot(1,3,3)
        imshow(I_model{i}.normBuffer,[]);
        drawnow;
        
      end

      if verbose

        disp(['Iteration  : ', num2str(i)]);
        disp(' ');
        disp(' ');

      end

    end

    
  else

  disp('texture coefficient matrix is NOT full rank!');
  
  end
   
else
  
  disp('shape coefficient matrix is NOT full rank!');
  
end


