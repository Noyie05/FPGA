%简单地说:
%A为给定图像，归一化到[0,1]的矩阵
%W为双边滤波器（核）的边长/2
%定义域方差σd记为SIGMA(1),值域方差σr记为SIGMA(2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre-process input and select appropriate filter.
function B = bfilter2(A,n,sigma_d, sigma_r)

% clear all;   close all;  clc;
% A = rgb2gray(imread('../../0_images/Scart.jpg'));    % 读取jpg图像
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
%计算值域核H 并与定义域核G 乘积得到双边权重函数F
dim = size(A);
B = zeros(dim);
for i = 1:dim(1)
   for j = 1:dim(2)
         if(i<w+1 || i>dim(1)-w || j<w+1 || j>dim(2)-w)
            B(i,j) = A(i,j);    %边缘像素取原值
         else
%          % Extract local region.
%          iMin = max(i-w,1);
%          iMax = min(i+w,dim(1));
%          jMin = max(j-w,1);
%          jMax = min(j+w,dim(2));
%          else
            I = A(i-w:i+w, j-w:j+w);

         %定义当前核所作用的区域为(iMin:iMax,jMin:jMax)
%          I = A(iMin:iMax,jMin:jMax);%提取该区域的源图像值赋给I

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

%     subplot(121);imshow(A);title('【1】原始图像');
%     subplot(122);imshow(B);title('【2】双边滤波结果');
    


