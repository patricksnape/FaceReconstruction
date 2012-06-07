function [ a, c ] = NewReconstruction(texture, Un, Ut, TAvg, XnAvg, l)
%NEWRECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

P = size(Un, 2);
[M N] = size(texture);

texture = Image2ColVector(texture) ;
tmp = texture - TAvg;
texvec1 = repmat(tmp, 1, P)';
texvec = repmat(texture, 1, P)';
a = rand(P, 1);
c = rand(P, 1);
cold = rand(P, 1);
aold = rand(P, 1);

q = calcNormaldotLight(Un, l, M, N);
q(q < 0) = 0;

w = q * c;
Rtx = calcRx(w, Ut);
Mtx = Rtx * Rtx';
Ktx = Rtx .* texvec1;
Ktx = sum(Ktx, 2);

meannl = calcNormaldotLight(XnAvg, l, M, N);


for i=1:20
    %sum(abs(c - cold)) + sum(abs(a - aold))
    
    % matlab says this is faster than inv(Mtx) * Ktx;
    a = Mtx\Ktx;

    % calculate normal weights
    rho = (Ut * a) + TAvg;
    % Rnx = nl .* rho (where nl = n . l or q)
    Rnx = calcRx(rho, q);
    Mnx = Rnx * Rnx';
    
    reconMeanFace = repmat((rho .* meannl), 1, P)';
    
    Knx = Rnx .* (texvec - reconMeanFace);
    Knx = sum(Knx, 2);

    c = Mnx\Knx;

    w = (q * c) + meannl;
    % Rnx = w .* b (bx)
    Rtx = calcRx(w, Ut);
    Mtx = Rtx * Rtx';
    Ktx = Rtx .* texvec1;
    Ktx = sum(Ktx, 2);
end

end

function nl = calcNormaldotLight(nu, l, m, n)
    P = size(nu, 2);   
    F = size(nu, 1) / 3;
    
    l1(:,:,1) = repmat(l(1), m, n);
    l1(:,:,2) = repmat(l(2), m, n);
    l1(:,:,3) = repmat(l(3), m, n);
    nl = zeros(F, P);
    
    for i=1:P
       np = nu(:, i);
       np = ColVectorToImage3(np, m, n);
       nl(:, i) = Image2ColVector(dot(np, l1, 3))';
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