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
IMG2 = imresize(IMG1,[h2 w2],'bilinear');

figure
imshowpair(IMG1,IMG2,'montage');
title('��ͼ��ԭͼ(640*480)   ��ͼ��Matlab�Դ�˫���Բ�ֵ�Ŵ���(1024*768)');

% -------------------------------------------------------------------------
IMG3 = Bilinear_Interpolation(IMG1,h1,w1,h2,w2);

figure
imshowpair(IMG1,IMG3,'montage');
title('��ͼ��ԭͼ(640*480)   ��ͼ���ֶ���д˫���Բ�ֵ�Ŵ��������㣩(1024*768)');

% -------------------------------------------------------------------------
IMG4 = Bilinear_Interpolation_Int(IMG1,h1,w1,h2,w2);

figure
imshowpair(IMG1,IMG3,'montage');
title('��ͼ��ԭͼ(640*480)   ��ͼ���ֶ���д˫���Բ�ֵ�Ŵ��������㣩(1024*768)');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);
