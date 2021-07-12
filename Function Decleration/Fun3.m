1;

function [l] = min(u,v,r,I,i,m,k,s)
  l=(u*v/2*r*atan(m))^2*i^2-(I*u*v/2*r^2*atan(m))^2*k^2- (I*u*v/2*r*acos(m))^2*s^2
endfunction

[l]=min(1.2566*10^-6,3,0.18,5,0.00326,75,0.005,0.4619)