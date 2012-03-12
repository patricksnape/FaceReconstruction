function [ u, v ] = NormalsFromDepthMap( zBuffer )
 
hh=double(zBuffer);
  
[ny_1, nx_1] = size(hh);
y = (-(ny_1-0.5)/2 : (ny_1-0.5)/2) .* 2/ny_1;
x = (-(nx_1-0.5)/2 : (nx_1-0.5)/2) .* 2/nx_1;
[X_1, Y_1]=meshgrid(x,y);
clear x y ny_1 nx_1;
   
% recenter object
X_1=X_1-min(X_1(:));
Y_1=Y_1-min(Y_1(:));
[u,v,~]=surfnorm(X_1,Y_1,hh);
clear hh X_1 Y_1;
u=-u; v=-v;


end

