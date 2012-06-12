
function [Nx Ny Nz AA]=Call_StandardPS(I, L, NN)

ssII=size(I); 
[t1 t2]=size(ssII);
if (t2>3)
    flag_PSGrey=0;
else
    flag_PSGrey=1;
end

if (flag_PSGrey==0)%Colour PS
    [height width C N]=size(I);
    Img=zeros(height, width, N);
    for (ii=1:size(I,4))
        Img(:,:,ii)=rgb2gray(I(:,:,:,ii));
    end
elseif (flag_PSGrey==1)%Grey PS      
    Img=I;    
end

[errorIndex n p q albedo]=PhotometricStereoAll(L, Img);
Nx=n(:,:,1);
Ny=n(:,:,2);
Nz=n(:,:,3);
AA=albedo;
