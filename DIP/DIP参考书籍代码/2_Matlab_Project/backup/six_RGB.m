% 绘制RGB彩色六边形，补充《基于Matlab与FPGA的图像处理教程》第2章的YUV模型的图
% 主要思路：
% 把六边形划分为3个菱形，再使用patch函数填充渐变色
close all;
clear;
clc;

% 定义六边形的6个顶点和中心点坐标，共7个点，格式为矩阵[x1 y1; x2 y2; ...... x7 y7]
vertices_matrix = [0 492; 284 842; 706 776; 849 354; 572 0; 146 65; 425 423]./850*255;

% 定义3个菱形，每个菱形由4个点围成，每个点取自上述定义的坐标
% 矩阵 [1 2 3 7; 3 4 5 7; 5 6 1 7] 的意思是：
% 第1个菱形由第1 2 3 7个点围成
% 第2个菱形由第3 4 5 7个点围成
% 第3个菱形由第5 6 1 7个点围成
% 上述3个菱形同时画出来，就拼接成为所需的六边形，这时可以填充颜色
faces_matrix = [1 2 3 7; 3 4 5 7; 5 6 1 7];

% 定义'y'	'r'	'm'	'b'	'c'	'g'	'w' 共7种颜色，依次为6个顶点和中心点的颜色
colors = [1 1 0;1 0 0;1 0 1;0 0 1;0 1 1;0 1 0;1 1 1];

% 使用patch填充，’interp‘表示颜色插值(渐变)，此函数用法可查看MATLAB文档
patch('Vertices',vertices_matrix,'Faces',faces_matrix,'FaceVertexCData',colors,'FaceColor','interp','EdgeAlpha',0);

% 标题
title('《基于Matlab与FPGA的图像处理教程》');

% 坐标轴显示1：1
axis on
axis equal