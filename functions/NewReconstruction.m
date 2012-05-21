function [ a, c ] = NewReconstruction(texture, Un, Ut, l)
%NEWRECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

P = size(Un, 2);
[M N] = size(texture);

texture = Image2ColVector(texture);
texvec = repmat(texture, 1, P)';
a = rand(P, 1);
c = rand(P, 1);
cold = rand(P, 1);
aold = rand(P, 1);

nl = calcnl(Un, l, M, N);
nl(nl < 0) = 0;

w = nl * c;
Rtx = calcRx(w, Ut);
Mtx = Rtx * Rtx';
Ktx = Rtx .* texvec;
Ktx = sum(Ktx, 2);

while (sum(abs(c - cold)) + sum(abs(a - aold))) > 1
    sum(abs(c - cold)) + sum(abs(a - aold))
    
    aold = a;
    % matlab says this is faster than inv(Mtx) * Ktx;
    a = Mtx\Ktx;

    % calculate normal weights
    rho = Ut * a;
    Rnx = calcRx(rho, nl);
    Mnx = Rnx * Rnx';
    Knx = Rnx .* texvec;
    Knx = sum(Knx, 2);

    cold = c;
    c = Mnx\Knx;
    
    % calculate texture weights
    w = nl * c;
    Rtx = calcRx(w, Ut);
    Mtx = Rtx * Rtx';
    Ktx = Rtx .* texvec;
    Ktx = sum(Ktx, 2);
end

end

function nl = calcnl(nu, l, m, n)
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