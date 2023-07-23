clear all; close all; clc;

% ---------------------------------------------------
% 计算3*3高斯模板
sigma = 3;
G1=zeros(3,3);   %3*3高斯模板
for i=-1 : 1
    for j=-1 : 1
%         G1(i+2,j+2) = exp(-(i.^2 + j.^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+2,j+2) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% 归一化3*3高斯模板
temp = sum(sum(G1));
G2 = G1/temp;

% 3*3高斯模板 *1024定点化
G3 = floor(G2*1024);



