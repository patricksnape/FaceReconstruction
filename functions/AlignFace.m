function output = AlignFace(image, L_E_Y, Nose_Y, Low_Y, R_E_Y, L_E_X, Nose_X, Low_X, R_E_X)

pts=[L_E_Y Nose_Y Low_Y R_E_Y; L_E_X Nose_X Low_X R_E_X];
% figure; imshow(Mask, []);  colormap(gray); axis equal; hold on
% plot(pts(2, :), pts(1, :), 'o');

disC1=40; disC3=90; disC2=65;
L_E_X=10;
R_E_X=L_E_X+disC3+disC1;
Nose_X=L_E_X+disC2;
Low_X=L_E_X+disC2;

disR1=0; disR3=0; disR2=60;
L_E_Y=40;
R_E_Y=L_E_Y+disR3+disR1;
Nose_Y=L_E_Y+disR2;
Low_Y=L_E_Y+2*disR2;

template_affine=[L_E_X Nose_X Low_X R_E_X;
                 L_E_Y Nose_Y Low_Y R_E_Y];

test_pts=flipud(pts);

M=[template_affine; ones(1,size(template_affine,2))]' \ [test_pts; ones(1,size(test_pts,2))]';
M=M';

% Warp original image to get test "template" image
template_nx=R_E_X+L_E_X;
template_ny=L_E_X+Low_Y;
template_pts=[1,1;
              1,template_ny;
              template_nx,template_ny;
              template_nx,1]';

if (ndims(image) == 2)
    output = quadtobox(double(squeeze(image)),template_pts,M,'bilinear')/double(max(max(image)));
else
    output(:,:,1)=quadtobox(double(squeeze(image(:,:,1))),template_pts,M,'bilinear')./double(max(max(image(:,:,1))));
    output(:,:,2)=quadtobox(double(squeeze(image(:,:,2))),template_pts,M,'bilinear')./double(max(max(image(:,:,2))));
    output(:,:,3)=quadtobox(double(squeeze(image(:,:,3))),template_pts,M,'bilinear')./double(max(max(image(:,:,3))));       
end

end