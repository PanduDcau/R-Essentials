##midpoint approaximation of an integral
## func - function
## a - lower limit
## b - upper limit
## n - number of sub intervals

1;


function result = f_midpoint(func,a,b,n)
  result = 0;
  dx = (b-a)/n;
  %dx = f(m(k))
  for k=0:n-1 %sum n rectangles
    
    %m1 = a +fx/2;
    %m2 = a + dx/2 +dx;
    %m3 = a + dx/2 +dx +dx;
    
    mp = func(a +(dx/2) + k*dx);
    result = result + mp;
  endfor
  
  result = result*dx;
  
endfunction

#f_midpoint(@(x) x.^2+2*x - 1,-1,1,10)

f_midpoint(@(x) x.^x,0,pi,10)

%From quad function

quad(@(x) x.^x,0,pi,10);