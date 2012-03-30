function [dx dy] = longRangeGradient(I, n)

  f_size = 2 * n + 1;
  X = zeros(f_size, f_size);
  Y = zeros(f_size, f_size);

  ii = f_size;
  jj = f_size;
  
  for i = 1:f_size
    
    for j = 1:f_size
      
      X(i,j) = ii;
      Y(i,j) = jj;
      
      jj = jj - 1;

    end
    
    jj = f_size;
    ii = ii - 1;
    
  end
  
  X = X - (n+1);
  Y = Y - (n+1);
  
  XYZ = [X(:) Y(:)];
  XYZ(:,3) = 1; 
  
  pinv_XYZ = pinv(XYZ);
  A = reshape(pinv_XYZ(1,:), f_size, f_size);
  B = reshape(pinv_XYZ(2,:), f_size, f_size);
  
  dy = conv2(I, A, 'same');
  dx = conv2(I, B, 'same');  
     
end