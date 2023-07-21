clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');  
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����
subplot(131);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = gaussian_filter(IMG1, 3,3);
subplot(132);imshow(IMG2);title('��2��3*3���ڣ�sigma=3��˹�˲�');

% -------------------------------------------------------------------------
IMG3 = gaussian_filter(IMG1, 5,3);
subplot(133);imshow(IMG3);title('��3��5*5���ڣ�sigma=3��˹�˲�');

