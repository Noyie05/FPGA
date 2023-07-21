clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Lenna.jpg');    % ¶ÁÈ¡jpgÍ¼Ïñ
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);                             % ¶ÁÈ¡Í¼Ïñ¸ß¶È
w = size(IMG1,2);                             % ¶ÁÈ¡Í¼Ïñ¿í¶È
subplot(131);imshow(IMG1);title('¡¾1¡¿Ô­Í¼');

% -------------------------------------------------------------------------
IMG2 = Sobel_Edge_Detector(IMG1);
subplot(132);imshow(IMG2);title('¡¾2¡¿Sobel±ßÔµ¼ì²â½á¹û');

% -------------------------------------------------------------------------
IMG3 = IMG1 + IMG2;
subplot(133);imshow(IMG3);title('¡¾3¡¿SobelÈñ»¯Í¼Ïñ');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);
