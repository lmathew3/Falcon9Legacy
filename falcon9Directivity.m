data_path = 'F:\ASA Falcon 9 Analysis\';
f9IntParams = importdata('f9IntParams.mat');
launch = 'RADARSAT Constellation';
LIN = 7; % Select location
r0 = f9IntParams(5,LIN); % Radius from launch complex to measurement location
theta = f9IntParams(7,LIN); % Angle from launch complex to measurement location, relative true North
[t,a,distToRocket,downrangeFromSite,angleRelativePlume] = getRocketTrajectory(launch,'SoundSpeed',340,'DistFromPad',r0,'Angle',theta,'ZeroPad',5);

data = loadFalcon9Data(launch,'North Field','Waveform',data_path); % Load Waveform Data
t = data.waveformData.t; % Load cooresponding time series
x = data.waveformData.p;
fs = data.waveformData.fs;

filtered = filterData(x,20,fs,'high','FilterOrder',4);
pref = 20e-6;

averagingPeriod = 2; % Period to average blocks over, in seconds.
nsx = fs*averagingPeriod;
dtx = 1/nsx;
pct = 50;
fsx = averagingPeriod * 0.01 * pct;
[sigma,~,~,~,~,~,t_SPL] = runningstats(x,nsx,fs,pct);
[sigma_filtered,~,~,~,~,~,t_SPL] = runningstats(filtered,nsx,fs,pct);

OASPL = 20.*log10(sigma./pref);
OASPL_filtered = 20.*log10(sigma_filtered./pref);

OASPL = OASPL + 20.*log10(distToRocket(1:length(OASPL))./r0); % Distance correct OASPL for spherical spreading to common radius of site at t = 0
OASPL = OASPL_filtered + 20.*log10(distToRocket(1:length(OASPL_filtered))./r0);
%%
figure
plot(angleRelativePlume(1:length(OASPL)),OASPL,angleRelativePlume(1:length(OASPL_filtered)),OASPL_filtered)
xlabel('Angle re Plume (Deg)')
ylabel('OASPL (dB re 20/muPa)')
set(gca,'Xdir','reverse')
legend('Unfiltered Data','High Pass Filtered, f_c= 20 Hz','Location','SouthEast')
xlim([0 90])