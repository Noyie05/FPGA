clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����
subplot(221);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = imnoise(IMG1,'gaussian',0.01);
subplot(222);imshow(IMG2);title('��2����Ӹ�˹����');

% -------------------------------------------------------------------------
IMG3 = imfilter(IMG2,fspecial('average',3),'replicate');
% IMG3 = avg_filter(IMG2,3);
subplot(223);imshow(IMG3);title('��3����ֵ�˲�ȥ��');

% -------------------------------------------------------------------------
IMG4 = medfilt2(IMG2,[3,3]);
% IMG4 = med_filter(IMG2,3);
subplot(224);imshow(IMG4);title('��4����ֵ�˲�ȥ��');


