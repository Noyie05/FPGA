clear all; close all; clc;

sigma = 3;
n=3;
w=floor(n/2);

% ---------------------------------------------------
% ����n*n��˹ģ��
G1=zeros(n,n);  
for i=-w : w
    for j=-w : w
%         G1(i+w+1,j+w+1) = exp(-(i^2 + j^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+w+1,j+w+1) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% ��һ��n*n��˹ģ��
temp = sum(sum(G1));
G2 = G1/temp;

% n*n��˹ģ�� *1024���㻯
G3 = floor(G2*1024);



