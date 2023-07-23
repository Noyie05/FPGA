clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
% IMG1= imread('../../0_images/Lenna.jpg');    % ¶ÁÈ¡jpgÍ¼Ïñ
IMG1= imread('../../0_images/Scart.jpg');    % ¶ÁÈ¡jpgÍ¼Ïñ

IMG1 = rgb2gray(IMG1);
h = size(IMG1,1);         % ¶ÁÈ¡Í¼Ïñ¸ß¶È
w = size(IMG1,2);         % ¶ÁÈ¡Í¼Ïñ¿í¶È


% -------------------------------------------------------------------------
subplot(221);imshow(IMG1);title('¡¾1¡¿Ô­Í¼');

% figure;
% -------------------------------------------------------------------------
% IMG2 = bilateral_filter_gray(IMG1, 3, 1, 0.1);  
% IMG3 = bilateral_filter_gray(IMG1, 3, 2, 0.1);    
% IMG4 = bilateral_filter_gray(IMG1, 3, 3, 0.1);   
% subplot(222);imshow(IMG2);title('¡¾2¡¿Ë«±ßÂË²¨3*3, sigma = [1, 0.1]');
% subplot(223);imshow(IMG3);title('¡¾3¡¿Ë«±ßÂË²¨3*3, sigma = [2, 0.1]');
% subplot(224);imshow(IMG4);title('¡¾4¡¿Ë«±ßÂË²¨3*3, sigma = [3, 0.1]');


% IMG2 = bilateral_filter_gray(IMG1, 3, 3, 0.1);  
% IMG3 = bilateral_filter_gray(IMG1, 3, 3, 0.3);    
% IMG4 = bilateral_filter_gray(IMG1, 3, 3, 0.8);   
% subplot(222);imshow(IMG2);title('¡¾2¡¿Ë«±ßÂË²¨3*3, sigma = [3, 0.1]');
% subplot(223);imshow(IMG3);title('¡¾3¡¿Ë«±ßÂË²¨3*3, sigma = [3, 0.3]');
% subplot(224);imshow(IMG4);title('¡¾4¡¿Ë«±ßÂË²¨3*3, sigma = [3, 0.8]');


IMG2 = bilateral_filter_gray(IMG1, 3, 3, 0.1);  
IMG3 = bilateral_filter_gray(IMG1, 5, 5, 0.1);    
IMG4 = bilateral_filter_gray(IMG1, 7, 7, 0.1);   
subplot(222);imshow(IMG2);title('¡¾2¡¿Ë«±ßÂË²¨3*3, sigma = [3, 0.1]');
subplot(223);imshow(IMG3);title('¡¾3¡¿Ë«±ßÂË²¨5*5, sigma = [3, 0.1]');
subplot(224);imshow(IMG4);title('¡¾4¡¿Ë«±ßÂË²¨7*7, sigma = [3, 0.1]');