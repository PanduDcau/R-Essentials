1;

function [l] = min(V,U,I,v,u,i)
  l=(1/(2*pi*V*U))^2.*((i)^2 + ((I/U)*u)^2 +((I/V)*v)^2)
endfunction

[l]=min(921.9858,0.626*10^3,582*10^-4,50,0.4246,15)