% 灰度图像中值滤波算法实现
% IMG为输入的灰度图像
% n为滤波的窗口大小，为奇数
function Q=med_filter(IMG,n)    %目前n只能等于3 
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
            win =  IMG(i-(n-1)/2:i+(n-1)/2,  j-(n-1)/2:j+(n-1)/2);    %n*n窗口的矩阵
%             Q(i,j)=median(median(win));                                 %求中值
             max1 = max(win(1,1:3)); mid1 = median(win(1,1:3)); min1 = min(win(1,1:3));
             max2 = max(win(2,1:3)); mid2 = median(win(2,1:3)); min2 = min(win(2,1:3));
             max3 = max(win(3,1:3)); mid3 = median(win(3,1:3)); min3 = min(win(3,1:3));
             max_min = min([max1, max2, max3]);
             mid_mid = median([mid1, mid2, mid3]);
             min_max = max([min1, min2, min3]);
             Q(i,j) = median([max_min, mid_mid, min_max]);
        end
    end  
end 
Q=uint8(Q);

% subplot(121);imshow(IMG1);title('【1】原图');
% subplot(122);imshow(IMG4);title('【2】3*3中值滤波');


