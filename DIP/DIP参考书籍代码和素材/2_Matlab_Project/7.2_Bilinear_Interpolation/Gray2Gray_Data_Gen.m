% 打印函数2：Gray输入，Gray输出
%   Gray2Gray_Data_Gen(uint8 img_Gray1, uint8 img_Gray2)
%   img_Gray1：输入待处理的灰度图像
%   img_Gray2：输入处理后的灰度图像
%   img_Gray1.dat：输出待处理的灰度图像hex数据（比对源数据）
%   img_Gray2.dat：输出处理完的灰度图像hex数据（比对结果）

function Gray2Gray_Data_Gen(img_Gray1,img_Gray2)

h1 = size(img_Gray1,1);         % 读取图像高度
w1 = size(img_Gray1,2);         % 读取图像宽度
h2 = size(img_Gray2,1);         % 读取图像高度
w2 = size(img_Gray2,2);         % 读取图像宽度

% -------------------------------------------------------------------------
% Simulation Source Data Generate
bar = waitbar(0,'Speed of source data generating...');  %Creat process bar
fid = fopen('.\img_Gray1.dat','wt');
for row = 1 : h1
    line_pixel = lower(dec2hex(img_Gray1(row,:),2))';
    str_data_tmp = [];
    for col = 1 : w1
        str_data_tmp = [str_data_tmp,line_pixel(col*2-1:col*2),' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h1);
end
fclose(fid);
close(bar);   % Close waitbar.

% Simulation Target Data Generate
bar = waitbar(0,'Speed of target data generating...');  %Creat process bar
fid = fopen('.\img_Gray2.dat','wt');
for row = 1 : h2
    line_pixel = lower(dec2hex(img_Gray2(row,:),2))';
    str_data_tmp = [];
    for col = 1 : w2
        str_data_tmp = [str_data_tmp,line_pixel(col*2-1:col*2),' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h2);
end
fclose(fid);
close(bar);   % Close waitbar.
