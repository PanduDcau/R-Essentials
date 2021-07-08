
a = [0.1, 0.2, 0.3, 0.4, 0.5];
sin_theta = [4.75,0.796,-2.45,-9.48,-15.263];
% sin_theta_2 = [0.508858, 0.572239, 0.628900, 0.722308, 0.773957, 0.849314];
% e1 = [0.02, 0.03, 0.06, 0.06, 0.08, 0.1];
% e2 = [0.00002,0.00002,0.00002,0.00002,0.00002,0.00002]; 
%finding the error meassurements
% s1=0;
% sx1=0;
% sy1=0;
% sxx1=0;
% syy1=0;
% sxy1=0;
% for i=1:6
%     s1=(1/(e1(i).^2))+s1;
%     sx1=(sin_theta(i)/(e1(i).^2))+sx1;
%     sy1=(a(i)/(e1(i).^2))+sy1;
%     sxx1=((sin_theta(i).^2)/(e1(i).^2))+sxx1;
%     syy1=((a(i).^2)/(e1(i).^2))+syy1;
%     sxy1=((a(i).*sin_theta(i))/(e1(i).^2))+sxy1;
% end

% disp(s);% disp(sx);% disp(sy);% disp(sxx);% disp(sxy);
% a1=((sxx1*sy1)-(sx1*sxy1))/(s1*sxx1-((sx1)^2));
% b1=((s1*sxy1)-(sx1*sy1))/(s1*sxx1-((sx1)^2));
% yest1 = a1+b1.*sin_theta;

% delta_1 = (s1*sxx1-sx1*sx1);
% err_grad0 = s1/delta_1;
% err_grad = sqrt(err_grad0);
% fprintf('error of the gradient is;\n');
% fprintf('(%3f)\n',err_grad);

% delta_2 = (s1*syy1-sy1*sy1);
% err_int0 = syy1/delta_2;
% err_int = sqrt(err_int0);
% fprintf('error of the interction is;\n');
% fprintf('(%3f)\n',err_int);

% plot(sin_theta, a,'gx');
% hold on
% plot(sin_theta,yest1,'b-');
% errorbar(sin_theta,yest1,e1,'ro');
% hold off


p = polyfit(sin_theta, a, 1);
y = polyval(p, sin_theta);
% p2 = polyfit(lamda,sin_theta_2, 1);
% y2 = polyval(p2, lamda);

plot(sin_theta, a,'rx');
hold on
plot(sin_theta, y, 'b-');
% errorbar(lamda,yest2,e2,'ro');

title('Graph of Percentage difference in weight(%) vs Molality of the solution(M)');
ylabel('Percentage difference in weight(%)');
xlabel('Molality of the solution(M)');
legend('data points ','best fit line');

a1 = p(2);
b1 = p(1);

fprintf('The gradient is;\n');
fprintf('(%3f)\n', b1);

fprintf('The intersection is;\n');
fprintf('(%3f)\n',a1);

% k = (9.81/ b1) - 1;
% fprintf('Coefficient of the moment of innertia is;\n');
% fprintf('(%3f)\n',k);

% print('grdient for n=2')
% m2= (1000000000)*(b2)
% print('d for n=2')
% d2 = 2/m2
% disp(b1);% b is given the Gradient of the curve
% disp(a);% b is given the Intersection of the curve
