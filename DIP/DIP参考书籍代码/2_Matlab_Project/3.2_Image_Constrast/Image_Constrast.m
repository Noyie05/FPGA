clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1 = imread('../../0_images/scart.jpg');    % ��ȡjpgͼ��
% IMG1 = rgb2gray(IMG1);
% h = size(IMG1,1);         % ��ȡͼ��߶�
% w = size(IMG1,2);         % ��ȡͼ����

IMG1 = zeros(256,256);
for m = 1:256
    IMG1(m,m) = m;
    for n = (m+1):256
        IMG1(m,n) = n-1;
        IMG1(n,m) = IMG1(m,n)-1;
    end
end
subplot(121);imshow(uint8(IMG1));title('�Գƻҽ�ԭͼ');

% -------------------------------------------------------------------------
THRESHOLD = 127;
E=5;
IMG2 = zeros(256,256);
for i = 1:256
    for j = 1:256
        IMG2(i,j) = (1./(1 + (THRESHOLD./IMG1(i,j)).^E)) * 255;
    end

end
IMG2 = uint8(IMG2);
subplot(122);imshow(IMG2);title('�Աȶ���ǿЧ��');

% -------------------------------------------------------------------------
figure;
subplot(121);imhist(uint8(IMG1));title('ԭͼֱ��ͼ');
subplot(122);imhist(uint8(IMG2));title('��ǿ��ֱ��ͼ');


