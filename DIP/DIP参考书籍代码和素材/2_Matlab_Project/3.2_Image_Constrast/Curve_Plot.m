clear all; close all; clc;

% -------------------------------------------------------------------------
% 绘制不同强度的指数对比度增强曲线
THRESHOLD = 127;
E1 = 2;
E2 = 4;
E3 = 6;
x = [0:1:255];
y1 = (1./(1 + (THRESHOLD./x).^E1)) * 255;
y2 = (1./(1 + (THRESHOLD./x).^E2)) * 255;
y3 = (1./(1 + (THRESHOLD./x).^E3)) * 255;
plot(x,y1,x,y2,x,y3,'Linewidth',2);grid on;
legend('E=2','E=4','E=6');
xlabel('原始像素');
ylabel('映射后像素');
title('指数对比度增强曲线');
