clear all; close all; clc;


DIFF_THRESH = 20;   %֡������ֵ
BLOCK_THRESH = 32;  %��Ч�����ֵ
% -------------------------------------------------------------------------
% Read PC image to Matlab
frame1 = imread('../../0_images/nezha1.jpg');    % ��ȡjpgͼ��
frame2 = imread('../../0_images/nezha2.jpg');    % ��ȡjpgͼ��

% subplot(221);imshow(frame1);title('ǰһ֡');
subplot(221);imshow(frame2);title('��ǰ֡');

%˫֡���
frame1 = rgb2gray(frame1);
frame2 = rgb2gray(frame2);
frame_diff = abs(frame1-frame2);
subplot(222);imshow(frame_diff);title('���֡');

%��ֵ����
frame_2dim = global_bin_user(frame_diff, DIFF_THRESH);
% subplot(223);imshow(frame_2dim);;title('��ֵ����');


% -------------------------------------------------------------------------
% ��֡���ͼ�ϵ���80*80�Ŀ�
grid_image = frame_2dim;
dim = size(grid_image);   %��ȡͼ��߶ȡ����
for i=1:dim(1)
    for j=1:dim(2)
       if((mod(i,80) == 0) || (mod(j,80) == 0))
           grid_image(i,j,:) =255;
%        else
%            frame2(i,j,:) = frame1(i,j,:);
       end
    end  
end 
imwrite(grid_image,'grid_image.jpg');
figure;imshow(grid_image);title('��ֵ����');


% -------------------------------------------------------------------------
% 1��ͳ��80*80������Ч�˶���������
[h,w] = size(frame_2dim); 
sum_block =zeros(ceil(h/80), ceil(w/80));
for i=1:h
    for j=1:w
        sum_block(ceil(i/80), ceil(j/80)) = sum_block(ceil(i/80), ceil(j/80)) + uint16(frame_2dim(i,j)/255);
    end  
end 

% -------------------------------------------------------------------------
% 2��ȥ���˶����ٵĿ�
for i=1:ceil(h/80)
    for j=1:ceil(w/80)
        if(sum_block(i,j) < BLOCK_THRESH)
            sum_block(i,j) = 0;
        else
            sum_block(i,j) = sum_block(i,j);
        end
    end
end


% -------------------------------------------------------------------------
% 3����ȡĿ����������ұ߽�
% by_start��������
i=1;
while(sum_block(i,:) == 0)
    i=i+1;end
by_start = i;
% by_end��������
i=ceil(h/80);
while(sum_block(i,:) == 0)
    i=i-1;end
by_end = i;
% bx_start��������
j=1;
while(sum_block(:,j) == 0)
    j=j+1;end
bx_start = j;
% bx_end��������
j=ceil(w/80);
while(sum_block(:,j) == 0)
    j=j-1;end
bx_end = j;

% -------------------------------------------------------------------------
%ԭͼ�˶�Ŀ��߽����
if(by_start == 1)
    py_start = 1;
else
    py_start = (by_start - 1)*80;
end
py_end = (by_end - 0)*80;
if(bx_start == 1)
    px_start =1;
else
    px_start = (bx_start - 1)*80;
end
px_end = (bx_end - 0)*80;


% -------------------------------------------------------------------------
% ԭͼ�л��˶�Ŀ��ı߽��
frame2(py_start:py_end, px_start,:) = 255;
frame2(py_start:py_end, px_end,:) = 255;
frame2(py_start, px_start:px_end,:) = 255;
frame2(py_end, px_start:px_end,:) = 255;


figure;imshow(frame2);title('��ֵ����');
imwrite(frame2,'frame2_motion.jpg');
imwrite(frame2,'frame2_motion.jpg');




