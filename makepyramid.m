function [pyramid] = makepyramid(image, levels, scale)
    pyramid = cell(1, levels);
    pyramid{levels} = im2double(image);
    for i = levels-1:-1:1
        pyramid{i} = imresize(im2double(imgaussfilt(pyramid{i+1},4)), scale);
    end
end