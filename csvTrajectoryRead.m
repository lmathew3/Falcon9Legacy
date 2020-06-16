m=xlsread('F9Trajectory.xlsx');
f9Trajectory=transpose(m);
save(fullfile("C:\Users\logan\Box\ASA Falcon 9 Analysis\Matlab","f9Trajectory.mat"), 'f9Trajectory')


m=xlsread('alt_and_downrange_1s.xlsx');
f9AltAndDRD=transpose(m);
save(fullfile("C:\Users\logan\Box\ASA Falcon 9 Analysis\Matlab","f9AltAndDRD.mat"), 'f9AltAndDRD')