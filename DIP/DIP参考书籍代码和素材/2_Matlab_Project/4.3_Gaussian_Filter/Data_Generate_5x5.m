clear all; close all; clc;

% ---------------------------------------------------
% 计算5*5高斯模板
sigma = 3;
G1=zeros(5,5);   %5*5高斯模板
for i=-2 : 2
    for j=-2 : 2
%         G1(i+3,j+3) = exp(-(i.^2 + j.^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+3,j+3) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% 归一化5*5高斯模板
temp = sum(sum(G1));
G2 = G1/temp;

% 5*5高斯模板 *1024定点化
G3 = floor(G2*1024);



