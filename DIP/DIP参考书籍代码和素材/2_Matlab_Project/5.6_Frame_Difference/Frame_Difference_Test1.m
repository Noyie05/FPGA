clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
frame1 = imread('../../0_images/nezha1.jpg');    % ��ȡjpgͼ��
frame2 = imread('../../0_images/nezha2.jpg');    % ��ȡjpgͼ��

subplot(221);imshow(frame1);title('ǰһ֡');
subplot(222);imshow(frame2);title('��ǰ֡');

%˫֡���
frame1 = rgb2gray(frame1);
frame2 = rgb2gray(frame2);
frame_diff = abs(frame1-frame2);
subplot(223);imshow(frame_diff);title('��ֵ֡');

%��ֵ����
frame_2dim = global_bin_user(frame_diff, 32);
subplot(224);imshow(frame_2dim);;title('��ֵ32����');