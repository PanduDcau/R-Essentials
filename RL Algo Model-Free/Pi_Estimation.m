N = 1000 #total number of points
n = 0; #points inside the circle

for episode=1:N
  x= rand();
  y= rand();
  if (x^2+y^2 <=1)
    n=n+1;
  endif
 
endfor


pi = 4 * (n/N);
disp( [" When N => is ", num2str(N) , " \n Estimated Pi Value => " , num2str(pi)])
