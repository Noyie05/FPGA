clear all; close all; clc;

sigma = 3;
n=3;
w=floor(n/2);

% ---------------------------------------------------
% 计算n*n高斯模板
G1=zeros(n,n);  
for i=-w : w
    for j=-w : w
%         G1(i+w+1,j+w+1) = exp(-(i^2 + j^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+w+1,j+w+1) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% 归一化n*n高斯模板
temp = sum(sum(G1));
G2 = G1/temp;

% n*n高斯模板 *1024定点化
G3 = floor(G2*1024);



