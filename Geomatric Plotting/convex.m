alpha=rand(1,100);

b=13;
x=0;
convex=1;

for n=1:length(alpha)
  c=alpha(n)+x;
  if(c>b)
  convex=0;
  break;
endif

endfor

if(!convex)
disp('c is bigger');
else
disp('c not biger');
endif