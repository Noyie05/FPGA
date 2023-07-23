clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
IMG1 = imread('../../0_images/Scart.jpg');    % ¶ÁÈ¡jpgÍ¼Ïñ
h = size(IMG1,1);         % ¶ÁÈ¡Í¼Ïñ¸ß¶È
w = size(IMG1,2);         % ¶ÁÈ¡Í¼Ïñ¿í¶È
subplot(221);imshow(IMG1);title('RGB Image');

% -------------------------------------------------------------------------
% Relized by user logic
% Y = ( R*76 + G*150 + B*29) >>8
% Cb = (-R*43 - G*84 + B*128 + 32768) >>8
% Cr = ( R*128 - G*107 - B*20  + 32768) >>8
IMG1 = double(IMG1);    
IMG_YCbCr = zeros(h,w,3);  
for i = 1 : h
    for j = 1 : w
        IMG_YCbCr(i,j, 1) = bitshift(( IMG1(i,j,1)*76 + IMG1(i,j,2)*150 + IMG1(i,j,3)*29),-8);
        IMG_YCbCr(i,j,2) = bitshift((-IMG1(i,j,1)*43 - IMG1(i,j,2)*84 + IMG1(i,j,3)*128 + 32768),-8);
        IMG_YCbCr(i,j,3) = bitshift(( IMG1(i,j,1)*128 - IMG1(i,j,2)*107 - IMG1(i,j,3)*20 + 32768),-8);
    end
end

% -------------------------------------------------------------------------
% Display Y Cb Cr Channel
IMG_YCbCr = uint8(IMG_YCbCr); 
subplot(222); imshow(IMG_YCbCr(:,:,1));  title('Y Channel');
subplot(223); imshow(IMG_YCbCr(:,:,2));  title('Cb Channel');
subplot(224); imshow(IMG_YCbCr(:,:,3));  title('Cr Channel');


% -------------------------------------------------------------------------
% Generate image Source Data and Target Data
RGB2YCbCr_Data_Gen(IMG1, IMG_YCbCr);

