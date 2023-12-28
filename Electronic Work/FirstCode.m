% Ziegler-Nichols Method for PID Controller Tuning

% Plant Transfer Function (Update with your own plant transfer function)
num = [1];
den = [1 2 1];
G = tf(num, den);

% Step 1: Open-loop test
t = 0:0.01:10;  % Time vector for the open-loop test
u = 1*ones(size(t));  % Step input
y = lsim(G, u, t);  % Plant response to the step input

% Step 2: Calculate the ultimate gain and period
[~, idx] = max(y);  % Index of the peak response
Tu = t(idx);  % Ultimate period
Ku = max(y);  % Ultimate gain

% Step 3: Calculate the controller gains
Kp = 0.6 * Ku;
Ti = 0.5 * Tu;
Td = 0.125 * Tu;

% PID Controller Transfer Function
C = pid(Kp, Ti, Td);

% Step 4: Plot the results
t_sim = 0:0.01:20;  % Time vector for the simulation
u_sim = 1*ones(size(t_sim));  % Step input for the simulation
sys_cl = feedback(C*G, 1);
y_sim = lsim(sys_cl, u_sim, t_sim);  % Response of the closed-loop system

figure;
plot(t_sim, y_sim, 'b', 'LineWidth', 2);
hold on;
plot([0, max(t_sim)], [1, 1], 'r--', 'LineWidth', 1);
title('Ziegler-Nichols Method - Step Response');
xlabel('Time');
ylabel('Output');
legend('System Response', 'Setpoint');
grid on;
