function [p,roi,error]=affineTracker(frame,p,template)
    iterations = 30;
    p=p(:);

    [x,y]=ndgrid(0:size(template,1)-1,0:size(template,2)-1);

    tempCenter=size(template)/2;

    x=x-tempCenter(1); y=y-tempCenter(2);
    [dx,dy] = customgradient(frame);
    for i=1:iterations
        W_xp = [ 1+p(1) p(3) p(5); p(2) 1+p(4) p(6); 0 0 1];

        I_W = warp(frame,x,y,W_xp);
        I_error= template - I_W;
        if((p(5)>(size(frame,1))-1)||(p(6)>(size(frame,2)-1))||(p(5)<0)||(p(6)<0))
            break; 
        end    

        dxw= warp(dx,x,y,W_xp);
        dyw= warp(dy,x,y,W_xp);

        if(i>iterations) 
            jac_x=[x(:) zeros(size(x(:))) y(:) zeros(size(x(:))) ones(size(x(:))) zeros(size(x(:)))];
            jac_y=[zeros(size(x(:))) x(:) zeros(size(x(:))) y(:) zeros(size(x(:))) ones(size(x(:)))];
            I_steepest=zeros(numel(x),6);
            for j=1:numel(x)
                WP_Jacobian=[jac_x(j,:); jac_y(j,:)];
                Gradient=[dxw(j) dyw(j)];
                I_steepest(j,1:6)=Gradient*WP_Jacobian;
            end
            H=zeros(6,6);
            for j=1:numel(x)
                H=H+ I_steepest(j,:)'*I_steepest(j,:); 
            end
            sum_xy=zeros(6,1);
            for j=1:numel(x)
                sum_xy=sum_xy+I_steepest(j,:)'*I_error(j); 
            end

            del_p=H\sum_xy;
            p = p + del_p;
        else
            I_steepest(:,1)=dxw(:);
            I_steepest(:,2)=dyw(:);
            H=zeros(2,2);
            for j=1:numel(x)
                H=H+I_steepest(j,:)'*I_steepest(j,:); 
            end
            sum_xy=zeros(2,1);
            for j=1:numel(x)
                sum_xy=sum_xy+I_steepest(j,:)'*I_error(j); 
            end
            del_p=H\sum_xy;
            p(5:6) = p(5:6) + del_p;
        end
    end
    roi=I_W;
    error=sum(I_error(:).^2)/numel(I_error);
end
function Iout=warp(Iin,x,y,M)
    Tlocalx =  M(1,1) * x + M(1,2) *y + M(1,3) * 1;
    Tlocaly =  M(2,1) * x + M(2,2) *y + M(2,3) * 1;
    xBas0=floor(Tlocalx);
    yBas0=floor(Tlocaly);
    xBas1=xBas0+1;
    yBas1=yBas0+1;
    xCom=Tlocalx-xBas0;
    yCom=Tlocaly-yBas0;
    perc0=(1-xCom).*(1-yCom);
    perc1=(1-xCom).*yCom;
    perc2=xCom.*(1-yCom);
    perc3=xCom.*yCom;
    check_xBas0=(xBas0<0)|(xBas0>(size(Iin,1)-1));
    check_yBas0=(yBas0<0)|(yBas0>(size(Iin,2)-1));
    xBas0(check_xBas0)=0;
    yBas0(check_yBas0)=0;
    check_xBas1=(xBas1<0)|(xBas1>(size(Iin,1)-1));
    check_yBas1=(yBas1<0)|(yBas1>(size(Iin,2)-1));
    xBas1(check_xBas1)=0;
    yBas1(check_yBas1)=0;
    Iout=zeros([size(x) size(Iin,3)]);
    for i=1:size(Iin,3)
        Iin_one=Iin(:,:,i);
        intensity_xyz0=Iin_one(1+xBas0+yBas0*size(Iin,1));
        intensity_xyz1=Iin_one(1+xBas0+yBas1*size(Iin,1));
        intensity_xyz2=Iin_one(1+xBas1+yBas0*size(Iin,1));
        intensity_xyz3=Iin_one(1+xBas1+yBas1*size(Iin,1));
        Iout_one=intensity_xyz0.*perc0+intensity_xyz1.*perc1+intensity_xyz2.*perc2+intensity_xyz3.*perc3;
        Iout(:,:,i)=reshape(Iout_one, [size(x,1) size(x,2)]);
    end
end