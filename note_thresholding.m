%%%%%%
%
% Contrast Stretching
%
% (C) Yumin Chen
%
% 02/Feb/2017
%
% Introduction
% This is a contrast streching algorithm


clc; % Clear command line
clear all; % Clear all variables
close all; % Close all sub-windows

Image = im2double(imread('Boss.bmp'));
Gray = rgb2gray(Image); 

Gmin = min(Gray(:));
Gmax = max(Gray(:));

Output = (Image - Gmin) / (Gmax - Gmin);
threshold = mean(Output(:)) - std(Output(:))
BlackWhite = double(Gray > threshold);
Seg = Gray .* BlackWhite;

figure;
subplot(1,3,1), imshow(Gray), title('Contrast Stretched');
subplot(1,3,2), imshow(BlackWhite), title('Black & White');
subplot(1,3,3), imshow(Seg), title('Colored');



