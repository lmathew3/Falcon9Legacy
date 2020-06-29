clear
pathToData = 'C:\Users\logan\Box\ASA Falcon 9 Analysis\Weather';
addpath(pathToData);

launch = 'IRIDIUM 7 NEXT';
time = 'UTC 11:39';
data = readmatrix('IRIDIUM_7_NEXT_Radiosonde_Data_Raw_woHeader_25_Jul_2018_UTC1139');

% launch = 'SAOCOM 1A';
% time = 'UTC UNK';
% data = readmatrix('SAOCOM_1A_Radiosonde_Data_Raw_woHeader_07_Oct_2018_UTCUNKNOWN.txt');
% 
% launch = 'RADARSAT Constellation';
% time = 'UTC 11:15';
% data = readmatrix('RADARSAT_Constellation_Radiosonde_Data_Raw_woHeader_12_Jun_2019_UTC1115.txt');

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
aw1 = sortrows(aw);
%% Plot results
figure
plot(at1(:,2),at1(:,1).*1e-3)
xlabel('Temperature (°C)')
ylabel('Altitude (km)')
title(['Atmospheric Temperature Profile, ',launch,', ',time])

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

ns_wind = aw1(:,2).*cosd(aw1(:,3));
ew_wind = aw1(:,2).*sind(aw1(:,3));
t = tiledlayout(1,2)
nexttile
plot(ns_wind,aw1(:,1).*1e-3)
xlabel('N-S Windspeed (m/s)')
nexttile
plot(ew_wind,aw1(:,1).*1e-3)
xlabel('E-W Windspeed (m/s)')
ylabel(t,'Altitude (km)')
title(t,['Atmospheric Windspeed Profiles, ',launch,', ',time])


        