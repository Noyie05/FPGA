clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % 读取jpg图像
% IMG1 = imread('../../0_images/shade_text2.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/gsls_test1.tif');
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = global_bin_user(IMG1, 128);
subplot(132);imshow(IMG2);title('【2】全局阈值二值化');

% -------------------------------------------------------------------------
% IMG2 = region_bin_auto(IMG1, 15, 0.9);
% subplot(132);imshow(IMG2);title('【2】局部阈值二值化');

% -------------------------------------------------------------------------
IMG3 = sobel_detector(IMG1,96);
subplot(133);imshow(~IMG3);title('【3】Sobel边缘检测');
