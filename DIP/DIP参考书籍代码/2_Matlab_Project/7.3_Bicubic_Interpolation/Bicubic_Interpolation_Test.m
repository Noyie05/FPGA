clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1= imread('../../0_images/Scart.jpg');    % 读取jpg图像
IMG1 = rgb2gray(IMG1);
h1 = size(IMG1,1);          % 读取图像高度
w1 = size(IMG1,2);          % 读取图像宽度
h2 = 768;                   % 放大后图像高度
w2 = 1024;                  % 放大后图像宽度

% -------------------------------------------------------------------------
IMG2 = imresize(IMG1,[h2 w2],'bicubic');

figure
imshowpair(IMG1,IMG2,'montage');
title('左图：原图(640*480)   右图：Matlab自带双三次插值放大结果(1024*768)');

% -------------------------------------------------------------------------
IMG3 = Bicubic_Interpolation(IMG1,h1,w1,h2,w2);

figure
imshowpair(IMG1,IMG3,'montage');
title('左图：原图(640*480)   右图：手动编写双三次插值放大结果(1024*768)');

