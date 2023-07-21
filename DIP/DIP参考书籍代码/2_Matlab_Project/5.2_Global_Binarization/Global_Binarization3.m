clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/gsls_test1.tif');
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����

subplot(131);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = global_bin_user(IMG1,128);
subplot(132);imshow(IMG2);title('��2��Global��ֵ��-128');

% -------------------------------------------------------------------------
thresh = floor(graythresh(IMG1)*256);
IMG3 = global_bin_user(IMG1, thresh);
subplot(133);imshow(IMG3);title('��3��Global��ֵ��-OTSU');
