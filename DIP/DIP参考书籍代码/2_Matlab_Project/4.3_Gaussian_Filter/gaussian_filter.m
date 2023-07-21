% �Ҷ�ͼ���˹�˲��㷨ʵ��
% IMGΪ����ĻҶ�ͼ��
% nΪ�˲��Ĵ��ڴ�С��Ϊ����
function Q=gaussian_filter(IMG,n,sigma)    

% IMG = rgb2gray(imread('../../0_images/Scart.jpg'));    % ��ȡjpgͼ��
% n=3; sigma = 3;

h = size(IMG,1);         % ��ȡͼ��߶�
w = size(IMG,2);         % ��ȡͼ����


% ---------------------------------------------------
% ����n*n��˹ģ��
% sigma = 3;
G1=zeros(n,n);   %n*n��˹ģ��
for i=-(n-1)/2 : (n-1)/2
    for j=-(n-1)/2 : (n-1)/2
%         G1(i+mod(n,2),j+mod(n,2)) = exp(-(i.^2 + j.^2)/(2*sigma^2)) / (2*pi*sigma^2);
        G1(i+(n+1)/2,j+(n+1)/2) = exp(-(i^2 + j^2)/(2*sigma^2)) ;
    end
end

% ��һ��n*n��˹ģ��
temp = sum(sum(G1));
G2 = G1/temp;

% n*n��˹ģ�� *1024���㻯
G3 = floor(G2*1024);


% ---------------------------------------------------
Q = zeros(h,w);
for i=1 : h
    for j=1:w
         if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            Q(i,j) = IMG(i,j);    %��Ե����ȡԭֵ
         else
            Q(i,j) = conv2(double(IMG(i-(n-1)/2:i+(n-1)/2,  j-(n-1)/2:j+(n-1)/2)), double(G3), 'valid')/1024;
         end
    end
end
Q = uint8(Q);
% subplot(121);imshow(IMG);title('��1��ԭʼͼ��');
% subplot(122);imshow(Q);title('��2����˹�˲����');

