function [img2] = Nearest_Interpolation_Int(img1,h1,w1,h2,w2)

x_ratio = floor(w1/w2*2^16)/2^16;
y_ratio = floor(h1/h2*2^16)/2^16;

for i = 1 : h2
    y = 1+round((i-1)*y_ratio);
    for j = 1 : w2
        x = 1+round((j-1)*x_ratio);
        img2(i,j) = img1(y,x);
    end
end

