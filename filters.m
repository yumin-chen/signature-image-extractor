%-------------------------------------------------------------------------
% ========================
% Filters
% ========================
%
% Copyright (C): Yumin Chen
%
% 09/Feb/2017
%
% -------------------------------------------------------------------------

% Clear and clean enviroment
clc;        % Clear command line
clear all;  % Clear all variables
close all;  % Close all sub-windows

% Read image
image = im2double(imread('Trump.jpg'));
gray = rgb2gray(image); 


[height, width, depth] = size(image);

gauss = [1 4 1;
         4 7 4;
         1 4 1]/27;

output = image;

for x = 2:width - 1
    for y = 2: height - 1
        for i = 1:3
            area = image(y-1:y+1, x-1:x+1, i);
            filteredArea = area .* gauss;
            output(y-1:y+1, x-1:x+1, i) = sum(filteredArea(:));
        end
    end
end


figure;
subplot(1,2,1), imshow(image), title('Original');
subplot(1,2,2), imshow(output), title('Filtered');



