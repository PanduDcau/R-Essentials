%defining variables
N=100;
n=5000;
i=0;
k=0;
index=0;
theta=zeros(1,N);
beta=zeros(1,N);

mean_beta=zeros(1,3);
mean_theta=zeros(1,3);
mse_beta=zeros(1,3);
mse_theta=zeros(1,3);

org_theta=1;
org_beta=1;
org_gamma=0;

%For the case NO Censoring

sample=[10 100 1000];
data=rand(5000,1);
data= org_gamma - org_theta*(log(1-(data.^(1/org_beta))));

for index=1:3
  n=sample(index);

  %Repeating the experiment to get better results
  for k=1:N
    data_sample=datasample(data,n,'Replace',false);
    data_sample=sort(data_sample);

    %Calculating Value of Beta
    z=1.0;
    for i=1:1000
      t1=sum(((data_sample(1:n)).^z).*(log(data_sample(1:n))));
      t2=sum((data_sample(1:n)).^z);
      t3=sum(log(data_sample(1:n)))/n;
      z=1/( (t1/t2) - t3);
    end

    beta(k)=z;
    mean_beta(index)=mean_beta(index)+beta(k);
    mse_beta(index)=mean_beta(index)+ (beta(k)-org_beta).^2 ;

    %Calculating Value of Theta
    theta(k)= (sum((data(1:n)).^beta(k))/n).^(1/beta(k));
    mean_theta(index)=mean_theta(index)+theta(k);
    mse_theta(index) =mse_theta(index) +(theta(k)-org_theta).^2;

  end

  %Final Value
  mean_beta(index)=mean_beta(index)/N;
  mean_theta(index)=mean_theta(index)/N;
  mse_beta(index)= sqrt(mse_beta(index)/N);
  mse_theta(index)= sqrt(mse_theta(index)/N);


  %Determining that how goodness of fit
  length= data_sample(n) - data_sample(1);
  length= floor(length)+1;
  range= floor(length/5)+1;
  interval=[0,0.1,0.2,0.3,0.5,0.75,1,1.50,2,data_sample(n)];
  observed=zeros(1,5);
  expected=zeros(1,5);

  for j=1:9
      observed(j)=sum( data_sample > ((interval(j))) & data_sample < (interval(j+1)) );
      expected(j) = n*( exp(-1*((((interval(j)))/mean_theta(index)).^mean_beta(index))) - exp(-1*(((interval(j+1))/mean_theta(index)).^mean_beta(index))) );
  end

  % chi-squared test-statistic
  chi2=sum(((observed-expected).^2)./expected);
  df= 5 ; % degrees of freedom
  prob=1-chi2cdf(chi2,df)

end
