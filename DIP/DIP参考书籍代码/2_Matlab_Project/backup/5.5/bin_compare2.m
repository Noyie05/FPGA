function Q=bin_compare2(IMG, thresh0, thresh1) 
%thresh0 为1个数下限
%thresh1 为1个数上线

[h,w] = size(IMG); 
IMG_Comp = ones(h,w);    

% -------------------------------------------------------------------------
n=3;
for i=1:h
    for j=1:w
        if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            IMG_Comp(i,j) = 0; 	%边缘像素不处理
        else
			temp = IMG(i-1,j-1) + IMG(i-1,j) + IMG(i-1,j+1) +...
                   IMG(i,j-1)   + IMG(i,j)   + IMG(i,j+1)   +...
                   IMG(i+1,j-1) + IMG(i+1,j) + IMG(i+1,j+1);
            if(temp >= thresh1)
                IMG_Comp(i,j) = 1;
            elseif(temp < thresh0)
                IMG_Comp(i,j) = 0;
            else
                IMG_Comp(i,j) = IMG(i,j);
            end
        end
    end
end

Q = IMG_Comp;
