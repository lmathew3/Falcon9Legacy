function [t,a,distToRocket,downrangeFromSite,angleRelativePlume] = getRocketTrajectory(launch,varargin)
    % Parse inputs
    p = inputParser;
    p.addParameter('SoundSpeed',340);
    p.addParameter('DistFromPad',0);
    p.addParameter('Angle',0);
    p.parse(varargin{:});
    
    % Assigning optional inputs
    c = p.Results.SoundSpeed; % Sound speed for correcting for retarted time
    r0 = p.Results.DistFromPad; % Initial radius from launch pad to measurement location, for retarted time calculation.
    theta0 = p.Results.Angle; % Angle from measurement location to launch pad relative to north.
    % Error check and assign parameters input for launch specifier
    switch launch
        case {'IRIDIUM 7 NEXT','IRIDIUM 7','iridium 7','iridium 7 next','I7N','I7','i7n','i7'}
            launch_trajectory = 1;
        case {'SAOCOM 1A','saocom 1a','S1A','s1a'}
            launch_trajectory = 2;
        case {'RADARSAT Constellation','radarsat constellation','RADARSAT','radarsat','RC','rc'} 
            launch_trajectory = 3;
        otherwise
            warning('Unknown launch.')
    end
    
    switch launch_trajectory
        case 1
            data = transpose(xlsread('IRIDIUM7_Analyzed_Telemetry_Data.xlsx')); % Load trajectory data
            t = data(1,:); % Time series (s)
            a = data(3,:).*1e3; % Cooresponding altitudes of rocket (m)
            d = data(7,:).*1e3; % Cooresponding downrange distance (m), from pad.
            theta = data(8,:); % Cooresponding angle relative to the horizon (degrees)
            
            [distToRocket,downrangeFromSite] = distCalc(r0,theta0,d,a,1,0); % Finding downrange distance from site and straightline distance to rocket.
            angleRelativePlume = asind(downrangeFromSite./distToRocket) - (90-theta); % Calculating angle relative to the rocket exhaust from measurement site.

            t = t + distToRocket./c - r0/c; % Adjusting time to time-retarded.

            % We now have trajectory data aligned with retarted time (at
            % measurement location), however, it is on an uneven time grid.
            % We will use interpolation to place the data on an evenly
            % spaced time grid using 'pchip' shape-preserving method.

            told = t;
            N = floor(t(end)); % End value of time series
            dn = 1; % Spacing between time points, s.
            t = dn:dn:N; % Even time grid (will be the new t)

            % Interpolate quantitites
            a = interp1(told,a,t,'pchip');
            distToRocket = interp1(told,distToRocket,t,'pchip');
            downrangeFromSite = interp1(told,downrangeFromSite,t,'pchip');
            angleRelativePlume = interp1(told,angleRelativePlume,t,'pchip');
        case 2
        case 3
    end
end
    
    
    