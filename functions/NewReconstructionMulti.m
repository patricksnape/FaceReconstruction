function [ a, c ] = NewReconstructionMulti(imtextures, Un, Ut, TAvg, XnAvg, s)
%NEWRECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

P = size(Un, 2);
[M N C] = size(imtextures);

textures = zeros(M*N, C);
for i=1:C
    textures(:, i) = Image2ColVector(imtextures(:, :, i)) ;
end
a = rand(P, 1);
c = rand(P, 1);
cold = rand(P, 1);
aold = rand(P, 1);

q = calcNormaldotLight(Un, s, M, N, C);
q(q < 0) = 0;

Ktx = zeros(P, 1);
Knx = zeros(P, 1);
Mtx = zeros(P, P);
Mnx = zeros(P, P);

meanq = calcNormaldotLight(XnAvg, s, M, N, C);
meanq(meanq < 0) = 0;

for i=1:C
    w = (q(:, :, i) * c) + meanq(:, :, i);
    Rtx = calcRx(w, Ut);
    Mtx1 = Rtx * Rtx';
    Mtx = Mtx + Mtx1;
    texvec = repmat(textures(:, i) - (w .* TAvg), 1, P)';
    Ktx1 = Rtx .* texvec;
    Ktx1 = sum(Ktx1, 2);
    Ktx = Ktx + Ktx1;
end
Ktx = Ktx/C;
Mtx = Mtx/C;

for i=1:20
    %sum(abs(c - cold)) + sum(abs(a - aold))
    
    % matlab says this is faster than inv(Mtx) * Ktx;
    a = Mtx\Ktx;

    % calculate normal weights
    rho = (Ut * a) + TAvg;
    
    for j=1:C
        Rnx = calcRx(rho, q(:, :, j));
        Mnx1 = Rnx * Rnx'; 
        Mnx = Mnx + Mnx1;
        texvec = repmat(textures(:, j) - (rho .* meanq(:, :, j)), 1, P)';
        Knx1 = Rnx .* texvec;
        Knx1 = sum(Knx1, 2);
        Knx = Knx + Knx1;
    end
    Knx = Knx/C;
    Mnx = Mnx/C;

    c = Mnx\Knx;

    for j=1:C
        w = (q(:, :, j) * c) + meanq(:, :, j);
        Rtx = calcRx(w, Ut);
        Mtx1 = Rtx * Rtx';
        Mtx = Mtx + Mtx1;
        texvec = repmat(textures(:, j) - (w .* TAvg), 1, P)';
        Ktx1 = Rtx .* texvec;
        Ktx1 = sum(Ktx1, 2);
        Ktx = Ktx + Ktx1;
    end
    Ktx = Ktx/C;
    Mtx = Mtx/C;
end

end

function q = calcNormaldotLight(ntilde, s, m, n, c)
    P = size(ntilde, 2);   
    F = size(ntilde, 1) / 3;
    
    svec(:,:,1) = repmat(s(1), m, n);
    svec(:,:,2) = repmat(s(2), m, n);
    svec(:,:,3) = repmat(s(3), m, n);
    q = zeros(F, P, c);
    
    for j=1:c
        svec(:,:,1) = repmat(s(1, j), m, n);
        svec(:,:,2) = repmat(s(2, j), m, n);
        svec(:,:,3) = repmat(s(3, j), m, n);
        
        for i=1:P
           np = ntilde(:, i);
           np = ColVectorToImage3(np, m, n);
           q(:, i, j) = Image2ColVector(dot(np, svec, 3))';
        end
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