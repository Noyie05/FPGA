clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(221);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = imnoise(IMG1,'salt & pepper',0.01);
subplot(222);imshow(IMG2);title('【2】添加椒盐噪声');

% -------------------------------------------------------------------------
IMG3 = medfilt2(IMG2,[3,3]);
subplot(223);imshow(IMG3);title('【3】Matlab自带中值滤波');

% -------------------------------------------------------------------------
IMG4 = med_filter(IMG2,3);
subplot(224);imshow(IMG4);title('【4】手动编写中值滤波');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG2,IMG4);

