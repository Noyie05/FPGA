clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');  
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = gaussian_filter(IMG1, 3,3);
subplot(132);imshow(IMG2);title('【2】3*3窗口，sigma=3高斯滤波');

% -------------------------------------------------------------------------
IMG3 = gaussian_filter(IMG1, 5,3);
subplot(133);imshow(IMG3);title('【3】5*5窗口，sigma=3高斯滤波');

