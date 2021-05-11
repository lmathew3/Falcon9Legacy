function filtered = filterData(x,f_filter,fs,filterType,varargin)
% filtered = filterData(x,filterType,varargin)
% Function that creates and applies a custom filter to data
% Inputs:
%   x - Time series data
%   f_filter - Cutoff/pass/stop frequency for filter design
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
% Outputs:
%   filtered - Time series data with filter applied
%
% Author: Logan Mathews
% Rev. 21 Aug 2020

    % Parse inputs
    p = inputParser;
    p.addParameter('FilterOrder',2); % Checking for specified filter order, default is 2nd order.
    p.parse(varargin{:});

    % Assigning optional inputs
    filterOrder = p.Results.FilterOrder;

    % Error check and assign parameters input for filter type
    switch filterType
        case {'high','low','bandpass','stop'}
        otherwise
            warning('Invalid Filter Type.')
    end

    % Design filter
    [B,A] = butter(filterOrder,f_filter*2/fs,filterType);

    % Apply filter to data
    filtered = filter(B,A,x);
end