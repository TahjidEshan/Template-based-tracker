

function [Ix,Iy]=customgradient(I)
% disp("here");
sigma = 1.5;
% Make derivatives kernels
[x,y]=ndgrid(floor(-3*sigma):ceil(3*sigma),floor(-3*sigma):ceil(3*sigma));
DGaussx=-(x./(2*pi*sigma^4)).*exp(-(x.^2+y.^2)/(2*sigma^2));
DGaussy=-(y./(2*pi*sigma^4)).*exp(-(x.^2+y.^2)/(2*sigma^2));
% Filter the images to get the derivatives
Ix = imfilter(I,DGaussx,'conv');
Iy = imfilter(I,DGaussy,'conv');
end

