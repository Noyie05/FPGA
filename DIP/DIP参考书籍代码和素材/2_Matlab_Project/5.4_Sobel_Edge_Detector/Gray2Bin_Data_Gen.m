% ��ӡ����3��Gray���룬Bin���
%   Gray2Bin_Data_Gen(uint8 img_Gray��uint8 img_Bin)
%   img_Gray�����������ĻҶ�ͼ��
%   img_Bin�����봦���Ķ�ֵ������ͼ��
%   img_Gray.dat�����������ĻҶ�ͼ��hex���ݣ��ȶ�Դ���ݣ�
%   img_Bin.dat�����봦����Ķ�ֵ��ͼ��bin���ݣ��ȶԽ����

function Gray2Bin_Data_Gen(img_Gray,img_Bin)

h1 = size(img_Gray,1);         % ��ȡͼ��߶�
w1 = size(img_Gray,2);         % ��ȡͼ����
h2 = size(img_Bin,1);          % ��ȡͼ��߶�
w2 = size(img_Bin,2);          % ��ȡͼ����

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
