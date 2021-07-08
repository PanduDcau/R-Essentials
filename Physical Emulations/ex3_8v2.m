clc
clear all
%close all 

ngrid = 201; %200 for potential
ymax = 3;
zmax = ymax; 
inc=2*ymax/ngrid;

y = linspace(-ymax,ymax,ngrid);
z = linspace(-zmax,zmax,ngrid);
[yy zz] = meshgrid(y,z);
r = sqrt(yy.^2+zz.^2);
theta = acos(yy./zz);

npot = 5 - (r-(1^3./r.^2)).*zz./r;
for i=1:ngrid
  for j=1:ngrid 
    if (r(i,j) <= 1.0)
      npot(i,j) = 0;
    end
  end
end

[Ey,Ez]= gradient(-npot,inc,inc);

figure(1)
 h=streamslice(y,z,Ey,Ez);
 set(h,'color','r');
 hold on
 contour(y,z,npot,45)
 axis([-ymax ymax -zmax zmax], "square");
 box on; axis equal; axis tight;
 xlabel('x','FontSize',14);ylabel('y','FontSize',14);
 
