clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����
subplot(221);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = imnoise(IMG1,'salt & pepper',0.01);
subplot(222);imshow(IMG2);title('��2����ӽ�������');

% -------------------------------------------------------------------------
IMG3 = imfilter(IMG2,fspecial('average',3),'replicate');
subplot(223);imshow(IMG3);title('��3��Matlab�Դ���ֵ�˲�');

% -------------------------------------------------------------------------
IMG4 = avg_filter(IMG2,3);
subplot(224);imshow(IMG4);title('��4���ֶ���д��ֵ�˲�');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG2,IMG4);
