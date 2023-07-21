function Q=bin_erosion(IMG) 

[h,w] = size(IMG); 
IMG_Erosion = ones(h,w);    

% -------------------------------------------------------------------------
n=3;
for i=1:h
    for j=1:w
        if(i<(n-1)/2+1 || i>h-(n-1)/2 || j<(n-1)/2+1 || j>w-(n-1)/2)
            IMG_Erosion(i,j) = 0; 	 %±ßÔµÏñËØ²»´¦Àí
        else
			IMG_Erosion(i,j) = IMG(i-1,j-1) & IMG(i-1,j) & IMG(i-1,j+1) &...
                               IMG(i,j-1)   & IMG(i,j)   & IMG(i,j+1)   &...
                               IMG(i+1,j-1) & IMG(i+1,j) & IMG(i+1,j+1);
        end
    end
end

Q = IMG_Erosion;
