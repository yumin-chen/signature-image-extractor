%-------------------------------------------------------------------------
% ========================
% Thresholding
% ========================
%
% Copyright (C): Yumin Chen
%
% 02/Feb/2017
%
% Introduction
% ------------------------
% This program aims to threshold an image.
% -------------------------------------------------------------------------


clc; % Clear command line
clear all; % Clear all variables
close all; % Close all sub-windows

Image = im2double(imread('Boss.bmp'));
Gray = rgb2gray(Image); 

Gmean = mean(Gray(:));
Gstd = std(Gray(:));
Gmin = max(min(Gray(:)), Gmean - Gstd*3);
Gmax = min(max(Gray(:)), Gmean + Gstd*3);

Output = (Image - Gmin) / (Gmax - Gmin);
threshold = mean(Output(:));
BlackWhite = double(Gray > threshold);
Seg = Gray .* BlackWhite;

figure;
subplot(1,3,1), imshow(Gray), title('Contrast Stretched');
subplot(1,3,2), imshow(BlackWhite), title('Black & White');
subplot(1,3,3), imshow(Seg), title('Colored');



