clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC video to Matlab
% v = VideoReader('../../0_images/��߸2.mp4'); index =600;
v = VideoReader('../../0_images/��߸3.mp4'); index =185;

frame1 = read(v,index);
frame2 = read(v,index+3);
subplot(221);imshow(frame1);title('ǰһ֡');
subplot(222);imshow(frame2);title('��ǰ֡');

imwrite(frame1,'nezha1.jpg'); 
imwrite(frame2,'nezha2.jpg');
frame1 = rgb2gray(frame1);
frame2 = rgb2gray(frame2);

%˫֡���
frame_diff = abs(frame1-frame2);
subplot(223);imshow(frame_diff);

%��ֵ����
frame_2dim = global_bin_user(frame_diff, 36);
subplot(224);imshow(frame_2dim);




