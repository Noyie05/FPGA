clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1= imread('../../0_images/girl.jpg');    % ��ȡjpgͼ��

% -------------------------------------------------------------------------
subplot(121);imshow(IMG1);title('��1��ԭͼ');

IMG2(:,:,1) = bilateral_filter_gray(IMG1(:,:,1), 3, 3, 0.1);  
IMG2(:,:,2) = bilateral_filter_gray(IMG1(:,:,2), 3, 3, 0.1);  
IMG2(:,:,3) = bilateral_filter_gray(IMG1(:,:,3), 3, 3, 0.1);  
subplot(122);imshow(IMG2);title('��2��˫���˲�3*3, sigma = [3, 0.1]');