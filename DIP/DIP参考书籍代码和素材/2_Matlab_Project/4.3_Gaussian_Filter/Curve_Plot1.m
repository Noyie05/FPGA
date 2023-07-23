clear all; close all; clc;

% -------------------------------------------------------------------------
% 一维函数函数
x = -10:0.1:10;
sigma1 = 1;
sigma2 = 2;
sigma3 = 3;
y1 = exp(-x.^2/(2*sigma1^2)) / ((2*pi)^0.5*sigma1);
y2 = exp(-x.^2/(2*sigma2^2)) / ((2*pi)^0.5*sigma2);
y3 = exp(-x.^2/(2*sigma3^2)) / ((2*pi)^0.5*sigma3);


plot(x,y1,x,y2,x,y3,'Linewidth',2); grid on;
legend('sigma1=1','sigma2=2','sigma3=3');
title('一维高斯分布曲线');
