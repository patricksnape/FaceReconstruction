function ViewNormals(nimg)
    if (ndims(nimg) == 2)
        if (size(nimg, 1) == 3)
            nimg = reshape(nimg, [], 1);
        end
        
        nimg = ColVectorToImage3(nimg, 170, 150);
    end
    
    [x,y] = meshgrid(1:150, 1:170);
    z = ones(170,150);
    %nimg = ColVectorToImage3(reshape(C, [], 1), 170, 150);

    q = 5;
    figure(1);
    quiver3(x(1:q:end,1:q:end),y(1:q:end,1:q:end),z(1:q:end,1:q:end),nimg(1:q:end,1:q:end,1), nimg(1:q:end,1:q:end,2),nimg(1:q:end,1:q:end,3));

    figure(2);
    imshow(nimg, []);
end