pkg load io
[a,b,c]=xlsread('dist_1.xlsx');
s=size(b)(1);
for(k=2:s)
if(a(3,:)(k-1)!=0)
printf("Colombo to %s distance is %d \n",b{k,1},a(3,:)(k-1))
endif
endfor