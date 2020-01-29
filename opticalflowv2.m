function [position] = opticalflowv2(frame1, frame2, position, IxM, IyM)
    ItM = double(frame2) - double(frame1);
    
    Ix = imcrop(IxM, position);
    Iy = imcrop(IyM, position);
    It = imcrop(ItM, position);

    J = double(reshape([Ix Iy], [], 2));
    dIt = double(reshape(-It, [], 1));
    A = double(J'*J);
    b = double(J'*dIt);
   
    nu=pinv(A)*b;
    position(1) = double(position(1) + nu(1));
    position(2) = double(position(2) + nu(2));

end

