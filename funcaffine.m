function [] = funcaffine()
    load('arm.mat');
    first_frame = armimgs{1};
    figure;
    imshow(first_frame);
    roi = drawrectangle('Color',[0 0 1]);
    wait(roi);
    rect = roi.Position;
    position1 = [rect(2) rect(1)];
    position2 = [rect(2)+rect(4) rect(1)];
    position3 = [rect(2) rect(1)+rect(3)];
    position4 = [rect(2)+rect(4) rect(1)+rect(3)];

    p1 = [0 0 0 0 position1(1) position1(2)];
    p2 = [0 0 0 0 position2(1) position2(2)];
    p3 = [0 0 0 0 position3(1) position3(2)];
    p4 = [0 0 0 0 position4(1) position4(2)];
    rect1 = [(p1(6) - rect(4)/2) (p1(5) - rect(3)/2) rect(3) rect(4)];
    rect2 = [(p2(6) - rect(4)/2) (p2(5) - rect(3)/2) rect(3) rect(4)];
    rect3 = [(p3(6) - rect(4)/2) (p3(5) - rect(3)/2) rect(3) rect(4)];
    rect4 = [(p4(6) - rect(4)/2) (p4(5) - rect(3)/2) rect(3) rect(4)];
    template1 = imcrop(im2double(rgb2gray(first_frame)), rect1);
    template2 = imcrop(im2double(rgb2gray(first_frame)), rect2);
    template3 = imcrop(im2double(rgb2gray(first_frame)), rect3);
    template4 = imcrop(im2double(rgb2gray(first_frame)), rect4);
    for k = 2:numel(armimgs)
        current_frame = im2double(rgb2gray(armimgs{k}));
        p1 = affineTracker(current_frame, p1, template1);
        p2 = affineTracker(current_frame, p2, template2);
        p3 = affineTracker(current_frame, p3, template3);
        p4 = affineTracker(current_frame, p4, template4);

        imshow(armimgs{k});
        hold on;
        drawLine([p1(6) p1(5)], [p2(6) p2(5)]);
        drawLine([p1(6) p1(5)], [p3(6) p3(5)]);
        drawLine([p3(6) p3(5)], [p4(6) p4(5)]);
        drawLine([p4(6) p4(5)], [p2(6) p2(5)]);
        drawnow;
        hold off;
    end
    close all;
end

function [] = drawLine(p1, p2)
    theta = atan2( p2(2) - p1(2), p2(1) - p1(1));
    r = sqrt( (p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
    line = 0:0.01: r;
    x = p1(1) + line*cos(theta);
    y = p1(2) + line*sin(theta);
    plot(x, y,'color', [0 0 1], 'LineWidth',2);
end