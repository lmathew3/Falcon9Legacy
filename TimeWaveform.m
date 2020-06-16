% Produces time waveform within a given limit for inspection
% Author: Logan Mathews

pathToFile= 'C:\Users\logan\Downloads\Raw Data-selected';


% Change this to change which round of measurements you're analyzing
filenumber = 100;

% Change the frequency range you'd like to see
minFrequency = 1;
maxFrequency = 10000;

% Data Collection Parameters
signalStart = 29;
eventTime = 119;
eventTimeInData = signalStart + eventTime;
channelToAnalyze = 2;
identifier = 'ID'; % Beginning of each file name
fs = 51200; % Sampling frequency
dt = 1/fs;
ns = 51200; % Number of samples per block
spectrumWidth = 3; % 1/spectrumWidth octave band (ie. 1/3rd octave band)
pref = 20e-6; % Referece pressure for decibel conversion
frequencyLimits = [minFrequency,maxFrequency];

% Now we'll extract the data
testData = binfileload(pathToFile,identifier,filenumber,channelToAnalyze);

totalTime = 158;
timeMatrix = 0:totalTime;

figure
t = dt:dt:length(testData)*dt;
plot(t,testData)
title('Time Waveform')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on 

clippedData = testData((((eventTimeInData-0.5)/dt)+1):((eventTimeInData+0.5)/dt));

figure
t = (dt+eventTime-0.5):dt:(eventTime+0.5);
plot(t,clippedData)
title('Pressure-vs-Time of CASTOR 600 Test from 46AO Near Event [~T+119s] (118 Degrees)')
xlabel('Time (s) [Corrected to true T+ time]')
ylabel('Pressure (Pa)')
grid on 
