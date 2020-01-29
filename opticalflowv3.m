function [position] = opticalflowv3(frame1, frame2, position, IxM, IyM)
    ItM =  image_difference(frame1, frame2);  
    Ix = imcrop(IxM, position);
    Iy = imcrop(IyM, position);
    It = imcrop(ItM, position);
    Ix = Ix(:);
    Iy = Iy(:);
    b = -It(:); 

    A = [Ix Iy]; 
    nu = pinv(A)*b; 
    u=nu(1);
    v=nu(2);
    position = [position(1)+u,position(2)+v,position(3),position(4)];
end

