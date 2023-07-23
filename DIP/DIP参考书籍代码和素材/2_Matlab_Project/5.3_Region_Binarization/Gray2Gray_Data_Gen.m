% ��ӡ����2��Gray���룬Gray���
%   Gray2Gray_Data_Gen(uint8 img_Gray1, uint8 img_Gray2)
%   img_Gray1�����������ĻҶ�ͼ��
%   img_Gray2�����봦���ĻҶ�ͼ��
%   img_Gray1.dat�����������ĻҶ�ͼ��hex���ݣ��ȶ�Դ���ݣ�
%   img_Gray2.dat�����������ĻҶ�ͼ��hex���ݣ��ȶԽ����

function Gray2Gray_Data_Gen(img_Gray1,img_Gray2)

h1 = size(img_Gray1,1);         % ��ȡͼ��߶�
w1 = size(img_Gray1,2);         % ��ȡͼ����
h2 = size(img_Gray2,1);         % ��ȡͼ��߶�
w2 = size(img_Gray2,2);         % ��ȡͼ����

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
