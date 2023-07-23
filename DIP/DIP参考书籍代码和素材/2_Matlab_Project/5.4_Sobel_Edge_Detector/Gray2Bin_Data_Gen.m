% 打印函数3：Gray输入，Bin输出
%   Gray2Bin_Data_Gen(uint8 img_Gray，uint8 img_Bin)
%   img_Gray：输入待处理的灰度图像
%   img_Bin：输入处理后的二值化数据图像
%   img_Gray.dat：输入待处理的灰度图像hex数据（比对源数据）
%   img_Bin.dat：输入处理完的二值化图像bin数据（比对结果）

function Gray2Bin_Data_Gen(img_Gray,img_Bin)

h1 = size(img_Gray,1);         % 读取图像高度
w1 = size(img_Gray,2);         % 读取图像宽度
h2 = size(img_Bin,1);          % 读取图像高度
w2 = size(img_Bin,2);          % 读取图像宽度

% -------------------------------------------------------------------------
% Simulation Source Data Generate
bar = waitbar(0,'Speed of source data generating...');  %Creat process bar
fid = fopen('.\img_Gray.dat','wt');
for row = 1 : h1
    line_pixel = lower(dec2hex(img_Gray(row,:),2))';
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
fid = fopen('.\img_Bin.dat','wt');
for row = 1 : h2
    line_pixel = lower(dec2hex(img_Bin(row,:),1))';
    str_data_tmp = [];
    for col = 1 : w2
        str_data_tmp = [str_data_tmp,line_pixel(col),' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h2);
end
fclose(fid);
close(bar);   % Close waitbar.
