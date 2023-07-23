clear all; close all; clc;

sigma_d = 3; sigma_r=0.3;
n=3;
w=floor(n/2);

% ---------------------------------------------------
% 计算n*n高斯模板
G1=zeros(n,n);
for i=-w : w
    for j=-w : w
        G1(i+w+1, j+w+1) = exp(-(i^2 + j^2)/(2*sigma_d^2)) ;
    end
end

% 归一化n*n高斯模板
temp = sum(sum(G1));
G2 = G1/temp;

% n*n高斯模板 *1024定点化
G3 = floor(G2*1024);

% ----------------------------------------------------------------------
fp_gray = fopen('.\Similary_LUT.v','w');
fprintf(fp_gray,'//Sigma_r = %f\n', sigma_r);
fprintf(fp_gray,'module Similary_LUT\n');
fprintf(fp_gray,'(\n');
fprintf(fp_gray,'   input\t\t[7:0]\tPre_Data,\n');
fprintf(fp_gray,'   output\treg\t[9:0]\tPost_Data\n');
fprintf(fp_gray,');\n\n');
fprintf(fp_gray,'always@(*)\n');
fprintf(fp_gray,'begin\n');
fprintf(fp_gray,'\tcase(Pre_Data)\n');
% -----------------------------
% 计算相似度指数*1023结果
Similary_ARRAY = zeros(1,256);
for i = 0 : 255
    temp = exp(-(i/255)^2/(2*sigma_r^2));
    Similary_ARRAY(i+1) = floor(temp*1023);
    fprintf(fp_gray,'\t8''h%s : Post_Data = 10''h%s; \n',dec2hex(i,2), dec2hex(Similary_ARRAY(i+1),3));
end
fprintf(fp_gray,'\tendcase\n');
fprintf(fp_gray,'end\n');
fprintf(fp_gray,'\nendmodule\n');   
fclose(fp_gray);


