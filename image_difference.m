function [difference] = image_difference(frame1, frame2)
    difference = (im2double(frame2)-im2double(frame1));
end