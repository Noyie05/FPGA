clear all;
close all;
I=imread('../../images/Lenna.jpg');
%调用函数方法 graythresh()
level=graythresh(I);
bw=im2bw(I,level);
imshow(bw);

%详细的代码
imax=max(max(I));
imin=min(min(I));
T=double(imin:imax);
[m n]=size(I);
num=m*n;

for i=1:length(T)
    tk=T(1,i);
    ifg=0;
    ibg=0;
    fnum=0;
    bnum=0;
    for k=1:m
        for j=1:n
            tmp=I(k,j);
            if(tmp>=tk)
                ifg=ifg+1;
                bnum=bnum+double(tmp);
            else
                ibg=ibg+1;
                bnum=bnum+double(tmp);
            end
        end
    end
    wo=ifg/num;
    w1=ibg/num;
    u0=fnum/ifg;
    u1=bnum/ibg;
    T(2,i)=wo*w1*(u0-u1)*(u0-u1);
end
outmax=max(T(2,:));
idenx=find(T(2,:)>=outmax);
T=uint8(T(1,idenx));
bw1=im2bw(I,T(2)/255);
imshow(bw1);