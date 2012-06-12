function c = NewReconstructionTex(I, texture, Un, XnAvg, s)
%NEWRECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

    P = size(Un, 2);
    [M N] = size(I);

    I = Image2ColVector(I);
    texture = Image2ColVector(texture);

    q = calcNormaldotLight(Un, s, M, N);
    meanq = calcNormaldotLight(XnAvg, s, M, N);

    % calculate normal weights
    Rnx = calcRx(texture, q);
    Mnx = Rnx * Rnx'; 
    texvec = repmat(I - (texture .* meanq), 1, P)';
    Knx = Rnx .* texvec;
    Knx = sum(Knx, 2);

    c = Mnx\Knx;
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