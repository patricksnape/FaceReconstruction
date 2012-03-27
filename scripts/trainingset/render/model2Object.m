function [object] = model2Object(coeff, mean, pc, ev, MM, MB)
    
    %   model2Object
    
    
    %% Arguments checking
    
    if nargin ~= 4 && nargin ~= 6
      error('Inappropriate number of arguments')
    end

    if nargout ~= 1
      error('One output argument required')
    end

    n_seg = size(coeff, 2);
    if nargin == 4 && n_seg > 1
      error('Blending reconstruction requested, but blending parameters missing')
    end

    n_dim = size(coeff, 1);
    if n_dim > size(pc, 2)
      error('Too many coefficients.')
    end
    
    
    %% Reconstruction
    
    object = mean * ones([1 n_seg]) + pc(:,1:n_dim) * (coeff .* (ev(1:n_dim) * ones([1 n_seg])));
    if (n_seg == 1)
      return; 
    end
    
    %% Blending (optional)
    
    n_ver = size(object,1)/3;
    all_ver = zeros(n_seg*n_ver, 3);
    k = 0;
    for i = 1:n_seg
      all_ver(k+1:k+n_ver, :) = reshape(object(:,i), 3, n_ver)';
      k = k+n_ver;
    end
    clear object k
    object = (MM \ (MB*all_ver) )';
    object = object(:);
    
    
end