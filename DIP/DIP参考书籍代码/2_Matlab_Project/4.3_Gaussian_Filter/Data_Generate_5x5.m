clear all; close all; clc;

% ---------------------------------------------------
% ����5*5��˹ģ��
sigma = 3;
G1=zeros(5,5);   %5*5��˹ģ��
for i=-2 : 2
    for j=-2 : 2
%         G1(i+3,j+3) = exp(-(i.^2 + j.^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+3,j+3) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% ��һ��5*5��˹ģ��
temp = sum(sum(G1));
G2 = G1/temp;

% 5*5��˹ģ�� *1024���㻯
G3 = floor(G2*1024);



