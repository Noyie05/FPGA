clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����
subplot(221);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
g = fspecial('gaussian',[5,5],1);
IMG2 = imfilter(IMG1, g, 'replicate');
subplot(222);imshow(IMG2);title('��2����˹�˲� sigma=1, 5*5');

% -------------------------------------------------------------------------
g = fspecial('gaussian',[5,5],3);
IMG3 = imfilter(IMG1, g, 'replicate');
subplot(223);imshow(IMG3);title('��3����˹�˲� sigma=3, 5*5');


% -------------------------------------------------------------------------
g = fspecial('gaussian',[11,11],3);
IMG4 = imfilter(IMG1, g, 'replicate');
subplot(224);imshow(IMG4);title('��4����˹�˲� sigma=3, 11*11');


