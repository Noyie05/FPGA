clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1 = imread('../../0_images/scart.jpg');    % 读取jpg图像
IMG1 = imread('../../0_images/gsls_test1.tif');    % 读取jpg图像
% IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(121);imshow(IMG1);title('原图');

% -------------------------------------------------------------------------
THRESHOLD = 127;
E=5;
% IMG1 = double(IMG1);
IMG2 = zeros(h,w);
for i = 1:h
    for j = 1:w
        IMG2(i,j) = (1./(1 + (THRESHOLD./double(IMG1(i,j))).^E)) * 255;
    end

end
IMG2 = uint8(IMG2);
subplot(122);imshow(IMG2);title('对比度增强效果');

% -------------------------------------------------------------------------
figure;
subplot(231);imshow(IMG1);title('原图');
subplot(232);imshow(IMG2);title('指数对比度增强图');
subplot(233);imhist(IMG2);title('增强后直方图');

IMG3 = zeros(h,w);
IMG3 = histeq(IMG1);
subplot(235);imshow((IMG3));title('直方图拉伸图');
subplot(236);imhist(IMG3);title('拉伸后直方图');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG2);


