function [] = pyramid(levels, scale)
    load('arm.mat');
    first_frame = armimgs{1};
    figure;
    imshow(first_frame);
    roi = drawrectangle('Color',[0 1 0]);
    wait(roi);
    position = roi.Position;
    template = imcrop(rgb2gray(first_frame), position);
    templatepyramid = makepyramid(template, levels, scale);
    firstframepyramid = makepyramid(first_frame, levels, scale);
    for k = 2:numel(armimgs)
        current_frame = im2double(rgb2gray(armimgs{k}));
        frame_pyramid = makepyramid(current_frame, levels,scale);
        oldposition = position;
        for level = 1:levels
            first_frame_level = firstframepyramid{level};
            current_template = templatepyramid{level};
            current_frame_pyramid = frame_pyramid{level};
            newW = size(current_template,2)-1;
            newH = size(current_template,1)-1;
            newX = oldposition(1)*(newW/oldposition(3));
            newY = oldposition(2)*(newH/oldposition(4));
            newposition = [newX, newY, newW, newH];
            [IxM, IyM] = gradient(first_frame_level);
            for i=1:1
                newposition = opticalflowv2(first_frame_level, current_frame_pyramid, newposition, IxM, IyM);
            end
            oldposition = newposition;
        end
        position = oldposition;
        imshow(armimgs{k});
        hold on;
        rectangle('Position', position,'LineWidth',2, 'EdgeColor',[0 1 0]);
        drawnow;
        hold off;
    end
    close all;
end