x=-2:0.001:1;
y=(sin(x).*cos(x))./(x.^2+1);

diff(y)./0.001