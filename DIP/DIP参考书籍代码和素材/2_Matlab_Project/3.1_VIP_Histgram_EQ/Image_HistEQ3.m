clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1 = imread('../../0_images/scart.jpg');    % ��ȡjpgͼ��
IMG1 = imread('../../0_images/vein.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����

% ----------------------------------------------
% Step1: �������ػҶȼ���ͳ��
NumPixel = zeros(1,256);    %ͳ��0-255�Ҷȼ���
for i = 1:h      
    for j = 1: w      
        NumPixel(IMG1(i,j) + 1) = NumPixel(IMG1(i,j) + 1) + 1;
    end      
end      

% Step2: �������ػҶȼ����ۻ�ͳ��    
CumPixel = zeros(1,256);      
for i = 1:256      
    if i == 1      
        CumPixel(i) = NumPixel(i);      
    else      
        CumPixel(i) = CumPixel(i-1) + NumPixel(i);      
    end      
end      
    
% Step3: �ԻҶ�ֵ����ӳ�䣨���⻯�� = ��һ�� + ����255
IMG2 = zeros(h,w); 
for i = 1:h      
    for j = 1: w      
        IMG2(i,j) = CumPixel(IMG1(i,j)+1)/(h*w)*255;    
%        IMG2(i,j) = bitshift(CumPixel(IMG1(i,j)+1),-10);    
    end      
end      
IMG2 = uint8(IMG2);


% -------------------------------------------------------------------------
% IMG2 = rgb2gray(IMG1);    % ת�Ҷ�ͼ�� 
% figure;
subplot(231), imshow(IMG1);  title('ԭʼͼ��');
subplot(232), imhist(IMG1); title('ԭʼͼ��ֱ��ͼ');

% ----------------------------------------------
% Step1: �������ػҶȼ���ͳ��
NumPixel2 = zeros(1,256);    %ͳ��0-255�Ҷȼ���
for i = 1:h      
    for j = 1: w      
        NumPixel2(IMG2(i,j) + 1) = NumPixel2(IMG2(i,j) + 1) + 1;
    end      
end      

% Step2: �������ػҶȼ����ۻ�ͳ��    
CumPixel2 = zeros(1,256);      
for i = 1:256      
    if i == 1      
        CumPixel2(i) = NumPixel2(i);      
    else      
        CumPixel2(i) = CumPixel2(i-1) + NumPixel2(i);      
    end      
end   
subplot(234), imshow(IMG2); title('������ͼ��');
subplot(235), imhist(IMG2); title('�����ͼ��ֱ��ͼ');


% ----------------------------------------------
% figure;
subplot(233),bar(CumPixel); title('ԭͼ�Ҷȼ����ۻ�');
subplot(236),bar(CumPixel2);title('�����ͼ��Ҷȼ����ۻ�');