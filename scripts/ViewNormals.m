[x,y] = meshgrid(1:150, 1:170);
z = ones(170,150);
%nimg = I_model{1}.aligned;
%nimg = ColVectorToImage3(reshape(C, [], 1), 170, 150);
nimg = ColVectorToImage3(n, 170, 150);

q = 5;
quiver3(x(1:q:end,1:q:end),y(1:q:end,1:q:end),z(1:q:end,1:q:end),nimg(1:q:end,1:q:end,1), nimg(1:q:end,1:q:end,2),nimg(1:q:end,1:q:end,3))