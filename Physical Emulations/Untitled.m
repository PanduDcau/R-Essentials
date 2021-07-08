
a = [0.45183169, 0.88787902, 1.52754092, 1.93267282, 2.48859568, 2.93201905];
sin_theta = [0.99588920, 0.98344538, 0.96237024, 0.93205422, 0.89156207, 0.83942324];

% sin_theta_2 = [0.508858, 0.572239, 0.628900, 0.722308, 0.773957, 0.849314];
e1 = [0.02, 0.03, 0.06, 0.06, 0.08, 0.1];

% e2 = [0.00002,0.00002,0.00002,0.00002,0.00002,0.00002]; 
%finding the error meassurements
s1=0;
sx1=0;
sy1=0;
sxx1=0;
syy1=0;
sxy1=0;
for i=1:6
    s1=(1/(e1(i).^2))+s1;
    sx1=(sin_theta(i)/(e1(i).^2))+sx1;
    sy1=(a(i)/(e1(i).^2))+sy1;
    sxx1=((sin_theta(i).^2)/(e1(i).^2))+sxx1;
    syy1=((a(i).^2)/(e1(i).^2))+syy1;
    sxy1=((a(i).*sin_theta(i))/(e1(i).^2))+sxy1;
end


% disp(s);% disp(sx);% disp(sy);% disp(sxx);% disp(sxy);
a1=((sxx1*sy1)-(sx1*sxy1))/(s1*sxx1-((sx1)^2));
b1=((s1*sxy1)-(sx1*sy1))/(s1*sxx1-((sx1)^2));
yest1 = a1+b1.*sin_theta;

delta_1 = (s1*sxx1-sx1*sx1);
err_grad0 = s1/delta_1;
err_grad = sqrt(err_grad0);
fprintf('error of the gradient is;\n');
fprintf('(%3f)\n',err_grad);

delta_2 = (s1*syy1-sy1*sy1);
err_int0 = syy1/delta_2;
err_int = sqrt(err_int0);
fprintf('error of the interction is;\n');
fprintf('(%3f)\n',err_int);

plot(sin_theta, a,'gx');
hold on
plot(sin_theta,yest1,'b-');
errorbar(sin_theta,yest1,e1,'ro');
hold off


% p = polyfit(sin_theta, a, 1);
% y = polyval(p, sin_theta);
% p2 = polyfit(lamda,sin_theta_2, 1);
% y2 = polyval(p2, lamda);

% plot(sin_theta, a,'rx');
% hold on
% plot(sin_theta, y, 'b-');
% errorbar(lamda,yest2,e2,'ro');

title('Graph of acceleration vs cos(beta)');
ylabel('acceleration(ms^-2)');
xlabel('cos(beta)');
legend('data points ','best fit line ','error bars for ');

fprintf('The gradient is;\n');
fprintf('(%3f)\n', b1);

fprintf('The intersection is;\n');
fprintf('(%3f)\n',a1);

k = -(0.771722*b1)/9.81;
fprintf('Coefficient of the coefficient of fraction is;\n');
fprintf('(%3f)\n',k);

% print('grdient for n=2')
% m2= (1000000000)*(b2)
% print('d for n=2')
% d2 = 2/m2
% disp(b1);% b is given the Gradient of the curve
% disp(a);% b is given the Intersection of the curve
