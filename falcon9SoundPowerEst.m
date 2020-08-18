%% Numerical Launch Vehicle Sound Power Estimation
% Following similar procedures to Matoza et al. (2013)
% Currently using angles 0-90 and "zero padding" 90-180 degrees.
plotStyle()
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

%% Find point nearest 0 degrees, find dtheta values
zeroInd = find(angleRelativePlume>0,1,'last'); % Find last angle above zero
dth = zeros(zeroInd);
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
% Time averaged intensity Ibar = prms^2/(rho*c)
Ibar = 10.^(OASPL(1:zeroInd)./10).*pref^2/(rho*c);
% Total sound power W = sum(Ibar(theta)*dS(theta))
W = sum(Ibar.*dS); 
% Sound Power to Sound Power Level
Lw = 10*log10(W/Wref)
