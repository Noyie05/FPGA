clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/shade_text.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/shade_text.tif');
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����

subplot(131);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = region_bin_auto(IMG1,5,1);
subplot(132);imshow(IMG2);title('��2���ֲ�Region��ֵ��1');

% -------------------------------------------------------------------------
IMG3 = region_bin_auto(IMG1,5,0.9);
subplot(133);imshow(IMG3);title('��3���ֲ�Region��ֵ��2');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);


