clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Lenna.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);                             % ��ȡͼ��߶�
w = size(IMG1,2);                             % ��ȡͼ����
subplot(131);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = Sobel_Edge_Detector(IMG1);
subplot(132);imshow(IMG2);title('��2��Sobel��Ե�����');

% -------------------------------------------------------------------------
IMG3 = IMG1 + IMG2;
subplot(133);imshow(IMG3);title('��3��Sobel��ͼ��');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);
