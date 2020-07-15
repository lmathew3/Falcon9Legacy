clear
pathToData = 'C:\Users\logan\Box\ASA Falcon 9 Analysis\Weather';
addpath(pathToData);

plotStyle('standard','medium',2,1.5,22,'modern')

% launch = 'IRIDIUM 7 NEXT';
% time = 'UTC 11:39';
% data = readmatrix('IRIDIUM_7_NEXT_Radiosonde_Data_Raw_woHeader_25_Jul_2018_UTC1139');

% launch = 'SAOCOM 1A';
% time = 'UTC UNK';
% data = readmatrix('SAOCOM_1A_Radiosonde_Data_Raw_woHeader_07_Oct_2018_UTCUNKNOWN.txt');

launch = 'RADARSAT Constellation';
time = 'UTC 11:15';
data = readmatrix('RADARSAT_Constellation_Radiosonde_Data_Raw_woHeader_12_Jun_2019_UTC1115.txt');

% Column 1: First integer: major level type indicator. It has the following three possible values:
%               1 = Standard pressure level (for levels at 1000, 925, 850,
%                700, 500, 400, 300, 250, 200, 150, 100, 70, 50, 30, 
%                20, 10, 7, 5, 3, 2, and 1 hPa)
%               2 = Other pressure level
%               3 = Non-pressure level
%           Second Integer: major level type indicator. It has the following 
%           three possible values:
%               1 = Standard pressure level (for levels at 1000, 925, 850,
%                 700, 500, 400, 300, 250, 200, 150, 100, 70, 50, 30, 
%                20, 10, 7, 5, 3, 2, and 1 hPa)
%               2 = Other pressure level
%               3 = Non-pressure level
% Column 2: elapsed time since launch. The format is MMMSS, where
% 		MMM represents minutes and SS represents seconds, though
% 		values are not left-padded with zeros. The following special
% 		values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
% Column 3: reported pressure (Pa or mb * 100, e.g., 
% 		100000 = 1000 hPa or 1000 mb). -9999 = missing.
% Column 4: reported geopotential height (meters above sea level).
% 		This value is often not available at variable-pressure levels.
% 		The following special values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
% Column 5: reported temperature (degrees C to tenths, e.g., 
% 		11 = 1.1°C). The following special values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
% Column 6: reported relative humidity (Percent to tenths, e.g., 
% 		11 = 1.1%). The following special values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
% Column 7: reported dewpoint depression (degrees C to tenths, e.g., 
% 		11 = 1.1°C). The following special values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
% Column 8: reported wind direction (degrees from north, 
% 		90 = east). The following special values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
% Column 9:  reported wind speed (meters per second to tenths, e.g., 
% 		11 = 1.1 m/s). The following special values are used:
% 
% 		-8888 = Value removed by IGRA quality assurance, but valid
% 		        data remain at the same level.
% 		-9999 = Value missing prior to quality assurance.
pressure = transpose(data(:,3));
altitude = transpose(data(:,4));
temperature = transpose(data(:,5)).*0.1;
dp = transpose(data(:,7)).*0.1;
wind_dir = transpose(data(:,8));
windspeed = transpose(data(:,9)).*0.1;
%% Constructing Variable Matrices
% Since some variables are missing, we must construct matrices of variables
% that are all recorded.
% Construct Matrix for Altitude-Temperature
j = 1;
for i = 1:length(altitude)
    if (altitude(i) ~= -9999 && round(temperature(i)) ~= -1000)
        at(j,1) = altitude(i);
        at(j,2) = temperature(i);
        j = j + 1;
    end
end

% Construct Matrix for Altitude-Dewpoint Depression
j = 1;
for i = 1:length(altitude)
    if (altitude(i) ~= -9999 && round(dp(i)) ~= -1000)
        ad(j,1) = altitude(i);
        ad(j,2) = dp(i);
        j = j + 1;
    end
end

% Construct Matrix for Altitude-Windspeed-Wind Direction
j = 1;
for i = 1:length(altitude)
    if (altitude(i) ~= -9999 && round(windspeed(i)) ~= -1000 && wind_dir(i) ~= -9999)
        aw(j,1) = altitude(i);
        aw(j,2) = windspeed(i);
        aw(j,3) = wind_dir(i);
        j = j + 1;
    end
end

%% Sort by ascending altitude
at1 = sortrows(at);
ad1 = sortrows(ad);
aw1 = sortrows(aw);
%% Plot results
figure
plot(at1(:,2),at1(:,1).*1e-3)
xlabel('Temperature (°C)')
ylabel('Altitude (km)')
title(['Atmospheric Temperature Profile, ',launch,', ',time])

figure
plot(ad1(:,2),ad1(:,1).*1e-3)
xlabel('Dewpoint Depression (°C)')
ylabel('Altitude (km)')
title(['Atmospheric Dewpoint Profile, ',launch,', ',time])

figure
plot(aw1(:,2),aw1(:,1).*1e-3)
xlabel('Windspeed (m/s)')
ylabel('Altitude (km)')
title(['Atmospheric Windspeed Profile, ',launch,', ',time])

figure
plot(aw1(:,3),aw1(:,1).*1e-3)
xlabel('Wind Direction (degrees)')
ylabel('Altitude (km)')
title(['Atmospheric Wind Direction Profile, ',launch,', ',time])

ns_wind = -aw1(:,2).*cosd(aw1(:,3));
ew_wind = -aw1(:,2).*sind(aw1(:,3));
t = tiledlayout(1,2)
nexttile
plot(ns_wind,aw1(:,1).*1e-3)
xlabel('N-S Windspeed (m/s)')
nexttile
plot(ew_wind,aw1(:,1).*1e-3)
xlabel('E-W Windspeed (m/s)')
ylabel(t,'Altitude (km)')
title(t,['Atmospheric Windspeed Profiles, ',launch,', ',time])

%% Windspeed towards sites
aw = aw1(:,1).*1e-3;

hdg_NF = 51.18;
hdg_WF = 50.40;
hdg_EF = 71.77;
hdg_MG = 100.64;

WS = @(NS,EW,theta) NS.*cosd(theta) + EW.*sind(theta);

WS_NF = WS(ns_wind,ew_wind,hdg_NF);
WS_WF = WS(ns_wind,ew_wind,hdg_WF);
WS_EF = WS(ns_wind,ew_wind,hdg_EF);
WS_MG = WS(ns_wind,ew_wind,hdg_MG);

figure
plot(WS_NF,aw,WS_WF,aw,WS_EF,aw,WS_MG,aw)
xlabel('Windspeed (m/s)')
ylabel('Altitude (km)')
title(['Atmospheric Windspeed Profile, ',launch,', ',time])
legend('North Field','West Field','East Field','Miguelito')
%% Speed of Sound with Temperature
c = @(Tc) 331.*sqrt((Tc + 273.15)./273.15);

c_temp = c(at1(:,2));
figure
plot(c_temp,at1(:,1).*1e-3)
xlabel('Sound Speed (m/s)')
ylabel('Altitude (km)')
title({'Atmospheric Soundspeed Profile', [launch,', ',time]})
legend('North Field','West Field','East Field','Miguelito')
%% Interpolation
% Since the temperature/windspeed data points are on different grids,
% we must interpolate them onto an even grid that matches up.
N = 1000;
dn = 1/N;
grid = dn:dn:30;
WS_NF_INT = interp1(transpose(aw),transpose(WS_NF),grid,'pchip');
WS_WF_INT = interp1(transpose(aw),transpose(WS_WF),grid,'pchip');
WS_EF_INT = interp1(transpose(aw),transpose(WS_EF),grid,'pchip');
WS_MG_INT = interp1(transpose(aw),transpose(WS_MG),grid,'pchip');
c_temp_INT = interp1(transpose(at1(:,1).*1e-3),transpose(c_temp),grid,'pchip');

figure
plot(WS_NF_INT,grid,WS_WF_INT,grid,WS_EF_INT,grid,WS_MG_INT,grid)
xlabel('Windspeed (m/s)')
ylabel('Altitude (km)')
title({'Interpolated Atmospheric Windspeed Profile', [launch,', ',time]})
legend('North Field','West Field','East Field','Miguelito')

figure
plot(c_temp_INT,grid)
xlabel('Sound Speed (m/s)')
ylabel('Altitude (km)')
title({'Atmospheric Soundspeed Profile', [launch,', ',time]})

c_tot_NF = c_temp_INT + WS_NF_INT;
c_tot_WF = c_temp_INT + WS_WF_INT;
c_tot_EF = c_temp_INT + WS_EF_INT;
c_tot_MG = c_temp_INT + WS_MG_INT;
figure
plot(c_tot_NF,grid,c_tot_WF,grid,c_tot_EF,grid,c_tot_MG,grid)
xlabel('Sound Speed (m/s)')
ylabel('Altitude (km)')
title({'Atmospheric Soundspeed Profile', [launch,', ',time]})
legend('North Field','West Field','East Field','Miguelito')

%% Ray Tracing
theta0 = 6:1:10;
[xxf, zzf, ttf, ddf] = raytrace(0,150,theta0,100,grid.*1e3,c_temp_INT,1);