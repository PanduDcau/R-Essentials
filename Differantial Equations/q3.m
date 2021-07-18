pkg load io
[n,t,r]=xlsread('dist_1.xlsx');

for k=1:length(n)
  
  place=r{1,k+1};
  distance=n(3,k);
  
  printf("from colombo to %s => %d Kms\n",place,distance);
  
endfor



