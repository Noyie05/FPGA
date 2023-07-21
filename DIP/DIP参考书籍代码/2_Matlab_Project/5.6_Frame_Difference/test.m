clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC video to Matlab
% v = VideoReader('../../0_images/哪吒2.mp4'); index =600;
v = VideoReader('../../0_images/哪吒3.mp4'); index =185;

frame1 = read(v,index);
frame2 = read(v,index+3);
subplot(221);imshow(frame1);title('前一帧');
subplot(222);imshow(frame2);title('当前帧');

imwrite(frame1,'nezha1.jpg'); 
imwrite(frame2,'nezha2.jpg');
frame1 = rgb2gray(frame1);
frame2 = rgb2gray(frame2);

%双帧间差
frame_diff = abs(frame1-frame2);
subplot(223);imshow(frame_diff);

%阈值处理
frame_2dim = global_bin_user(frame_diff, 36);
subplot(224);imshow(frame_2dim);




