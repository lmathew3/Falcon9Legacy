function filtered = filterData(x,f_filter,fs,filterType,varargin)
% filtered = filterData(x,f_filter,fs,filterType,varargin)
% Function that creates and applies a custom order Butterworth filter to data
% INPUTS:
%   x - Time series data

%   f_filter - Cutoff/pass/stop frequency for filter design. For high and
%   low pass filter designs, this is a single frequency. For bandpass and
%   bandstop filters, this is an array with the lower and upper cutoffs. 

%   fs - Sampling frequency of time-series data

%   filterType - Type of filter to construct: 'high' (high pass),
%                'low' (low pass),'bandpass' (band pass),'stop' (band stop)
%  OPTIONAL INPUTS
%   'FilterOrder' - Specifies order of butterworth filter to use. Default
%   is 2nd order. To specify, add arguments 'FilterOrder',n to the function
%   inputs where n is the integer order of filter. The order of the filter
%   determines how quickly the filter rolls off. A first-order filter
%   tapers off at -6 dB per octave and a second-order rolls off at -12 dB
%   per decade. More generally, an nth order Butterworth filter rolls off
%   at -6*n dB per octave.
%
%   'ZeroPhaseDist' - Option to use filtfilt zero-phase distortion digital
%   filtering. Resulting filter effect doubles the effective order of the 
%   filter, since filtfilt filters the data in the forward direction, 
%   reverses and filters it back through to remove any phase distortion.
%   Logical 1/0 (true,false).
%
% OUTPUTS:
%   filtered - Time series data with filter applied
%
% EXAMPLES:
%   Low-pass filtering x (sampled at 102400 Hz) at 200 Hz cutoff
%   filtered = filterData(x,200,102400,'low');
%
%   Band-stop filtering x (sampled at 51200 Hz) from 55 to 65 Hz, second
%   order filter.
%   filtered = filterData(x,[55 65],51200,'stop','FilterOrder',2);
%
%   High-pass filtering x (sampled at 96000 Hz) at 1 kHz cutoff with zero
%   phase distortion
%   filtered = filterData(x,1000,96000,'ZeroPhaseDist',1);
%
% Author: Logan Mathews
% Rev. 26 May 2021

    % Parse inputs
    p = inputParser;
    p.addParameter('FilterOrder',2); % Checking for specified filter order, default is 2nd order.
    p.addParameter('ZeroPhaseDist',0); % Checking for specified filter order, default is 2nd order.
    p.parse(varargin{:});

    % Assigning optional inputs
    filterOrder = p.Results.FilterOrder;
    zeroPhaseDist = p.Results.ZeroPhaseDist;

    % Error check and assign parameters input for filter type
    switch filterType
        case {'high','low','bandpass','stop'}
        otherwise
            warning('Invalid Filter Type.')
    end

    % Design filter
    [B,A] = butter(filterOrder,f_filter*2/fs,filterType);

    % Apply filter to data
    if zeroPhaseDist
        filtered = filtfilt(B,A,x);
    else
        filtered = filter(B,A,x);
    end
    
end