clear all;
close all;
clc;

%图片读取
    IMG1=imread('D:\Project\FPGA\FPGA\DIP\image\mandril_color.tif');
    h=size(IMG1,1);
    w=size(IMG1,2);
    subplot(221);
    imshow(IMG1);
    title('RGB Image');

%浮点
    IMG1=double(IMG1);
    IMG_YCbCr=zeros(h,w,3);
    for i =1:h
        for j=1:w
            IMG_YCbCr(i,j,1)=bitshift((IMG1(i,j,1)*76+IMG1(i,j,2)*150+IMG1(i,j,3)*29),-8);
            IMG_YCbCr(i,j,2)=bitshift((-IMG1(i,j,1)*43-IMG1(i,j,2)*150+IMG1(i,j,3)*128+32768),-8);
            IMG_YCbCr(i,j,3)=bitshift((IMG1(i,j,1)*128-IMG1(i,j,2)*107+IMG1(i,j,3)*20+32768),-8);
        end
    end
    
    IMG_YCbCr=uint8(IMG_YCbCr);
    %
    subplot(222);
    imshow(IMG_YCbCr(:,:,1));
    title('Y Channel');
    %
    %
    subplot(223);
    imshow(IMG_YCbCr(:,:,2));
    title('Cb Channel');
    %
    %
    subplot(224);
    imshow(IMG_YCbCr(:,:,3));
    title('Cr Channel');
    %

    bar=waitbar(0,'Speed of source data generating...');
    fid=fopen('.\img_RGB.dat','wt');
    for row = 1:h
        r=lower(dec2hex(IMG1(row,:,1),2))';
        g=lower(dec2hex(IMG1(row,:,2),2))';        
        b=lower(dec2hex(IMG1(row,:,3),2))';
        str_data_tmp=[];
        for col =1:w
            str_data_tmp=[str_data_tmp,r(col*2-1:col*2),' ',g(col*2-1:col*2),' ',b(col*2-1:col),' '];
        end
        str_data_tmp=[str_data_tmp,10];
        fprintf(fid,'%s',str_data_tmp);
        waitbar(row/h);
    end
    fclose(fid);
    close(bar);

    bar=waitbar(0,'Speed of source data generating...');
    fid=fopen('.\img_YCbCr.dat','wt');
    for row = 1:h
        Y=lower(dec2hex(IMG_YCbCr(row,:,1),2))';
        Cb=lower(dec2hex(IMG_YCbCr(row,:,2),2))';        
        Cr=lower(dec2hex(IMG_YCbCr(row,:,3),2))';
        str_data_tmp=[];
        for col =1:w
            str_data_tmp=[str_data_tmp,r(col*2-1:col*2),' ',g(col*2-1:col*2),' ',b(col*2-1:col),' '];
        end
        str_data_tmp=[str_data_tmp,10];
        fprintf(fid,'%s',str_data_tmp);
        waitbar(row/h);
    end
    fclose(fid);
    close(bar);

    RGB2YCbCr_Data_Gen(IMG1,IMG_YCbCr);