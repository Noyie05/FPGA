clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1 = imread('../../0_images/scart.jpg');    % ��ȡjpgͼ��
IMG1 = imread('../../0_images/gsls_test1.tif');    % ��ȡjpgͼ��
% IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����
subplot(121);imshow(IMG1);title('ԭͼ');

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
subplot(122);imshow(IMG2);title('�Աȶ���ǿЧ��');

% -------------------------------------------------------------------------
figure;
subplot(231);imshow(IMG1);title('ԭͼ');
subplot(232);imshow(IMG2);title('ָ���Աȶ���ǿͼ');
subplot(233);imhist(IMG2);title('��ǿ��ֱ��ͼ');

IMG3 = zeros(h,w);
IMG3 = histeq(IMG1);
subplot(235);imshow((IMG3));title('ֱ��ͼ����ͼ');
subplot(236);imhist(IMG3);title('�����ֱ��ͼ');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG2);


