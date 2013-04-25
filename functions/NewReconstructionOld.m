function [ a, c ] = NewReconstructionOld(texture, Un, Ut, TAvg, XnAvg, s)
%NEWRECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

P = size(Un, 2);
[M N] = size(texture);

texture = Image2ColVector(texture) ;
a = rand(P, 1);
c = rand(P, 1);
cold = rand(P, 1);
aold = rand(P, 1);

q = calcNormaldotLight(Un, s, M, N);

meanq = calcNormaldotLight(XnAvg, s, M, N);
meanq(meanq < 0) = 0;

%q(q < 0) = 0;

%w = q * c;


  wtmp = (Un * c) + XnAvg ;
     wtmp = reshape2colvector(wtmp);
     w = bsxfun(@rdivide, wtmp, colnorm(wtmp));
     w = reshape(w, [], 1);
     w = calcNormaldotLight(w, s, M, N);
    %w = (q * c) + meanq;
    w(w<0) = 0;


Rtx = calcRx(w, Ut);
Mtx = Rtx * Rtx';
texvec = repmat(texture - TAvg, 1, P)';
Ktx = Rtx .* texvec;
Ktx = sum(Ktx, 2);



for i=1:20
    %sum(abs(c - cold)) + sum(abs(a - aold))
    
    % matlab says this is faster than inv(Mtx) * Ktx;
    a = Mtx\Ktx;

    % calculate normal weights
    rho = (Ut * a) + TAvg;

    Rnx = calcRx(rho, q);
    Mnx = Rnx * Rnx'; 
    texvec = repmat(texture - (rho .* meanq), 1, P)';
    Knx = Rnx .* texvec;
    Knx = sum(Knx, 2);

    c = Mnx\Knx;

     wtmp = ((Un * c) + XnAvg);
     wtmp = reshape2colvector(wtmp);
     w = bsxfun(@rdivide, wtmp, colnorm(wtmp));
     w = reshape(w, [], 1);
     w = calcNormaldotLight(w, s, M, N);
    %w = (q * c) + meanq;
    w(w<0) = 0;

    Rtx = calcRx(w, Ut);
    Mtx = Rtx * Rtx';
    texvec = repmat(texture - (w .* TAvg), 1, P)';
    Ktx = Rtx .* texvec;
    Ktx = sum(Ktx, 2);
end

end

function q = calcNormaldotLight(ntilde, s, m, n)
    P = size(ntilde, 2);   
    F = size(ntilde, 1) / 3;
    
    svec(:,:,1) = repmat(s(1), m, n);
    svec(:,:,2) = repmat(s(2), m, n);
    svec(:,:,3) = repmat(s(3), m, n);
    q = zeros(F, P);
    
    for i=1:P
       np = ntilde(:, i);
%        np = reshape2colvector(np);
%        np = bsxfun(@rdivide, np, colnorm(np));
%        np = reshape(np, [], 1);
       np = ColVectorToImage3(np, m, n);
       q(:, i) = Image2ColVector(dot(np, svec, 3))';
    end
end

function r = calcRx(w, u)
    P = size(u, 2);
    F = size(w, 1);
    r = zeros(P, F);
    
    for i=1:P
       r(i, :) = w .* u(:, i);
    end
end