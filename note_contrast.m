%%%%%%
%
% Contrast Stretching
%
% (C) Yumin Chen
%
% 02/Feb/2017
%
% Introduction
% This is a contrast streching program


clc; % Clear command line
clear all; % Clear all variables
close all; % Close all sub-windows

Image = im2double(imread('Boss.bmp'));
Gray = rgb2gray(Image); 

Gmean = mean(Gray(:))
Gstd = std(Gray(:))
Gmin = max(min(Gray(:)), Gmean - Gstd*3)
Gmax = min(max(Gray(:)), Gmean + Gstd*3)

Output = (Gray - Gmin) / (Gmax - Gmin);

figure;
subplot(2,2,1), imshow(Gray), title('Original');
subplot(2,2,2), imshow(Output), title('Processed');
subplot(2,2,3), imhist(Gray), title('Original Histgram');
subplot(2,2,4), imhist(Output), title('Processed Histgram');

