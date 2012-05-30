function n = OnConeRotation(theta, nprime, s)
    % 3 x N format
    nprime = reshape2colvector(nprime);
    % repmat to match 3 x N format above
    svec = repmat(s', 1, size(nprime, 2));
    
    % cross product and break in to row vectors
    C = cross(nprime, svec);
    reshape(bsxfun(@rdivide, C, colnorm(C)), [], 1);
    
    u = C(1, :);
    v = C(2, :);
    w = C(3, :);
    
    % expects |nprime|  = |sec| = 1
    % represents intensity and can never be < 0
    d = dot(nprime, svec);
    d(d < 0) = 0;
    
    % reshape theta to row vector
    theta = Image2ColVector(theta)';
    
    beta = acos(d);    
    alpha = theta - beta;
    % flip alpha so that it rotates along the correct axis
    alpha = -alpha;
    
    c = cos(alpha);
    cprime = 1 - c;
    s = sin(alpha);
    
    % setup structures
    N = size(u, 2);  
    n = zeros(size(nprime));
    phi = zeros(3, 3);
    
    for i=1:N
        phi(1,1) = c(i) + u(i)^2 * cprime(i);
        phi(1,2) = -w(i) * s(i) + u(i) * v(i) * cprime(i);
        phi(1,3) = v(i) * s(i) + u(i) * w(i) * cprime(i);
        
        phi(2,1) = w(i) * s(i) + u(i) * v(i) * cprime(i);
        phi(2,2) = c(i) + v(i)^2 * cprime(i);
        phi(2,3) = -u(i) * s(i) + v(i) * w(i) * cprime(i);
        
        phi(3,1) = -v(i) * s(i) + u(i) * w(i) * cprime(i);
        phi(3,2) = u(i) * s(i) + v(i) * w(i) * cprime(i);
        phi(3,3) = c(i) + w(i)^2 * cprime(i);
          
        n(:, i) = phi * nprime(:, i);
    end
    
    % Normalize the result ??
    n = bsxfun(@rdivide, n, colnorm(n));
    
    % reshape back to column vector
    n = reshape(n, [], 1);
end