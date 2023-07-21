clear all; close all; clc;

% -------------------------------------------------------------------------
% Read PC image to Matlab
frame1 = imread('../../0_images/nezha1.jpg');    % 读取jpg图像
frame2 = imread('../../0_images/nezha2.jpg');    % 读取jpg图像

subplot(221);imshow(frame1);title('前一帧');
subplot(222);imshow(frame2);title('当前帧');

%双帧间差
frame1 = rgb2gray(frame1);
frame2 = rgb2gray(frame2);
frame_diff = abs(frame1-frame2);
subplot(223);imshow(frame_diff);title('差值帧');

%阈值处理
frame_2dim = global_bin_user(frame_diff, 32);
subplot(224);imshow(frame_2dim);;title('阈值32处理');