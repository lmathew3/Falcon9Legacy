 function [data,CH,mic,config] = loadFalcon9Data(launch,site,data_type,data_path)
%% Function that retreives data stored in .mat files as structured variables for various Falcon 9 launches from Vandenberg AFB.
% Inputs:
%   launch: 'IRIDIUM 7','SAOCOM 1A', or 'RADARSAT Constellation'
%   site: 'North Field' (I7,S1A,RC), 'West Field' (S1A,RC), 'West Field 1'
%   (I7), 'West Field 2' (I7), 'East Field' (RC), 'Miguelito' (RC)
%   data_type: 'Waveform', 'OASPL', 'dSk'
%   data_path: Path to main folder containing the data, ex. 'C:\ASA Falcon 9 Analysis\'
% Outputs:
%   data: Containing structured variable
% Author: Logan Mathews 08 Jul 2020
switch launch
    case 'IRIDIUM 7'
        switch site
            case 'North Field'
                CH = 0;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'IRIDIUM 7\North Field\MAT Files\','IRIDIUM 7_North Field CH0 378A07_COUGAR_',data_type,'.mat']));
            case 'West Field 1'
                CH = 0;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'IRIDIUM 7\West Field 1\MAT Files\','IRIDIUM 7_West Field 1 CH0 378A07_COUGAR_',data_type,'.mat']));
            case 'West Field 2'
                CH = 0;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'IRIDIUM 7\West Field 2\MAT Files\','IRIDIUM 7_West Field 2 CH0 378A07_COUGAR_',data_type,'.mat']));
            otherwise
                warning('The requested site does not exist for the IRIDIUM 7 NEXT launch.')
        end
    case 'SAOCOM 1A'
        switch site
            case 'North Field'
                CH = 3;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'SAOCOM 1A\North Field\MAT Files\','SAOCOM 1A_North Field CH3 378A07_COUGAR_',data_type,'.mat']));
            case 'West Field'
                CH = 4;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'SAOCOM 1A\West Field\MAT Files\','SAOCOM 1A_West Field CH4 378A07_COUGAR_',data_type,'.mat']));
            otherwise
                warning('The requested site does not exist for the SAOCOM 1A launch.')
        end
    case 'RADARSAT Constellation'
        switch site
            case 'North Field'
                CH = 9;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'RADARSAT Constellation\North Field\MAT Files\','RADARSAT Constellation_North Field CH9 378A07_COUGAR_',data_type,'.mat']));
            case 'West Field'
                CH = 0;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'RADARSAT Constellation\West Field\MAT Files\','RADARSAT Constellation_West Field CH0 378A07_COUGAR_',data_type,'.mat']));
            case 'East Field'
                CH = 0;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'RADARSAT Constellation\East Field\MAT Files\','RADARSAT Constellation_East Field CH0 378A07_COUGAR_',data_type,'.mat']));
            case 'Miguelito'
                CH = 0;
                mic = '378A07';
                config = 'COUGAR';
                data = open(fullfile([data_path,'RADARSAT Constellation\Miguelito\MAT Files\','RADARSAT Constellation_Miguelito CH0 378A07_COUGAR_',data_type,'.mat']));
            otherwise
                warning('The requested site does not exist for the RADARSAT Constellation launch.')
        end
    otherwise
        warning('The requested launch does not exist')
end