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
% Adaptive thresholding
% ------------------------
adaptiveThresholding = image;
half = 3;
% Loop through the image to apply threshold to each pixel
for x = half + 1:width - half
    for y = half + 1: height - half
        area = contrastStretched(y-half:y+half, x-half:x+half, :);
        threshold = mean(area(:)) - 0.05;
        if mean(contrastStretched(y, x, :)) > threshold
            % Wipe out the pixel if larger than threshold
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
% Find the non-zero areas
[rows, columns] = find(binaryImage);
top = min(rows);
bottom = max(rows);
left = min(columns);
right = max(columns);
croppedImage = adaptiveThresholding(top:bottom, left:right, :);
% Show cropped image
figure, imshow(croppedImage), title('Cropped image');


