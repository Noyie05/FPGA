% 灰度图像高斯滤波算法实现
% IMG为输入的灰度图像
% n为滤波的窗口大小，为奇数
function Q=gaussian_filter(IMG,n,sigma)    

% IMG = rgb2gray(imread('../../0_images/Scart.jpg'));    % 读取jpg图像
% n=3; sigma = 3;

h = size(IMG,1);         % 读取图像高度
w = size(IMG,2);         % 读取图像宽度


% ---------------------------------------------------
% 计算n*n高斯模板
% sigma = 3;
G1=zeros(n,n);   %n*n高斯模板
for i=-(n-1)/2 : (n-1)/2
    for j=-(n-1)/2 : (n-1)/2
%         G1(i+mod(n,2),j+mod(n,2)) = exp(-(i.^2 + j.^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+(n+1)/2,j+(n+1)/2) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% 归一化n*n高斯模板
temp = sum(sum(G1));
G2 = G1/temp;

% n*n高斯模板 *1024定点化
G3 = floor(G2*1024);


% ---------------------------------------------------
Q = zeros(h,w);
for i=1 : h
    for j=1:w
         if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            Q(i,j) = IMG(i,j);    %边缘像素取原值
         else
            Q(i,j) = conv2(double(IMG(i-(n-1)/2:i+(n-1)/2,  j-(n-1)/2:j+(n-1)/2)), double(G3), 'valid')/1024;
         end
    end
end
Q = uint8(Q);
% subplot(121);imshow(IMG);title('【1】原始图像');
% subplot(122);imshow(Q);title('【2】高斯滤波结果');

