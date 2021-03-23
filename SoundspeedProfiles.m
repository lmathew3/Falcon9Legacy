pathToData = 'E:\ASA Falcon 9 Analysis\Weather';
addpath(pathToData);
plotStyle('FontStyle','classic','FontSize',16,'ColorScheme',1,'AspectRatio','square','PlotSize','small','Orientation','portrait')
% plotStyle('standard','medium',2,1.5,22,'modern')

data1 = readmatrix('IRIDIUM_7_NEXT_Radiosonde_Data_Raw_woHeader_25_Jul_2018_UTC1139');

data2 = readmatrix('SAOCOM_1A_Radiosonde_Data_Raw_woHeader_07_Oct_2018_UTCUNKNOWN.txt');

data3 = readmatrix('RADARSAT_Constellation_Radiosonde_Data_Raw_woHeader_12_Jun_2019_UTC1115.txt');

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


a1 = transpose(data1(:,4));
t1 = transpose(data1(:,5)).*0.1;
j = 1;
for i = 1:length(a1)
    if (a1(i) ~= -9999 && round(t1(i)) ~= -1000)
        fa1(j,1) = a1(i);
        ft1(j,1) = t1(i);
        j = j + 1;
    end
end
c1 = 330*sqrt((ft1+273.15)/273.15);
grid1 = fa1(1):fa1(end);
c1interp = interp1(transpose(fa1),transpose(c1),grid1,'pchip');

a2 = transpose(data2(:,4));
t2 = transpose(data2(:,5)).*0.1;
j = 1;
for i = 1:length(a2)
    if (a2(i) ~= -9999 && round(t2(i)) ~= -1000)
        fa2(j,1) = a2(i);
        ft2(j,1) = t2(i);
        j = j + 1;
    end
end
c2 = 330*sqrt((ft2+273.15)/273.15);
grid2 = fa2(1):fa2(end);
c2interp = interp1(transpose(fa2),transpose(c2),grid2,'pchip');

a3 = transpose(data3(:,4));
t3 = transpose(data3(:,5)).*0.1;
j = 1;
for i = 1:length(a3)
    if (a3(i) ~= -9999 && round(t3(i)) ~= -1000)
        fa3(j,1) = a3(i);
        ft3(j,1) = t3(i);
        j = j + 1;
    end
end

% Construct Matrix for Altitude-Windspeed-Wind Direction

c3 = 330*sqrt((ft3+273.15)/273.15);
grid3 = fa3(1):fa3(end);
c3interp = interp1(transpose(fa3),transpose(c3),grid3,'pchip');

figure
plot(c1interp,grid1/1000,c2interp,grid2/1000,c3interp,grid3/1000)
xlabel('Sound Speed (m/s)')
ylabel('Altitude (km)')
legend('IRIDIUM 7 NEXT','SAOCOM 1A','RADARSAT Constellation')
ylim([0 20])