%�򵥵�˵:
%AΪ����ͼ�񣬹�һ����[0,1]�ľ���
%WΪ˫���˲������ˣ��ı߳�/2
%�����򷽲��d��ΪSIGMA(1),ֵ�򷽲��r��ΪSIGMA(2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre-process input and select appropriate filter.
function B = bfilter2(A,n,sigma_d, sigma_r)

% clear all;   close all;  clc;
% A = rgb2gray(imread('../../0_images/Scart.jpg'));    % ��ȡjpgͼ��
% n = 5; sigma_d = 3;  sigma_r =0.1;  

A = im2double(A);
w=floor(n/2);

% Pre-compute Gaussian distance weights.
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

% Create waitbar.
h = waitbar(0,'Applying bilateral filter...');
set(h,'Name','Bilateral Filter Progress');

% Apply bilateral filter.
%����ֵ���H ���붨�����G �˻��õ�˫��Ȩ�غ���F
dim = size(A);
B = zeros(dim);
for i = 1:dim(1)
   for j = 1:dim(2)
         if(i<w+1 || i>dim(1)-w || j<w+1 || j>dim(2)-w)
            B(i,j) = A(i,j);    %��Ե����ȡԭֵ
         else
%          % Extract local region.
%          iMin = max(i-w,1);
%          iMax = min(i+w,dim(1));
%          jMin = max(j-w,1);
%          jMax = min(j+w,dim(2));
%          else
            I = A(i-w:i+w, j-w:j+w);

         %���嵱ǰ�������õ�����Ϊ(iMin:iMax,jMin:jMax)
%          I = A(iMin:iMax,jMin:jMax);%��ȡ�������Դͼ��ֵ����I

         % Compute Gaussian intensity weights.
         
         H = exp(-(I-A(i,j)).^2/(2*sigma_r^2));
         % Calculate bilateral filter response.
         F = H.*G;
         B(i,j) = sum(F(:).*I(:))/sum(F(:));
         end

   end
   waitbar(i/dim(1));
end

% Close waitbar.
close(h);
B = im2uint8(B);

%     subplot(121);imshow(A);title('��1��ԭʼͼ��');
%     subplot(122);imshow(B);title('��2��˫���˲����');
    


