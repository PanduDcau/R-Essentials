% Define the parameters for the waves
amplitude = 1;          % Amplitude of the waves
frequency = 1;          % Frequency of the waves
phase = 0;              % Phase of the waves
samplingRate = 1000;    % Sampling rate (number of samples per second)
duration = 1;           % Duration of the waves (in seconds)

% Calculate the time vector
t = linspace(0, duration, duration * samplingRate);

% Generate the sine wave
sineWave = amplitude * sin(2*pi*frequency*t + phase);

% Generate the cosine wave
cosineWave = amplitude * cos(2*pi*frequency*t + phase);

% Plot the waves
plot(t, sineWave, 'b', t, cosineWave, 'r');
xlabel('Time');
ylabel('Amplitude');
grid on;
