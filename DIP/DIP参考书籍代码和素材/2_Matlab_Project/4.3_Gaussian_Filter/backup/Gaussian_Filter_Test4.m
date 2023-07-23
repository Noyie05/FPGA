clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');  
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(241);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = gaussian_filter(IMG1, 3,1);
subplot(242);imshow(IMG2);title('【2】3*3窗口，sigma=1高斯滤波');

% -------------------------------------------------------------------------
IMG2 = gaussian_filter(IMG1, 3,2);
subplot(243);imshow(IMG2);title('【2】3*3窗口，sigma=2高斯滤波');

% -------------------------------------------------------------------------
IMG2 = gaussian_filter(IMG1, 5,3);
subplot(244);imshow(IMG2);title('【3】3*3窗口，sigma=3高斯滤波');


subplot(245);imshow(IMG1);title('【1】原图');
% -------------------------------------------------------------------------
g = fspecial('gaussian',[3,3],1);
IMG2 = imfilter(IMG1, g, 'replicate');
subplot(246);imshow(IMG2);title('【2】高斯滤波');

g = fspecial('gaussian',[3,3],2);
IMG2 = imfilter(IMG1, g, 'replicate');
subplot(247);imshow(IMG2);title('【2】高斯滤波');


g = fspecial('gaussian',[5,5],3);
IMG2 = imfilter(IMG1, g, 'replicate');
subplot(248);imshow(IMG2);title('【2】高斯滤波');

