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

output = gray;

for x = 2:width - 1
    for y = 2: height - 1
        area = gray(y-1:y+1, x-1:x+1);
        filteredArea = area .* gauss;
        output(y-1:y+1, x-1:x+1) = sum(filteredArea(:));
    end
end


figure;
subplot(1,2,1), imshow(gray), title('Gray');
subplot(1,2,2), imshow(output), title('Filtered');



