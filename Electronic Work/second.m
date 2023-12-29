% Plant transfer function (example)
s = tf('s');
G = 1/(s^2 + 2*s + 1);

% Step response of the plant
t = 0:0.01:10;
[y, ~] = step(G, t);

% Find the ultimate gain and period
[~, idx] = max(y);
Ku = 1 / y(idx);
Pu = t(idx);

% Calculate PID gains using Ziegler-Nichols rules
Kp = 0.6 * Ku;
Ti = Pu / 2;
Td = Pu / 8;

% Create PID controller
C = pid(Kp, Ti, Td);

% Connect plant and controller in closed-loop
sys = feedback(C * G, 1);

% Step response of the closed-loop system
[y_closedloop, t_closedloop] = step(sys, t);

% Plotting
figure;
subplot(2, 1, 1);
plot(t, y);
xlabel('Time');
ylabel('Amplitude');
title('Plant Step Response');
grid on;

subplot(2, 1, 2);
plot(t_closedloop, y_closedloop);
xlabel('Time');
ylabel('Amplitude');
title('Closed-loop Step Response');
grid on;
