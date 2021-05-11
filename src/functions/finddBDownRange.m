function [first,last,spread] = finddBDownRange(x,y,numdB)
    % Function that finds a specified dB down range of values for an x-y
    % pair data series
    
    nfirst = find(y >= (max(y) - numdB),1,'first'); % Index of first
    nlast = find(y >= (max(y) - numdB),1,'last'); % Index of first
    
    first = x(nfirst);
    last = x(nlast);
    
    spread = last-first;
    
end