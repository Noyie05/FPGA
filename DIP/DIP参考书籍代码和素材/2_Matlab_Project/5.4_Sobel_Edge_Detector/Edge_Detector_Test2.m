clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Lenna.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/gsls_rice.tif');
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����

subplot(131);imshow(IMG1);title('��1��ԭͼ');


% -------------------------------------------------------------------------
IMG2 = sobel_detector(IMG1,64);
subplot(132);imshow(~IMG2);title('��2��Sobel��⣺��ֵ=64');

% -------------------------------------------------------------------------
IMG3 = sobel_detector(IMG1,96);
subplot(133);imshow(~IMG3);title('��3��Sobel��⣺��ֵ=96');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Bin_Data_Gen(IMG1,IMG3);
