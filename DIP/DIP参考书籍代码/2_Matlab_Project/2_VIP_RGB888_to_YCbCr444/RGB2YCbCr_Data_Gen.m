% ��ӡ����1��RGB���룬YCbCr���
% 	RGB2YCbCr_Data_Gen(uinit8 img_RGB, uint8 img_YCbCr)
% 	img_RGB������������RGBͼ��
% 	img_YCbCr�����봦����YCbCrͼ��
% 	img_RGB.dat����� �������RGBͼ��hex���ݣ��ȶ�Դ���ݣ�
% 	img_YCbCr.dat������������YCbCrͼ��hex���ݣ��ȶԽ����

function RGB2YCbCr_Data_Gen(img_RGB, img_YCbCr)

h1 = size(img_RGB,1);         % ��ȡͼ��߶�
w1 = size(img_RGB,2);         % ��ȡͼ����
h2 = size(img_YCbCr,1);       % ��ȡͼ��߶�
w2 = size(img_YCbCr,2);       % ��ȡͼ����

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