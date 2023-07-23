clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1= imread('../../0_images/Lenna.jpg');    % 读取jpg图像
IMG1= imread('../../0_images/Scart.jpg');    % 读取jpg图像

IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度



imshow(IMG1);title('【1】原图');
% -------------------------------------------------------------------------

figure;
% -------------------------------------------------------------------------
IMG2 = bilateral_filter_gray(IMG1, 3, 1, 0.1);  
IMG3 = bilateral_filter_gray(IMG1, 3, 2, 0.3);    
IMG4 = bilateral_filter_gray(IMG1, 5, 3, 0.8);   
subplot(231);imshow(IMG2);title('【1】浮点双边3*3, sigma = [1, 0.1]');
subplot(232);imshow(IMG3);title('【2】浮点滤波3*3, sigma = [2, 0.3]');
subplot(233);imshow(IMG4);title('【3】浮点滤波5*5, sigma = [3, 0.8]');


% -------------------------------------------------------------------------
IMG6 = bilateral_filter_gray_INT(IMG1, 3, 1, 0.1);  
IMG7 = bilateral_filter_gray_INT(IMG1, 3, 2, 0.3);    
IMG8 = bilateral_filter_gray_INT(IMG1, 5, 3, 0.8);   
subplot(234);imshow(IMG6);title('【4】定点滤波3*3, sigma = [1, 0.1]');
subplot(235);imshow(IMG7);title('【5】定点滤波3*3, sigma = [2, 0.3]');
subplot(236);imshow(IMG8);title('【6】定点滤波5*5, sigma = [3, 0.8]');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
IMG10 = bilateral_filter_gray_INT(IMG1, 3, 3, 0.3);

Gray2Gray_Data_Gen(IMG1,IMG10);

