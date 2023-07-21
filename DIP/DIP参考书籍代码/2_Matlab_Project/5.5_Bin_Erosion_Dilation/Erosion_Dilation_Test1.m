clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/shade_text2_bin.tif');
% IMG1 = imread('../../0_images/gsls_rice.tif');
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

IMG1 = ~im2bw(IMG1,0.5);
subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = bin_erosion(IMG1);
subplot(132);imshow(IMG2);title('【2】3*3腐蚀运算');

% -------------------------------------------------------------------------
IMG3 = bin_dilation(IMG2);
subplot(133);imshow(IMG3);title('【3】3*3膨胀运算');

