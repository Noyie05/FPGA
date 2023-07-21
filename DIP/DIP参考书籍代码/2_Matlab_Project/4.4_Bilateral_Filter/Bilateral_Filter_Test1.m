clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1= imread('../../0_images/Lenna.jpg');    % ��ȡjpgͼ��
IMG1= imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��

IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����


imshow(IMG1);title('��1��ԭͼ');
% -------------------------------------------------------------------------

figure;
% -------------------------------------------------------------------------
IMG2 = imfilter(IMG1, fspecial('gaussian',[3,3],1), 'replicate');
IMG3 = imfilter(IMG1, fspecial('gaussian',[3,3],2), 'replicate');
IMG4 = imfilter(IMG1, fspecial('gaussian',[5,5],3), 'replicate');
subplot(231);imshow(IMG2);title('��1����˹�˲�3*3, sigma = 1');
subplot(232);imshow(IMG3);title('��2����˹�˲�3*3, sigma = 2');
subplot(233);imshow(IMG4);title('��3����˹�˲�5*5, sigma = 3');


% -------------------------------------------------------------------------
IMG6 = bilateral_filter_gray(IMG1, 3, 1, 0.1);  
IMG7 = bilateral_filter_gray(IMG1, 3, 2, 0.3);    
IMG8 = bilateral_filter_gray(IMG1, 5, 3, 0.8);   
subplot(234);imshow(IMG6);title('��4��˫���˲�3*3, sigma = [1, 0.1]');
subplot(235);imshow(IMG7);title('��5��˫���˲�3*3, sigma = [2, 0.3]');
subplot(236);imshow(IMG8);title('��6��˫���˲�5*5, sigma = [3, 0.8]');




