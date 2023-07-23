clear all; close all; clc;

% -------------------------------------------------------------------------
% Gammaӳ�亯��
x = [0:1:255];
y1 = (255/255.^(1/2.2))*x.^(1/2.2);
y2 = zeros(1,256);
for i = 1:255
    if(x==0)
        y2(1)=0;
    else
        y2(i)=(y1(i+1)-y1(i))/y1(i);
    end
end
subplot(121),plot(x,y1,'Linewidth',2);grid on;  title('Gammaӳ������');
subplot(122),plot(x,y2,'Linewidth',2);grid on;title('Gamma�仯ǿ��');