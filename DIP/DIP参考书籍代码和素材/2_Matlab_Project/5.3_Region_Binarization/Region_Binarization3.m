clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/shade_text2.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/shade_text.tif');
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = region_bin_auto(IMG1,5,0.9);
subplot(132);imshow(IMG2);title('【2】5*5窗口局部阈值');

% -------------------------------------------------------------------------
IMG3 = region_bin_auto(IMG1,15,0.9);
subplot(133);imshow(IMG3);title('【3】15*15窗口局部阈值');

% imwrite(IMG3,'shade_text2_bin.tif');  %保存重建后的BMP
