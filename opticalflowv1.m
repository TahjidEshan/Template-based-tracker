function [position] = opticalflowv1(frame1, frame2, position, IxM, IyM)
    ItM =  image_difference(frame1, frame2);  
    Ix = imcrop(IxM, position);
    Iy = imcrop(IyM, position);
    It = imcrop(ItM, position);
    a11 = Ix.*Ix;
    a12 = Ix.*Iy;
    a22 = Iy.*Iy;
    b11 = Ix.*It;
    b12 = Iy.*It;
    A11 = sum(a11(:));
    A12 = sum(a12(:));
    A21 = sum(a12(:));
    A22 = sum(a22(:));
    B11 = sum(b11(:));
    B12 = sum(b12(:));
    A = [A11 A12; A21 A22];
    b = -[B11; B12];
   
    nu=pinv(A'*A)*(A'*b);
    u=nu(1);
    v=nu(2);
    position = [position(1)+u,position(2)+v,position(3),position(4)];
end

