% 灰度图像均值滤波算法实现
% IMG为输入的灰度图像
% n为滤波的窗口大小，为奇数
function Q=avg_filter(IMG,n)    
% IMG = rgb2gray(imread('../../0_images/Scart.jpg'));    % 读取jpg图像
% n=3;

[h,w] = size(IMG); 
win = zeros(n,n);
Q = zeros(h,w);
for i=1 : h
    for j=1:w
        if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            Q(i,j) = IMG(i,j); 	 %边缘像素取原值
        else
            win =  IMG(i-(n-1)/2:i+(n-1)/2,  j-(n-1)/2:j+(n-1)/2);    
            Q(i,j)=sum(sum(win)) / (n*n);    %n*n窗口的矩阵，求和再均值
        end
    end  
end 
Q=uint8(Q);

