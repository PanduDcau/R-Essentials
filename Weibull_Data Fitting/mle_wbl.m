i=0;
k=0;
n=20;
r=12;
N=100;
sum=[0,0];
bias=[0,0];
sum_n=[0,0];
bias_n=[0,0];
data=zeros([1,n]);
censor=zeros([1,n]);
total=zeros([100,2]);
total_n=zeros([100,2]);

for k=1:N
	for i=1:n
 		data(i)=wblrnd(100,1,1);
	end
	for i=1:n
		if i<=r
			censor(i)=0;
		else
			censor(i)=1;

		end
	end
	data_n=sort(data);  	
	phat=mle(data,'distribution','wbl','censoring',censor);
	phat_n=mle(data_n,'distribution','wbl','censoring',censor);
	total(k,1:2)=phat;
	total_n(k,1:2)=phat_n;
	sum=sum+phat;
	bias=bias+phat-[100,1];
	sum_n=sum_n+phat_n;
	bias_n=bias_n+phat_n-[100,1];
	
end
mean=sum/N;
mean_n=sum_n/N;
mean_bias=bias/N;
mean_bias_n=bias_n/N;



 	

		

