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

sig = zz./r;
npotin = r.*zz./r;
npotout = zz./r.^3;

for i=1:ngrid
  for j=1:ngrid 
    if (r(i,j) <= 1.0)
      npotout(i,j) = 0;
    end
    if (r(i,j)) >= 1.0 
        npotin(i,j) = 0;
    end
  end
end

npot = npotin + npotout;

[Ey,Ez]= gradient(-npot,inc,inc);

figure(2)
imagesc(y,z,npotout)
set(gca, 'YDir', 'normal');
 axis([-ymax ymax -zmax zmax], "square");
 box on; axis equal; axis tight;
 xlabel('y','FontSize',14);ylabel('z','FontSize',14);

figure(3)
 h=streamslice(y,z,Ey,Ez);
 set(h,'color','r');
 hold on
 contour(y,z,npot,45)
 axis([-ymax ymax -zmax zmax], "square");
 box on; axis equal; axis tight;
 xlabel('y','FontSize',14);ylabel('z','FontSize',14);
 
