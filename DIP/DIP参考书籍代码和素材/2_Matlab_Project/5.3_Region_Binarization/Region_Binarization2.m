clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/shade_text.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/shade_text.tif');
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = region_bin_auto(IMG1,5,1);
subplot(132);imshow(IMG2);title('【2】局部Region二值化1');

% -------------------------------------------------------------------------
IMG3 = region_bin_auto(IMG1,5,0.9);
subplot(133);imshow(IMG3);title('【3】局部Region二值化2');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);


