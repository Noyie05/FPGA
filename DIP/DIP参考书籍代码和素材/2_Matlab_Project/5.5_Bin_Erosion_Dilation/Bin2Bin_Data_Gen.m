% 打印函数4：Bin输入，Bin输出
%   Bin2Bin_Data_Gen(uint8 img_Bin1，uint8 img_Bin2)
%   img_Bin1，输入待处理的灰度图像
%   img_Bin2：输入处理后的二值化数据图像
%   img_Bin1.dat：输入待处理的二值化图像bin数据（比对源数据）
%   img_Bin2.dat：输入处理完的二值化图像bin数据（比对结果）

function Bin2Bin_Data_Gen(img_Bin1,img_Bin2)

h1 = size(img_Bin1,1);         % 读取图像高度
w1 = size(img_Bin1,2);         % 读取图像宽度
h2 = size(img_Bin2,1);         % 读取图像高度
w2 = size(img_Bin2,2);         % 读取图像宽度

% -------------------------------------------------------------------------
% Simulation Source Data Generate
bar = waitbar(0,'Speed of source data generating...');  %Creat process bar
fid = fopen('.\img_Bin1.dat','wt');
for row = 1 : h1
     line_pixel = lower(dec2hex(img_Bin1(row,:),1))';
    str_data_tmp = [];
    for col = 1 : w1
        str_data_tmp = [str_data_tmp,line_pixel(col),' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h1);
end
fclose(fid);
close(bar);   % Close waitbar.

% Simulation Target Data Generate
bar = waitbar(0,'Speed of target data generating...');  %Creat process bar
fid = fopen('.\img_Bin2.dat','wt');
for row = 1 : h2
    line_pixel = lower(dec2hex(img_Bin2(row,:),1))';
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

