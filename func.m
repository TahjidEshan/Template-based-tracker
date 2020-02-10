function [] = func()
    load('arm.mat');
    first_frame = armimgs{1};
    figure;
    imshow(first_frame);
    roi = drawrectangle('Color',[0 1 0]);
    wait(roi);
%     position1 = roi.Position;
    position2 = roi.Position;
%     position3 = roi.Position;
    first_frame_gray = im2double(rgb2gray(first_frame));
    [IxM, IyM] = gradient(first_frame_gray);
    for k = 2:numel(armimgs)
        current_frame = im2double(rgb2gray(armimgs{k}));
        for i=1:2
%              position1 = opticalflowv1(first_frame_gray, current_frame, position1, IxM, IyM);
             position2 = opticalflowv2(first_frame_gray, current_frame, position2, IxM, IyM);
%              position3 = opticalflowv3(first_frame_gray, current_frame, position3, IxM, IyM);
        end
        imshow(current_frame);
        hold on;
%         rectangle('Position', position1,'LineWidth',2, 'EdgeColor',[0 1 0]);
        rectangle('Position', position2,'LineWidth',2, 'EdgeColor',[0 0 1]);
%         rectangle('Position', position3,'LineWidth',2, 'EdgeColor',[1 0 0]);
        drawnow;
        hold off;
    end
    close all;
end