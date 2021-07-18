x=-2:0.001:1;
y=(sin(x).*cos(x))./(x.^2+1);

h=diff(y)./0.001

plot(x,y,'r.*','markersize',8);
legend('diff(y(x))/dx');
