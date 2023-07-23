clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/gsls_test1.tif');    % 读取jpg图像
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

% -------------------------------------------------------------------------
% IMG2 = rgb2gray(IMG1);    % 转灰度图像 
subplot(221), imshow(IMG1); title('Original Image');
subplot(223), imhist(IMG1); title('Original Hist');

IMG2 = zeros(h,w); 
IMG2 = histeq(IMG1);      % Matlab自带直方图均衡
subplot(222), imshow(IMG2); title('HistEQ Image');
subplot(224), imhist(IMG2); title('HistEQ Hist');