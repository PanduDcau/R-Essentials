library(MASS);
attach(survey);
height=na.omit(Height);
m =qt(0.975,(length(height)-1)*sd(height)/sqrt(length(height)));
m

ie=mean(height) +c(-m,m);
ie

A=c(2,3,4);
for(i in A)
{
  print(i)
}

myfun<-function(a=1,b=2,c)
{
  return(a+b+c)
}

myfun(10,c=5)
