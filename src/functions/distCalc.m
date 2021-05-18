function [s,c]=distCalc(r,theta,d,a,averagingPeriod,tOffset)
% This function calculates the actual distance to source of a rocket launch where trajectory
% information is known.
% 
% Inputs:
% r = radial distance from measurement location to original location (launch pad)
% theta = angle between rocket travel direction and measurement location to pad radius.
% d = array of downrange distances of rocket
% a = array of altitudes of rocket
% tOffset = time offset from prebuffer (time before rocket launch)
% 
% Outputs:
% s = array of true distances from rocket to measurement location.
% 
% Author: Logan Mathews
% 22 October 2019

for n=1:floor(tOffset/averagingPeriod)
s(n) = r;
end

for m=(1+floor(tOffset/averagingPeriod)):(length(d)+floor(tOffset/averagingPeriod))

% Find ground-projected distance 'c' from rocket to measurement location via
% law of cosines

c(m) = sqrt(r^2 + d(m-floor(tOffset/averagingPeriod))^2 - 2 * r * d(m-floor(tOffset/averagingPeriod)) * cos(theta));

% Now calculate the true distance 's' from rocket to measurement source via
% Pythagoras' Identity.

s(m) = sqrt(c(m)^2 + a(m-floor(tOffset/averagingPeriod))^2);

end

end