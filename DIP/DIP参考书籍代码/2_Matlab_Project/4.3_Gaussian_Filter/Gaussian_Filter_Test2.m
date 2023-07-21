clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');  
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度
subplot(131);imshow(IMG1);title('【1】原图');

% -------------------------------------------------------------------------
g = fspecial('gaussian',[5,5],3);
IMG2 = imfilter(IMG1, g, 'replicate');
subplot(132);imshow(IMG2);title('【2】Matlab自带高斯滤波');

% -------------------------------------------------------------------------
G =[32    38    40    38    32; ...
       38    45    47    45    38; ...
       40    47    50    47    40; ...
       38    45    47    45    38; ...
       32    38    40    38    32];
IMG3 = zeros(h,w);
n=5;
for i=1 : h
    for j=1:w
         if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            IMG3(i,j) = IMG1(i,j);    %边缘像素取原值
         else
            IMG3(i,j) = conv2(double(IMG1(i-(n-1)/2:i+(n-1)/2,  j-(n-1)/2:j+(n-1)/2)), double(G), 'valid')/1024;
         end
    end
end
IMG3 = uint8(IMG3);
subplot(133);imshow(IMG3);title('【3】手动编写高斯滤波');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG3);

