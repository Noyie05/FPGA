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
IMG2 = imresize(IMG1,[h2 w2],'bilinear');

figure
imshowpair(IMG1,IMG2,'montage');
title('左图：原图(640*480)   右图：Matlab自带双线性插值放大结果(1024*768)');

% -------------------------------------------------------------------------
IMG3 = Bilinear_Interpolation(IMG1,h1,w1,h2,w2);

figure
imshowpair(IMG1,IMG3,'montage');
title('左图：原图(640*480)   右图：手动编写双线性插值放大结果（浮点）(1024*768)');

% -------------------------------------------------------------------------
IMG4 = Bilinear_Interpolation_Int(IMG1,h1,w1,h2,w2);

figure
imshowpair(IMG1,IMG3,'montage');
title('左图：原图(640*480)   右图：手动编写双线性插值放大结果（定点）(1024*768)');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);
