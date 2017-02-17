%-------------------------------------------------------------------------
% ========================
% Master Forgery
% ========================
%
% Copyright (C): Yumin Chen
%
% 04/Feb/2017
%
% Introduction
% ------------------------
% This is an assignment from Image Processing module. The purpose of this
% program is to clean and extract a signature from a natural image.
% -------------------------------------------------------------------------

% Clear and clean enviroment
clc;        % Clear command line
clear all;  % Clear all variables
close all;  % Close all sub-windows

% Read image
image = im2double(imread('Boss.bmp'));
gray = rgb2gray(image); 
[height, width, depth] = size(image);


% ------------------------
% Stretch contrast
% ------------------------
gMin = min(gray(:));
gMax = max(gray(:));
gStd = std(gray(:));
% Apply statistics three-sigma rule to bound to 99.73% of data
gLowerBound = max(gMin, (gMax + gMin) / 2 - gStd * 3);
gUpperbound = min(gMax, (gMax + gMin) / 2 + gStd * 3);
contrastStretched = (image - gLowerBound) / (gUpperbound - gLowerBound);


% ------------------------
% Filter
% ------------------------
gauss = [1 4 1;
         4 7 4;
         1 4 1]/27; % The Gaussian filter weighted sum matrix

filteredImage = contrastStretched;
for x = 2:width - 1
    for y = 2: height - 1
        for i = 1:3
            % Dot multiply the "cookie" area by the filter matrix
            filteredArea = contrastStretched(y-1:y+1, x-1:x+1, i) .* gauss;
            % Apply the sum to current position
            filteredImage(y, x, i) = sum(filteredArea(:));
        end
    end
end


% ------------------------
% Thresholding
% ------------------------
globalThreshold = mean(contrastStretched(:));
binaryImage = gray < globalThreshold;
% Adaptive thresholding
adaptiveThresholding = image;
half = 3;
% Loop through the image to apply threshold to each pixel
for x = half + 1:width - half
    for y = half + 1: height - half
        % Global thresholding
        if ~binaryImage(y, x)
            % White out the pixel and skip to the next pixel
            adaptiveThresholding(y, x, :) = 1;
            continue
        end
        area = filteredImage(y-half:y+half, x-half:x+half, :);
        % Adaptive thresholding
        threshold = mean(area(:)) - 7/256;
        if mean(filteredImage(y, x, :)) > threshold
            % White out the pixel if larger than threshold
            adaptiveThresholding(y, x, :) = 1;
        end            
    end
end
% Show adaptive thresholding reconstructed image
figure, imshow(adaptiveThresholding), title('Adaptive Thresholding');


% ------------------------
% Cropping
% ------------------------
% Convert to gray and reverse to a black and white binary image
binaryImage = rgb2gray(adaptiveThresholding(half + 1: height - half, ...
    half + 1:width - half, :)) ~= 1;
% Find the non-zero positions
[rows, columns] = find(binaryImage);
% Analyze data using statistics
top = min(rows) + half + 1;
bottom = max(rows) + half + 1;
left = min(columns) + half + 1;
right = max(columns) + half + 1;
% Using statistics three-sigma rule to get 99.73% of data
croppedImage = adaptiveThresholding(top:bottom, left:right, :);
% Show cropped image
figure, imshow(croppedImage), title('Cropped image');


