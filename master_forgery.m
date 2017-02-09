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

% Strech contrast
gMin = min(gray(:));
gMax = max(gray(:));
gStd = std(gray(:));
gLowerBound = max(gMin, (gMax + gMin) / 2 - gStd * 3);
gUpperbound = min(gMax, (gMax + gMin) / 2 + gStd * 3);
contrastStretched = (gray - gLowerBound) / (gUpperbound - gLowerBound);

threshold = mean(contrastStretched(:));
blackWhite = double(contrastStretched > threshold);
seg = gray .* blackWhite;
colored = image;

[height, width, depth] = size(image);
half = 3;
for x = half + 1:width - half
    for y = half + 1: height - half
        area = contrastStretched(y-half:y+half, x-half:x+half);
        threshold = mean(area(:)) - 0.05;
        seg(y, x) = double(contrastStretched(y, x) > threshold);
        if contrastStretched(y, x) > threshold
            colored(y, x, :) = 1;
        end            
    end
end


figure;
imshow(contrastStretched), title('Contrast Stretched');
%subplot(1,3,2), imshow(blackWhite), title('Global Thresholding');
figure;
imshow(seg), title('Adaptive Thresholding');
figure;
imshow(colored), title('Colored');



