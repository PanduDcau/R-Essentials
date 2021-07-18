1;

function result=f_midpoint(func,a,b,n)
  
  result=0;
  dx=(b-a)/n;
  
  for k=0:n-1
    
    mp=func(a+ (dx/2)+k*dx);
    result=result+mp;
  endfor
  
  result=result*dx;
endfunction


function y=fx(x)
  
  y=x.^2+2*x-1;
endfunction

disp("midpoint function result: ");
f_midpoint(@fx,-1,1,10)

disp("\n");

disp("quad function result: ");
quad(@fx,-1,1)