clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/shade_text2_bin.tif');
% IMG1 = imread('../../0_images/gsls_rice.tif');
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����

IMG1 = ~im2bw(IMG1,0.5);
subplot(131);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = bin_compare(IMG1,6);
subplot(132);imshow(IMG2);title('��2����ֵ6�Ƚ�');

% -------------------------------------------------------------------------
IMG3 = bin_compare(IMG2,3);
subplot(133);imshow(IMG3);title('��3����ֵ3�Ƚ�');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Bin2Bin_Data_Gen(IMG1,IMG3);

