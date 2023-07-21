clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Lenna.jpg');    % ¶ÁÈ¡jpgÍ¼Ïñ
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/gsls_rice.tif');
h = size(IMG1,1);         % ¶ÁÈ¡Í¼Ïñ¸ß¶È
w = size(IMG1,2);         % ¶ÁÈ¡Í¼Ïñ¿í¶È

subplot(131);imshow(IMG1);title('¡¾1¡¿Ô­Í¼');


% -------------------------------------------------------------------------
IMG2 = sobel_detector(IMG1,64);
subplot(132);imshow(~IMG2);title('¡¾2¡¿Sobel¼ì²â£ºãÐÖµ=64');

% -------------------------------------------------------------------------
IMG3 = sobel_detector(IMG1,96);
subplot(133);imshow(~IMG3);title('¡¾3¡¿Sobel¼ì²â£ºãÐÖµ=96');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Bin_Data_Gen(IMG1,IMG3);
