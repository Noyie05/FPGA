clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1 = imread('../../0_images/Scart.jpg');    % 读取jpg图像
% IMG1 = rgb2gray(IMG1);
IMG1 = imread('../../0_images/gsls_test1.tif');
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

subplot(121);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = global_bin_user(IMG1,128);
subplot(122);imshow(IMG2);title('【2】Global二值化-128');

