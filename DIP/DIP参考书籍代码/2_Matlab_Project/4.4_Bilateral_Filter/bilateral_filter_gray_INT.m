% 灰度图像双边滤波算法实现
% I为输入的灰度图像
% n为滤波的窗口大小，为奇数
function B=bilateral_filter_gray_INT(I,n,sigma_d, sigma_r)    

% clear all;   close all;  clc;
% I = rgb2gray(imread('../../0_images/Scart.jpg'));    % 读取jpg图像
% n = 3; sigma_d = 3; sigma_r = 0.1;  

dim = size(I);   %读取图像高度、宽度
w=floor(n/2);   %窗口 [-w, w]


% ---------------------------------------------------
% 计算n*n高斯模板
G1=zeros(n,n);   %n*n高斯模板
for i=-w : w
    for j=-w : w
        G1(i+w+1, j+w+1) = exp(-(i^2 + j^2)/(2*sigma_d^2)) ;
    end
end

% 归一化n*n高斯滤波模板
temp = sum(G1(:));
G2 = G1/temp;

% n*n高斯模板 *1024定点化
G3 = floor(G2*1024);

% ---------------------------------------------------
% 计算相似度指数*1023结果
% H = zeros(1, 256);
for i=0 : 255
    H(i+1) = exp( -(i/255)^2/(2*sigma_r^2));
end
H = floor(H *1023);

I = double(I);
% ---------------------------------------------------
% 计算n*n双边滤波模板+ 滤波结果
h = waitbar(0,'Speed of bilateral filter process...');  %创建进度条
B = zeros(dim);
for i=1 : dim(1)
    for j=1 : dim(2)
         if(i<w+1 || i>dim(1)-w || j<w+1 || j>dim(2)-w)
            B(i,j) = I(i,j);    %边缘像素取原值
         else
             A = I(i-w:i+w, j-w:j+w);
%              H =  exp( -(I(i,j)-A).^2/(2*sigma_r^2)  ) ;
             F1 = reshape(H(abs(A-I(i,j))+1), n, n);    %计算相似度权重(10bit)
             F2 = F1 * G3;                                       %计算双边权重（20bit）
             F3=floor(F2*1024/sum(F2(:)));                        %归一化双边滤波权重（扩大1024）
             B(i,j) = sum(F3(:) .*A(:))/1024;                %卷积后得到最终累加的结果（缩小1024）
          end
    end
     waitbar(i/dim(1));
end
close(h);   % Close waitbar.


I = uint8(I);
B = uint8(B);

% subplot(121);imshow(I);title('【1】原始图像');
% subplot(122);imshow(B);title('【2】双边滤波结果');


