clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/scart.jpg');    % ��ȡjpgͼ��
IMG1 = rgb2gray(IMG1);
% IMG1 = imread('../../0_images/gsls_test1.tif');    % ��ȡjpgͼ��
h = size(IMG1,1);         % ��ȡͼ��߶�
w = size(IMG1,2);         % ��ȡͼ����
subplot(221);imshow(IMG1);title('��1��ԭͼ');

% -------------------------------------------------------------------------
IMG2 = zeros(h,w);
for i = 1:h
    for j = 1:w
        IMG2(i,j) = (255/255.^2.2)*double(IMG1(i,j)).^2.2;
    end

end
IMG2 = uint8(IMG2);
subplot(222);imshow(IMG2);title('��2��Gamma=2.2ӳ��');

% -------------------------------------------------------------------------
IMG3 = zeros(h,w);
for i = 1:h
    for j = 1:w
        IMG3(i,j) = (255/255.^(1/2.2))*double(IMG1(i,j)).^(1/2.2);
    end

end
IMG3 = uint8(IMG3);
subplot(223);imshow(IMG3);title('��3��Gamma=1/2.2ӳ��Ч��');


% -------------------------------------------------------------------------
THRESHOLD = 127;
E=4;
IMG4 = zeros(h,w);
for i = 1:h
    for j = 1:w
        IMG4(i,j) = (1./(1 + (THRESHOLD./double(IMG1(i,j))).^E)) * 255;
    end

end
IMG4 = uint8(IMG4);
subplot(224);imshow(IMG4);title('��4���Աȶ���ǿЧ��');

% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
Gray2Gray_Data_Gen(IMG1,IMG2);

