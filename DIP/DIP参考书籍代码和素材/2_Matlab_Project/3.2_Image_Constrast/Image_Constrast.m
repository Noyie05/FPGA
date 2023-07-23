clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1 = imread('../../0_images/scart.jpg');    % 读取jpg图像
% IMG1 = rgb2gray(IMG1);
% h = size(IMG1,1);         % 读取图像高度
% w = size(IMG1,2);         % 读取图像宽度

IMG1 = zeros(256,256);
for m = 1:256
    IMG1(m,m) = m;
    for n = (m+1):256
        IMG1(m,n) = n-1;
        IMG1(n,m) = IMG1(m,n)-1;
    end
end
subplot(121);imshow(uint8(IMG1));title('对称灰阶原图');

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
subplot(122);imshow(IMG2);title('对比度增强效果');

% -------------------------------------------------------------------------
figure;
subplot(121);imhist(uint8(IMG1));title('原图直方图');
subplot(122);imhist(uint8(IMG2));title('增强后直方图');


