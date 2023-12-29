% Create a new Simulink model
model = 'mySimulinkModel';
open_system(new_system(model));

% Add blocks to the Simulink model
add_block('simulink/Sources/Constant', [model '/Constant']);
add_block('simulink/Sinks/Scope', [model '/Scope']);
add_block('simulink/Sinks/To Workspace', [model '/Data']);

% Set block parameters
set_param([model '/Constant'], 'Value', '5');
set_param([model '/Scope'], 'Position', [200, 200, 400, 240]);

% Create a Data Acquisition Toolbox session
session = daq.createSession('ni');

% Configure the session (adjust according to your hardware)
session.addAnalogInputChannel('Dev1', 0, 'Voltage');
session.Rate = 1000; % Set the acquisition rate

% Define the acquisition duration
acquisitionTime = 5; % in seconds

% Start the acquisition
session.startBackground();

% Connect the blocks
add_line(model, 'Constant/1', 'Scope/1');
add_line(model, 'Constant/1', 'Data/1');

% Simulate the model
simTime = 10;
simOut = sim(model, 'SimulationMode', 'accelerator', 'SimulationTime', num2str(simTime));

% Stop the acquisition
session.stop();

% Access the acquired data
data = session.getdata();
time = (0:length(data)-1)' / session.Rate;

% Plot the experimental data
figure;
plot(time, data);
xlabel('Time (s)');
ylabel('Voltage');
title('Experimental Data');

% Save and close the Simulink model
save_system(model);
close_system(model);
