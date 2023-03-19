n=100;
r=90;
data=[1,n];
x=[0:0.1:2];
i=1;

for i=1:n
	data(i)=wblrnd(10,1,1);
end
y1=1./x;
sum1=0;
sum2=0;
sum3=0;
data=sort(data);
for i=1:r
	t=data(i);
	sum1=sum1+(t.^x)*log(t);
	sum2=sum2+t.^x;
	sum3=sum3+log(t);
end
c=data(r);
y2= ((n-r)*log(c)*(c.^x)+sum1)./((n-r)*(c.^x)+sum2) - (sum3/r); 
plot(x,y1,x,y2)
ylim([0,2]);
