% 灰度图像Robert边缘检测算法实现
% IMG为输入的灰度图像
% Q为输出的灰度图像
function Q = Robert_Edge_Detector(IMG)

[h,w] = size(IMG);              % 获取图像的高度h和宽度w
Q = zeros(h,w);                 % 初始化Q为全0的h*w大小的图像

% -------------------------------------------------------------------------
%       Wx             Wy             Pixel
% [   0  +1  ]   [  +1   0  ]     [  P1  P2  ]
% [  -1   0  ]   [   0  -1  ]     [  P3  P4  ]
Wx = [0,1;-1,0];          % Weight x
Wy = [1,0;0,-1];          % Weight y

IMG = double(IMG);

for i = 1 : h
    for j = 1 : w
        if(i>h-1 || j>w-1)
            Q(i,j) = 0;             % 图像右边缘和下边缘像素不处理
        else
            Gx = Wx(1,1)*IMG(i  ,j) + Wx(1,2)*IMG(i  ,j+1) +...
                 Wx(2,1)*IMG(i+1,j) + Wx(2,2)*IMG(i+1,j+1);
            Gy = Wy(1,1)*IMG(i  ,j) + Wy(1,2)*IMG(i  ,j+1) +...
                 Wy(2,1)*IMG(i+1,j) + Wy(2,2)*IMG(i+1,j+1);
            Q(i,j) = sqrt(Gx^2 + Gy^2);
        end
    end  
end 
Q=uint8(Q);
