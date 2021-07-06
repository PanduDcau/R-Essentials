1;
function [x,y,t] = f_trajectory(h =5,g = 9.81,v = 25,theta = pi/4,t=[])

t = 0:0.1:5;

#declaring the Equations

x = v*cos(theta).*t;
y = h+v*sin(theta).*t-0.5*g.*t.*t;


endfunction


function [x,y,t] = traject()
  [x,y,t] = f_trajectory();
  
  endfunction

  
[x,y,t]=traject()

hold on
subplot(1,2,1);
plot(t,x,'r--',t,y,'g--');
grid on
xlabel('Time');
ylabel('Distance/Height');
subplot(1,2,2);
plot3(t,x,y,'b--');
grid on
xlabel('t');
ylabel('x(t)');
zlabel('y(t)');
axis on
hold off

