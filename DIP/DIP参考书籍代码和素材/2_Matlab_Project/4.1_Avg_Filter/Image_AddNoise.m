clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = imnoise(IMG1,'salt & pepper',0.01);
% IMG2 = uint8(IMG2);
subplot(132);imshow(IMG2);title('【2】添加椒盐噪声');

% -------------------------------------------------------------------------
IMG3 = imnoise(IMG1,'gaussian',0.01);     
% IMG3 = uint8(IMG3);
subplot(133);imshow(IMG3);title('【3】添加高斯噪声');


