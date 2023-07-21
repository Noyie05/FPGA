% �Ҷ�ͼ��˫���˲��㷨ʵ��
% IΪ����ĻҶ�ͼ��
% nΪ�˲��Ĵ��ڴ�С��Ϊ����
function B=bilateral_filter_gray(I,n,sigma_d, sigma_r)    

% ---------------------------------------------------
% ����function�Բ�ʹ��
% clear all;   close all;  clc;
% I = rgb2gray(imread('../../0_images/Scart.jpg'));    % ��ȡjpgͼ��
% n = 3; sigma_d = 3; sigma_r = 0.8;  

dim = size(I);   %��ȡͼ��߶ȡ����
w=floor(n/2);   %���� [-w, w]


% ---------------------------------------------------
% ����n*n��˹ģ��
G1=zeros(n,n);   %n*n��˹ģ��
for i=-w : w
    for j=-w : w
        G1(i+w+1, j+w+1) = exp(-(i^2 + j^2)/(2*sigma_d^2)) ;
    end
end

% ��һ��n*n��˹�˲�ģ��
temp = sum(G1(:));
G2 = G1/temp;

% n*n��˹ģ�� *1023���㻯
G3 = floor(G2*1023);


I = double(I);
% ---------------------------------------------------
% ����n*n˫���˲�ģ��+ �˲����
h = waitbar(0,'Speed of bilateral filter process...');  %����������
B = zeros(dim);
for i=1 : dim(1)
    for j=1 : dim(2)
         if(i<w+1 || i>dim(1)-w || j<w+1 || j>dim(2)-w)
            B(i,j) = I(i,j);    %��Ե����ȡԭֵ
         else
             A = I(i-w:i+w, j-w:j+w);
%              H =  exp( -(I(i,j)-A).^2/(2*sigma_r^2)  ) ;
             H = exp( -((A-I(i,j))/255).^2/(2*sigma_r^2))  ;
             F = G3.*H;
             F2=F/sum(F(:));
             B(i,j) = sum(F2(:) .*A(:));
          end
    end
     waitbar(i/dim(1));
end
close(h);   % Close waitbar.


I = uint8(I);
B = uint8(B);

% ---------------------------------------------------
% ����function�Բ�ʹ��
% subplot(121);imshow(I);title('��1��ԭʼͼ��');
% subplot(122);imshow(B);title('��2��˫���˲����');



