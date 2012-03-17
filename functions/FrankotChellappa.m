function hh=Integ_FrankotChellappa(dzdx,dzdy,pz)
% function z = fcint(dzdx,dzdy,pz)
% Z = fcint(Px,Py,Pz)
%   Integrate surface nmormals, Px, Py, Pz, using the Frankot-Chellappa
%   surface integration algorithm to recover height, Z

if ~all(size(dzdx) == size(dzdy))
    error('Gradient matrices must match');
end

% scale normal vectors to derivative format
dzdx = -dzdx./(pz+10^(-9));
dzdy = dzdy./(pz+10^(-9));

[rows,cols] = size(dzdx);


[wx, wy] = meshgrid(-pi/2:pi/(cols-1):pi/2,-pi/2:pi/(rows-1):pi/2);

% Quadrant shift to put zero frequency at the appropriate edge
wx = ifftshift(wx); wy = ifftshift(wy);

DZDX = fft2(dzdx);   % Fourier transforms of gradients
DZDY = fft2(dzdy);

% Integrate in the frequency domain by phase shifting by pi/2 and
% weighting the Fourier coefficients by their frequencies in x and y and
% then dividing by the squared frequency.  eps is added to the
% denominator to avoid division by 0.
j = sqrt(-1);

dd = wx.^2 + wy.^2;
Z = (-j*wx.*DZDX -j*wy.*DZDY)./(wx.^2 + wy.^2 + eps); 


z = real(ifft2(Z));  % Reconstruction
z = z - min(z(:));
hh = z/2;


