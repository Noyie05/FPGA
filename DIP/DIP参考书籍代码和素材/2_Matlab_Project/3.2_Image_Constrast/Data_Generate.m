clear all; close all; clc;

THRESHOLD = 127;
E = 7;

fp_gray = fopen('.\Curve_Contrast_Array.v','w');
fprintf(fp_gray,'//Curve THRESHOLD = %d, E = %d\n', THRESHOLD, E);
fprintf(fp_gray,'module Curve_Contrast_Array\n');
fprintf(fp_gray,'(\n');
fprintf(fp_gray,'   input\t\t[7:0]\tPre_Data,\n');
fprintf(fp_gray,'   output\treg\t[7:0]\tPost_Data\n');
fprintf(fp_gray,');\n\n');
fprintf(fp_gray,'always@(*)\n');
fprintf(fp_gray,'begin\n');
fprintf(fp_gray,'\tcase(Pre_Data)\n');
Gray_ARRAY = zeros(1,256);
for i = 1 : 256
    Gray_ARRAY(1,i) = (1./(1 + (THRESHOLD./(i-1)).^E)) * 255;
    Gray_ARRAY(1,i) = uint8(Gray_ARRAY(1,i));
    fprintf(fp_gray,'\t8''h%s : Post_Data = 8''h%s; \n',dec2hex(i-1,2), dec2hex(Gray_ARRAY(1,i),2));
end
fprintf(fp_gray,'\tendcase\n');
fprintf(fp_gray,'end\n');
fprintf(fp_gray,'\nendmodule\n');   
fclose(fp_gray);

% -----------------------------------------------------------------------
% 打印变形后的映射数组Gray_ARRAY
reshape(Gray_ARRAY,16,16)