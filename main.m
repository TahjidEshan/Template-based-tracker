if (exist('cam') == 0)
    cam = webcam;
else
    clear('cam');
    cam = webcam;
end
fig = figure;
img = snapshot(cam);
imshow(img);
r1 = drawrectangle('Color',[0 1 0]);
wait(r1);

position = r1.Position;
x = position(1);
y = position(2);
w = position(3);
h = position(4);
template = imcrop(img, position);
while true
    img = snapshot(cam);

    for i = 1:5
        nextframe = imcrop(img, position);
        [u,v] =   opticalflow(template, nextframe, 4);
        position = [x+u(2,2),y+v(2,2),w,h]; 

    end
    imshow(img);
    hold on;
    rectangle('Position', position,'LineWidth',2, 'EdgeColor',[0 1 0]);
%     pause(1);
end
clear('cam');