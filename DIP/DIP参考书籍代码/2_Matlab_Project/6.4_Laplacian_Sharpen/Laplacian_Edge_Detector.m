% �Ҷ�ͼ��Laplacian��Ե����㷨ʵ��
% IMGΪ����ĻҶ�ͼ��
% QΪ����ĻҶ�ͼ��
function Q = Laplacian_Edge_Detector(IMG)

[h,w] = size(IMG);              % ��ȡͼ��ĸ߶�h�Ϳ��w
Q = zeros(h,w);                 % ��ʼ��QΪȫ0��h*w��С��ͼ��

% -------------------------------------------------------------------------
%         W                Pixel
% [   0  -1   0  ]   [  P1  P2  P3]
% [  -1   4  -1  ]   [  P4  P5  P6]
% [   0  +1   0  ]   [  P7  P8  P9]
W = [0,-1,0;-1,4,-1;0,-1,0];    % Weight 

IMG = double(IMG);

for i = 1 : h
    for j = 1 : w
        if(i<2 || i>h-1 || j<2 || j>w-1)
            Q(i,j) = 0;             % ��Ե���ز�����
        else
            Q(i,j) = W(1,1)*IMG(i-1,j-1) + W(1,2)*IMG(i-1,j) + W(1,3)*IMG(i-1,j+1) +...
                     W(2,1)*IMG(i  ,j-1) + W(2,2)*IMG(i  ,j) + W(2,3)*IMG(i  ,j+1) +...
                     W(3,1)*IMG(i+1,j-1) + W(3,2)*IMG(i+1,j) + W(3,3)*IMG(i+1,j+1);
        end
    end  
end 
