1;

x=-5:0.01:5
y =@(x) sin(x).cos(x)./(x.*x+1)
dx=0.1;
yval=y(x)
hold on
grid on
plot(x,yval,'b')
x(1001)=[];
plot(x,diff(yval)/dx,'g')

plot(-2-dx,y(-2-dx),'ro','markersize',8)
plot(-2+dx,y(-2+dx),'bo','markersize',8)

dif1 =(y(-2+dx)-y(-2-dx))/dx;
plot(-2,dif1,'oo','markersize',8)

plot(1-dx,y(1-dx),'ro','markersize',8)
plot(1+dx,y(1+dx),'bo','markersize',8)

dif2(y(1+dx,y(1-dx))/dx;

plot(1,dif2,'oo','markersize',8);

legend(*y(x),'diff(y(x))/dx');