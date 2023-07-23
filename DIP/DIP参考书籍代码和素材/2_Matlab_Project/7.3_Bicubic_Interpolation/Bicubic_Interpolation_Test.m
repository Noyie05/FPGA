clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1= imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
h1 = size(IMG1,1);          % ��ȡͼ��߶�
w1 = size(IMG1,2);          % ��ȡͼ����
h2 = 768;                   % �Ŵ��ͼ��߶�
w2 = 1024;                  % �Ŵ��ͼ����

% -------------------------------------------------------------------------
IMG2 = imresize(IMG1,[h2 w2],'bicubic');

figure
imshowpair(IMG1,IMG2,'montage');
title('��ͼ��ԭͼ(640*480)   ��ͼ��Matlab�Դ�˫���β�ֵ�Ŵ���(1024*768)');

% -------------------------------------------------------------------------
IMG3 = Bicubic_Interpolation(IMG1,h1,w1,h2,w2);

figure
imshowpair(IMG1,IMG3,'montage');
title('��ͼ��ԭͼ(640*480)   ��ͼ���ֶ���д˫���β�ֵ�Ŵ���(1024*768)');

