clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/gsls_test1.tif');    % ��ȡjpgͼ��
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����

% -------------------------------------------------------------------------
% IMG2 = rgb2gray(IMG1);    % ת�Ҷ�ͼ�� 
subplot(221), imshow(IMG1); title('Original Image');
subplot(223), imhist(IMG1); title('Original Hist');

IMG2 = zeros(h,w); 
IMG2 = histeq(IMG1);      % Matlab�Դ�ֱ��ͼ����
subplot(222), imshow(IMG2); title('HistEQ Image');
subplot(224), imhist(IMG2); title('HistEQ Hist');