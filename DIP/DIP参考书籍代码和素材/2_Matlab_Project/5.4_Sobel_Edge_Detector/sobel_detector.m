function Q=sobel_detector(IMG,thresh) 

[h,w] = size(IMG); 
Q = ones(h,w);

% -------------------------------------------------------------------------
%         Gx                  Gy				  Pixel
% [   -1  0   +1  ]   [   -1  -2   -1 ]     [   P1  P2   P3 ]
% [   -2  0   +2  ]   [   0   0    0  ]     [   P4  P5   P6 ]
% [   -1  0   +1  ]   [   +1  +2   +1 ]     [   P7  P8   P9 ]
Sobel_X = [-1, 0, 1, -2, 0, 2, -1, 0, 1];   % Weight x
Sobel_Y = [-1,-2,-1,  0, 0, 0,  1, 2, 1];   % Weight y

IMG_Gray = double(IMG);    
IMG_Sobel = ones(h,w);    

n=3;
for i=1 : h
    for j=1:w
        if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            IMG_Sobel(i,j) = 0; 	 %±ßÔµÏñËØ²»´¦Àí
        else
            temp1 = Sobel_X(1) * IMG_Gray(i-1,j-1) 	+ Sobel_X(2) * IMG_Gray(i-1,j)	+ Sobel_X(3) * IMG_Gray(i-1,j+1) +...
                    Sobel_X(4) * IMG_Gray(i,j-1) 	+ Sobel_X(5) * IMG_Gray(i,j) 	+ Sobel_X(6) * IMG_Gray(i,j+1) +...
                    Sobel_X(7) * IMG_Gray(i+1,j-1) 	+ Sobel_X(8) * IMG_Gray(i+1,j)	+ Sobel_X(9) * IMG_Gray(i+1,j+1);
            temp2 = Sobel_Y(1) * IMG_Gray(i-1,j-1)	+ Sobel_Y(2) * IMG_Gray(i-1,j)	+ Sobel_Y(3) * IMG_Gray(i-1,j+1) +...
                    Sobel_Y(4) * IMG_Gray(i,j-1) 	+ Sobel_Y(5) * IMG_Gray(i,j) 	+ Sobel_Y(6) * IMG_Gray(i,j+1) +...
                    Sobel_Y(7) * IMG_Gray(i+1,j-1) 	+ Sobel_Y(8) * IMG_Gray(i+1,j)	+ Sobel_Y(9) * IMG_Gray(i+1,j+1);
            temp3 = sqrt(temp1^2 + temp2^2);
            if(uint8(temp3) > thresh)
                IMG_Sobel(i,j) = 1;
            else
                IMG_Sobel(i,j) = 0; 
            end
        end
    end
end

Q=IMG_Sobel;
