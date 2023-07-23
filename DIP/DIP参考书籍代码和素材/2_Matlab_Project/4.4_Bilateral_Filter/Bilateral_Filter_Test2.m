clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1= imread('../../0_images/Lenna.jpg');    % ��ȡjpgͼ��
IMG1= imread('../../0_images/Scart.jpg');    % ��ȡjpgͼ��

IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����


% -------------------------------------------------------------------------
subplot(221);imshow(IMG1);title('��1��ԭͼ');

% figure;
% -------------------------------------------------------------------------
% IMG2 = bilateral_filter_gray(IMG1, 3, 1, 0.1);  
% IMG3 = bilateral_filter_gray(IMG1, 3, 2, 0.1);    
% IMG4 = bilateral_filter_gray(IMG1, 3, 3, 0.1);   
% subplot(222);imshow(IMG2);title('��2��˫���˲�3*3, sigma = [1, 0.1]');
% subplot(223);imshow(IMG3);title('��3��˫���˲�3*3, sigma = [2, 0.1]');
% subplot(224);imshow(IMG4);title('��4��˫���˲�3*3, sigma = [3, 0.1]');


% IMG2 = bilateral_filter_gray(IMG1, 3, 3, 0.1);  
% IMG3 = bilateral_filter_gray(IMG1, 3, 3, 0.3);    
% IMG4 = bilateral_filter_gray(IMG1, 3, 3, 0.8);   
% subplot(222);imshow(IMG2);title('��2��˫���˲�3*3, sigma = [3, 0.1]');
% subplot(223);imshow(IMG3);title('��3��˫���˲�3*3, sigma = [3, 0.3]');
% subplot(224);imshow(IMG4);title('��4��˫���˲�3*3, sigma = [3, 0.8]');


IMG2 = bilateral_filter_gray(IMG1, 3, 3, 0.1);  
IMG3 = bilateral_filter_gray(IMG1, 5, 5, 0.1);    
IMG4 = bilateral_filter_gray(IMG1, 7, 7, 0.1);   
subplot(222);imshow(IMG2);title('��2��˫���˲�3*3, sigma = [3, 0.1]');
subplot(223);imshow(IMG3);title('��3��˫���˲�5*5, sigma = [3, 0.1]');
subplot(224);imshow(IMG4);title('��4��˫���˲�7*7, sigma = [3, 0.1]');