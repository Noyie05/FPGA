function [B] = Weight(A)

A = abs(A);
a = -0.5;

if (A <= 1)
    B = (a+2)*A^3 - (a+3)*A^2 + 1;
elseif (A < 2)
    B = a*A^3 - 5*a*A^2 + 8*a*A - 4*a;
else
    B = 0;
end

