% 灰度图像布局自动二值化实现
% IMG为输入的灰度图像
% n为求阈值的窗口大小，为奇数
function Q=region_bin_auto(IMG,n)    %目前n只能等于3 


[h,w] = size(IMG); 
Q = zeros(h,w);
win = zeros(n,n);


bar = waitbar(0,'Speed of auto region binarization process...');  %创建进度条
for i=1 : h
    for j=1:w
        if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            Q(i,j) = 255; 	 %边缘像素取原值
        else
            win =  IMG(i-(n-1)/2:i+(n-1)/2,  j-(n-1)/2:j+(n-1)/2);    %n*n窗口的矩阵
            temp = floor( mean(mean(win)) * 0.9);
            if(win((n-1)/2,(n-1)/2) < temp )
                Q(i,j) = 0;
            else
                Q(i,j) = 255;
            end
        end
    end  
    waitbar(i/h);
end 
close(bar);   % Close waitbar.


Q=uint8(Q);