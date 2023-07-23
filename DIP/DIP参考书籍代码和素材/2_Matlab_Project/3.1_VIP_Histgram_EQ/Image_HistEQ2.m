clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/gsls_test1.tif');    % 读取jpg图像
% IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % 读取图像高度
w = size(IMG1,2);         % 读取图像宽度

% ----------------------------------------------
% Step1: 进行像素灰度级数统计
NumPixel = zeros(1,256);    %统计0-255灰度级数
for i = 1:h      
    for j = 1: w      
        NumPixel(IMG1(i,j) + 1) = NumPixel(IMG1(i,j) + 1) + 1;
    end      
end      

% Step2: 进行像素灰度级数累积统计    
CumPixel = zeros(1,256);      
for i = 1:256      
    if i == 1      
        CumPixel(i) = NumPixel(i);      
    else      
        CumPixel(i) = CumPixel(i-1) + NumPixel(i);      
    end      
end      
    
% Step3: 对灰度值进行映射（均衡化） = 归一化 + 扩大到255
IMG2 = zeros(h,w); 
for i = 1:h      
    for j = 1: w      
%        IMG2(i,j) = CumPixel(IMG1(i,j)+1)/(h*w)*255;    
        IMG2(i,j) = CumPixel(IMG1(i,j)+1)/980;
%        IMG2(i,j) = bitshift(CumPixel(IMG1(i,j)+1),-10);    
    end      
end      
IMG2 = uint8(IMG2);


% -------------------------------------------------------------------------
% IMG2 = rgb2gray(IMG1);    % 转灰度图像 
% figure;
subplot(231), imshow(IMG1); title('Original Image');
subplot(234), imhist(IMG1); title('Original Hist');

% ----------------------------------------------
% Step1: 进行像素灰度级数统计
NumPixel2 = zeros(1,256);    %统计0-255灰度级数
for i = 1:h      
    for j = 1: w      
        NumPixel2(IMG2(i,j) + 1) = NumPixel2(IMG2(i,j) + 1) + 1;
    end      
end      

% Step2: 进行像素灰度级数累积统计    
CumPixel2 = zeros(1,256);      
for i = 1:256      
    if i == 1      
        CumPixel2(i) = NumPixel2(i);      
    else      
        CumPixel2(i) = CumPixel2(i-1) + NumPixel2(i);      
    end      
end   
subplot(232), imshow(IMG2); title('Manual HistEQ Image');
subplot(235), imhist(IMG2); title('Manual HistEQ Hist');

% ----------------------------------------------
% Matlab自带函数计算
IMG3 = zeros(h,w); 
IMG3 = histeq(IMG1);      % Matlab自带直方图均衡
subplot(233), imshow(IMG3); title('Matlab HistEQ Image');
subplot(236), imhist(IMG3); title('Matlab HistEQ Hist');


% ----------------------------------------------
figure;
subplot(121),bar(CumPixel); title('原图灰度级数累积');
subplot(122),bar(CumPixel2);title('拉伸后灰度级数累积');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG2);
