%% Numerical Launch Vehicle Sound Power Estimation
% Following similar procedures to Matoza et al. (2013)
% Currently using angles 0-90 and "zero padding" 90-180 degrees.
plotStyle()
clear; clc; close all;
%% Axisymmetric area weighting factors for angles and poles
% Leishman et al. 2006
dSPole = @(r,dth) 4.*pi.*r.^2.*sind(dth./4).^2; % Area weighting factor for theta = 0,180 deg.
dSReg = @(r,th,dth) 4.*pi.*r.^2.*sind(th).*sind(dth./2); % Area weighting factor for 0<theta<180 deg.

%% Establish directivity
data_path = 'F:\ASA Falcon 9 Analysis\';
f9IntParams = importdata('f9IntParams.mat');
LIN = 7; % Select location
r0 = f9IntParams(5,LIN); % Radius from launch complex to measurement location
theta = f9IntParams(7,LIN); % Angle from launch complex to measurement location, relative true North
[t,a,distToRocket,downrangeFromSite,angleRelativePlume] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',340,'DistFromPad',r0,'Angle',theta);

data = loadFalcon9Data('RADARSAT Constellation','West Field','OASPL',data_path); % Load OASPL Data
t = data.OASPLData.t; % Load cooresponding time series
OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0); % Distance correct OASPL for spherical spreading to common radius of site at t = 0
%% Plot Directivity
figure
plot(angleRelativePlume(1:length(data.OASPLData.OASPL)),OASPL)
set(gca,'Xdir','reverse')
xlabel('Angle re Plume (Deg)')
ylabel('OASPL (dB re 20\muPa)')
%% Experimental Extrapolation of Data to 180 Degrees
% Note the sharp increase in SPL from 90 to 85 degrees (roughly 0-12 sec)
% This is probably due to terrain shielding and fog, received signal at 
% these angles is diffracted rays and thus has much lower amplitude. In 
% order to get a more accurate representation of directivity, linear 
% extrapolation will be used to approximate OASPL levels out to 180 degrees 
%
% From examining other rockets, it seems like OASPL is equal around 20 and
% 150 degrees, which should give us an approximate value to give a decent
% extrapolation for 85->180 degrees
%
deg_20_ind = find(angleRelativePlume < 20,1,'first'); % Find OASPL at around 20 degrees
OASPL_20 = OASPL(deg_20_ind); % Find OASPL value at approx. 20 deg. re plume
% Take off terrain-shielded data
t = t(15:end);
OASPL = OASPL(15:end);
angleRelativePlume = angleRelativePlume(15:end);
% Add approximate value at 150 degrees for extrapolation
OASPL = [OASPL_20 OASPL];
angleRelativePlume = [150 angleRelativePlume];
theta_grid = 0:1:180; % Setup grid for interpolation and extrapolation
OASPL_interp = interp1(angleRelativePlume(1:length(OASPL)),OASPL,theta_grid,'linear','extrap');
figure
plot(theta_grid,OASPL_interp)
set(gca,'Xdir','reverse')
grid on
xlabel('Angle re Plume (Deg)')
ylabel('OASPL (dB re 20\muPa)')
%% Find point nearest 0 degrees, find dtheta values
zeroInd = find(angleRelativePlume>0,1,'last'); % Find last angle above zero
dth = zeros(zeroInd); % Initialize array for dth values
for i = 1:zeroInd
    if i == 1 % At pole where theta = 0
        dth(i) = angleRelativePlume(i);
    else % Everywhere else, dth is difference between adjoining angles
        dth(i) = angleRelativePlume(i) - angleRelativePlume(i - 1);
    end
end
%% Calculate Area Weighting Factors
pref = 20e-6; % Reference pressure, 20 micropascals
rho = 1.41; % Nominal density of air at STP, 1.41 kg/m^3
c = 340; % Nominal speed of sound at STP, 340 m/s
Wref = 1e-12; % Reference sound power, 1 pW

dS(1) = abs(dSPole(r0,dth(1))); % Find polar area weighting factor
for i = 2:zeroInd % Find other angle area weighting factors
    dS(i) = abs(dSReg(r0,angleRelativePlume(i),dth(i)));
end
%% Compute Sound Power from OASPL values and area weighting factors
% Time averaged intensity Ibar = rms_pressure^2/(rho*c)
Ibar = 10.^(OASPL(1:zeroInd)./10).*pref^2/(rho*c);
% Total sound power W = sum(Ibar(theta)*dS(theta))
W = sum(Ibar.*dS); 
% Sound Power to Sound Power Level
Lw = 10*log10(W/Wref)
