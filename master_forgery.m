%-------------------------------------------------------------------------
% ========================
% Master Forgery
% ========================
%
% Copyright (C): Yumin Chen  D16123341
%
% 04/Feb/2017
%
% Introduction
% ------------------------
% This is an assignment from Image Processing module. The purpose of this
% program is to clean and extract a signature from a natural image. To
% fully process the image, this program might take up to a few minutes.
% -------------------------------------------------------------------------

function master_forgery
% This is a hack that allows function definition in a script, this is used
% so the code could be used for different images -- Boss.bmp and Trump.jpg

% Clear and clean enviroment
clc;        % Clear command line
clear all;  % Clear all variables
close all;  % Close all sub-windows

fprintf('This program might take up to a few minutes to run, please wait.')

% Process the Boss.bmp image
bossResult = processImage('Boss.bmp');
figure, imshow(bossResult), title('The Boss.bmp Image');

% Process the Trump.jpg image
TrumpResult = processImage('Trump.jpg');
figure, imshow(TrumpResult), title('The Trump.jpg Image');

% If you have other image to try, put it here...

end

function output = processImage(fileName)
% Process the natural image and extract the signature and return it

% Read image
image = im2double(imread(fileName));
grayImage = rgb2gray(image); 

% Stretch contrast
contrastStretched = stretchContrast(image, grayImage, 6);

% Apply the Gaussian filter
gauss = [1 4 1;
         4 7 4;
         1 4 1]/27; % The Gaussian filter weighted sum matrix
filteredImage = filter(contrastStretched, gauss);

% Thresholding
thresholdedImage = thresholding(contrastStretched, grayImage, filteredImage);

% Cropping
croppedImage = cropping(thresholdedImage);

% Stretch contrast again to get a fuller color
output = stretchContrast(croppedImage, rgb2gray(croppedImage), 4);

end


% ------------------------
% Stretch contrast
% ------------------------
function output = stretchContrast(image, grayImage, sigma)
% Stretch the contrast of an image to a width six standard deviations using
% the statistics three-sigma rule.
gMin = min(grayImage(:));
gMax = max(grayImage(:));
gStd = std(grayImage(:));
% Apply statistics three-sigma rule to bound to the majority of the data
gLowerBound = max(gMin, (gMax + gMin) / 2 - gStd * sigma / 2);
gUpperbound = min(gMax, (gMax + gMin) / 2 + gStd * sigma / 2);
output = (image - gLowerBound) / (gUpperbound - gLowerBound);
end


% ------------------------
% Filter
% ------------------------
function output = filter(image, f)
[height, width, ~] = size(image);
output = image;
for x = 2:width - 1
    for y = 2: height - 1
        for i = 1:3
            % Dot multiply the "cookie" area by the filter matrix
            filteredArea = image(y-1:y+1, x-1:x+1, i) .* f;
            % Apply the sum to current position
            output(y, x, i) = sum(filteredArea(:));
        end
    end
end
end

% ------------------------
% Thresholding
% ------------------------
function output = thresholding(image, grayImage, adaptiveSource)
[height, width, ~] = size(image);
globalThreshold = mean(image(:)) + std(image(:));
binaryImage = grayImage < globalThreshold;
% Adaptive thresholding
output = image;
half = 3;
% Loop through the image to apply threshold to each pixel
for x = half + 1:width - half
    for y = half + 1: height - half
        % Global thresholding
        if ~binaryImage(y, x)
            % White out the pixel and skip to the next pixel
            output(y, x, :) = 1;
            continue
        end
        area = adaptiveSource(y-half:y+half, x-half:x+half, :);
        % Adaptive thresholding
        threshold = mean(area(:)) - 7/256;
        if mean(adaptiveSource(y, x, :)) > threshold
            % White out the pixel if larger than threshold
            output(y, x, :) = 1;
        end
    end
end
end

% ------------------------
% Cropping
% ------------------------
function output = cropping(image)
[height, width, ~] = size(image);
half = 3;
% Convert to grayImage and reverse to a black and white binary image
binaryImage = rgb2gray(image(half + 1: height - half, ...
    half + 1:width - half, :)) ~= 1;
% Find the non-zero positions
[rows, columns] = find(binaryImage);
% Analyze data using statistics
rowsStd = std(rows);
rowsMedian = median(rows);
colsStd = std(columns);
colsMedian = median(columns);
% Using statistics three-sigma rule to get 99.73% of data
sTop = max(round(rowsMedian - rowsStd * 3), 1);
sBottom = min(round(rowsMedian + rowsStd * 3), height);
sLeft = max(round(colsMedian - colsStd * 3), 1);
sRight = min(round(colsMedian + colsStd * 3), width);
% Return the final result
output = image(sTop:sBottom, sLeft:sRight, :);
end
