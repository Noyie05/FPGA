clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(331);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = imnoise(IMG1,'salt & pepper',0.01);
subplot(332);imshow(IMG2);title('【2】添加椒盐噪声');


% -------------------------------------------------------------------------
IMG3 = imnoise(IMG1,'gaussian');%,0,10^2/(h*w));   %均值=0，方差=10的高斯噪声   
subplot(333);imshow(IMG3);title('【3】添加高斯噪声');

% -------------------------------------------------------------------------
IMG4 = imfilter(IMG2,fspecial('average',3),'replicate');
subplot(334);imshow(IMG4);title('【4】椒盐噪声均值滤波');

% -------------------------------------------------------------------------
IMG5 = medfilt2(IMG2,[3,3]);
subplot(335);imshow(IMG5);title('【5】椒盐噪声中值滤波');

% -------------------------------------------------------------------------
g = fspecial('gaussian',[3,3],1);
IMG6 = imfilter(IMG2, g, 'replicate');
subplot(336);imshow(IMG6);title('【6】椒盐噪声高斯滤波');

% -------------------------------------------------------------------------
IMG7 = imfilter(IMG3,fspecial('average',3),'replicate');
subplot(337);imshow(IMG7);title('【7】高斯噪声均值滤波');

% -------------------------------------------------------------------------
IMG8 = medfilt2(IMG3,[7,7]);
subplot(338);imshow(IMG8);title('【8】高斯噪声中值滤波');

% -------------------------------------------------------------------------
g = fspecial('gaussian',[7,7],3);
IMG9 = imfilter(IMG3, g, 'replicate');
subplot(339);imshow(IMG9);title('【9】高斯噪声高斯滤波');

