clear all; close all; clc;

% ---------------------------------------------------
% ����3*3��˹ģ��
sigma = 3;
G1=zeros(3,3);   %3*3��˹ģ��
for i=-1 : 1
    for j=-1 : 1
%         G1(i+2,j+2) = exp(-(i.^2 + j.^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+2,j+2) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% ��һ��3*3��˹ģ��
temp = sum(sum(G1));
G2 = G1/temp;

% 3*3��˹ģ�� *1024���㻯
G3 = floor(G2*1024);



