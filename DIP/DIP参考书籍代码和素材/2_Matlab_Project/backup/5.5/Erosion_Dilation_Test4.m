clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/shade_text2_bin.tif');
% IMG1 = imread('../../0_images/gsls_rice.tif');

h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

IMG1 = ~im2bw(IMG1,0.5);
subplot(121);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
IMG2 = bin_compare2(IMG1,3,6);
subplot(122);imshow(IMG2);title('【2】阈值下限2，上限8比较');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Bin2Bin_Data_Gen(IMG1,IMG2);

