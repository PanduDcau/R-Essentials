x=-pi:0.1:pi;
y=-pi:0.1:pi;
[X, Y]= meshgrid(x, y);
r = sqrt (x .^ 2 + y .^ 2);
z = sin (r)'* r;
surf(x,y,z);
title ("surface");
colormap(rainbow) %
