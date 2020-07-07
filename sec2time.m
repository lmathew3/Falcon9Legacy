function [hrs,min,sec,str]=sec2time(secaftmidnight)

hrs=floor(secaftmidnight/3600);
remhrs=rem(secaftmidnight,3600);
min=floor(remhrs/60);
remmin=rem(remhrs,60);
sec=remmin;
str=[num2str(hrs,'%02i'),':',num2str(min,'%02i'),':',num2str(sec,'%06.3f')];


