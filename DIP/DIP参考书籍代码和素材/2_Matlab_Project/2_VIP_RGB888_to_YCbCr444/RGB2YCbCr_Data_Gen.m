% 打印函数1：RGB输入，YCbCr输出
% 	RGB2YCbCr_Data_Gen(uinit8 img_RGB, uint8 img_YCbCr)
% 	img_RGB：输入待处理的RGB图像
% 	img_YCbCr：输入处理后的YCbCr图像
% 	img_RGB.dat：输出 待处理的RGB图像hex数据（比对源数据）
% 	img_YCbCr.dat：输出处理完的YCbCr图像hex数据（比对结果）

function RGB2YCbCr_Data_Gen(img_RGB, img_YCbCr)

h1 = size(img_RGB,1);         % 读取图像高度
w1 = size(img_RGB,2);         % 读取图像宽度
h2 = size(img_YCbCr,1);       % 读取图像高度
w2 = size(img_YCbCr,2);       % 读取图像宽度

% -------------------------------------------------------------------------
% Simulation Source Data Generate
bar = waitbar(0,'Speed of source data generating...');  %Creat process bar
fid = fopen('.\img_RGB.dat','wt');
for row = 1 : h1
    r = lower(dec2hex(img_RGB(row,:,1),2))';
    g = lower(dec2hex(img_RGB(row,:,2),2))';
    b = lower(dec2hex(img_RGB(row,:,3),2))';
    str_data_tmp = [];
    for col = 1 : w1
        str_data_tmp = [str_data_tmp,r(col*2-1:col*2),' ',g(col*2-1:col*2),' ',b(col*2-1:col*2),' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h1);
end
fclose(fid);
close(bar);   % Close waitbar


% -------------------------------------------------------------------------
% Simulation Target Data Generate
bar = waitbar(0,'Speed of target data generating...');  %Creat process bar
fid = fopen('.\img_YCbCr.dat','wt');
for row = 1 : h2
    Y  = lower(dec2hex(img_YCbCr(row,:,1),2))';
    Cb = lower(dec2hex(img_YCbCr(row,:,2),2))';
    Cr = lower(dec2hex(img_YCbCr(row,:,3),2))';
    str_data_tmp = [];
    for col = 1 : w2
        str_data_tmp = [str_data_tmp,Y(col*2-1:col*2),' ',Cb(col*2-1:col*2),' ',Cr(col*2-1:col*2),' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h2);
end
fclose(fid);
close(bar);   % Close waitbar