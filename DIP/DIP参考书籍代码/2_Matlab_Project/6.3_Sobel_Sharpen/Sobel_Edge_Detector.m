% �Ҷ�ͼ��Sobel��Ե����㷨ʵ��
% IMGΪ����ĻҶ�ͼ��
% QΪ����ĻҶ�ͼ��
function Q = Sobel_Edge_Detector(IMG)

[h,w] = size(IMG);              % ��ȡͼ��ĸ߶�h�Ϳ��w
Q = zeros(h,w);                 % ��ʼ��QΪȫ0��h*w��С��ͼ��

% -------------------------------------------------------------------------
%         Wx                Wy               Pixel
% [  -1   0  +1  ]   [  -1 -2  -1]     [  P1  P2  P3]
% [  -2   0  +2  ]   [   0  0   0]     [  P4  P5  P6]
% [  -1   0  +1  ]   [  +1 +2  +1]     [  P7  P8  P9]
Wx = [-1,0,1;-2,0,2;-1,0,1];         % Weight x
Wy = [-1,-2,-1;0,0,0;1,2,1];         % Weight y

IMG = double(IMG);

for i = 1 : h
    for j = 1 : w
        if(i<2 || i>h-1 || j<2 || j>w-1)
            Q(i,j) = 0;             % ��Ե���ز�����
        else
            Gx = Wx(1,1)*IMG(i-1,j-1) + Wx(1,2)*IMG(i-1,j) + Wx(1,3)*IMG(i-1,j+1) +...
                 Wx(2,1)*IMG(i  ,j-1) + Wx(2,2)*IMG(i  ,j) + Wx(2,3)*IMG(i  ,j+1) +...
                 Wx(3,1)*IMG(i+1,j-1) + Wx(3,2)*IMG(i+1,j) + Wx(3,3)*IMG(i+1,j+1);
            Gy = Wy(1,1)*IMG(i-1,j-1) + Wy(1,2)*IMG(i-1,j) + Wy(1,3)*IMG(i-1,j+1) +...
                 Wy(2,1)*IMG(i  ,j-1) + Wy(2,2)*IMG(i  ,j) + Wy(2,3)*IMG(i  ,j+1) +...
                 Wy(3,1)*IMG(i+1,j-1) + Wy(3,2)*IMG(i+1,j) + Wy(3,3)*IMG(i+1,j+1);
            Q(i,j) = sqrt(Gx^2 + Gy^2);
        end
    end  
end 
Q=uint8(Q);
