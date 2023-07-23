function [img2] = Bicubic_Interpolation(img1,row_num1,col_num1,row_num2,col_num2)

% 扩展图像是为了后面插值时避免越界
img1 = [img1;img1(row_num1,:);img1(row_num1,:)];    %   底部扩展两行，直接拷贝最后一行
img1 = [img1(1,:);img1];                            %   顶部扩展一行，直接拷贝第一行
img1 = [img1,img1(:,col_num1),img1(:,col_num1)];    %   右侧扩展两列，直接拷贝最后一列
img1 = [img1(:,1),img1];                            %   左侧扩展一列，直接拷贝第一列

img1 = double(img1);

x_ratio = col_num1/col_num2;
y_ratio = row_num1/row_num2;

for i = 1 : row_num2
    y  = fix((i-1)*y_ratio) + 2;
    dv = (i-1)*y_ratio - fix((i-1)*y_ratio);
    A  = [Weight(1+dv),Weight(dv),Weight(1-dv),Weight(2-dv)];
    for j = 1 : col_num2
        x  = fix((j-1)*x_ratio) + 2;
        du = (j-1)*x_ratio - fix((j-1)*x_ratio);
        C  = [Weight(1+du);Weight(du);Weight(1-du);Weight(2-du)];
        B  = img1(y-1:y+2,x-1:x+2);
        img2(i,j) = A*B*C;
    end
end
img2 = uint8(img2);
