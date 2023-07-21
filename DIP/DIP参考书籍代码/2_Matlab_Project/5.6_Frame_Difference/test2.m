clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
frame1 = imread('../../0_images/nezha1.jpg');    % 读取jpg图像 
dim = size(frame1);   %读取图像高度、宽度
for i=1:dim(1)
    for j=1:dim(2)
       if((mod(i,80) == 0) || (mod(j,80) == 0))
           frame1(i,j,:) =255;
%        else
%            frame2(i,j,:) = frame1(i,j,:);
       end
    end  
end 

imshow(frame1);title('前一帧');
imwrite(frame1,'frame1_grid.jpg');