%DESCRIPTION: DECODE IRIG-B SIGNAL AND DETERMINE START TIME OF SIGNAL
%AUTHOR: MICHAEL JAMES/BRRC
%INPUT: IRIGB DATA
%OUTPUT: FILE START TIME
%SUBROUTINES:
%ASSUMED INPUT FILENAMES: *
%PROJECT: SERDP MODEL
%DATE: 01/22/09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% IRIG OUTPUTS UTC TIME, WHICH IS EXACTLY 4 HOURS AHEAD OF EDT, AND
%   EXACTLY 5 HOURS AHEAD OF EST.
%
% DEFINITIONS:
%   CYCLE: ONE PERIOD OF THE 1 KHZ CARRIER SIGNAL; CAN HAVE A MAXIMUM
%       AMPLITUDE OF ONE OF TWO VALUES (MARK OR SPACE) WITH RATIO VARYING
%       FROM 3:1 TO 6:1
%   PULSE: A COMBINATION OF 10 CONSECUTIVE CYCLES INTO A SQUARE WAVE WITH
%       VALUE OF 1 OR 0; PULSES LAST 10 MILLISECONDS
%   PULSE DURATION: LENGTH OF TIME THE PULSE HAS AMPLITUDE OF 1; CAN ONLY
%      EQUAL 2, 5, OR 8 MS; SEE BELOW FOR DECODING.
%   BIT: SAME AS PULSE, BUT CONVERTED TO BINARY 1 OR 0.
%
% CONSTANTS FOR IRIG-B:
%   ONE TIME FRAME PER SECOND
%   100 PULSES PER SECOND, WHICH ALSO MEANS 100 BITS PER SECOND
%   SINE WAVE, AMPLITUDE MODULATED
%   1 KHZ CARRIER SIGNAL, WHICH GIVES 1000 CYCLES PER SECOND, AND
%       THEREFORE ONCE CYCLE PER MILLISECOND
%   ONE REFERENCE MARK PER SECOND
%   10 POSITION IDENTIFIERS PER SECOND
%   PULSE DURATIONS:
%       INDEX MARKER = 2 MILLISECONDS (MS)
%       BINARY ZERO OR UNCODED BIT = 2 MS
%       BINARY ONE = 5 MS
%       POSITION IDENTIFIER = 8 MS
%       REFERENCE BIT = 8 MS
%
% Modified to include Year input - KLG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%RUN IRIGB SUBROUTINE
function [start_time] = IRIGB(irig,sampling_rate,num_secs_decode,resample_opt,year)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%CHECK TO SEE IF SAMPLING RATE WILL RESULT IN AN INTEGER NUMBER OF
%SAMPLES IN ONE MSEC.  IF TEST IS TRUE RESAMPLE THE DATA SO THAT THE
%SAMPLING RATE IS AN INTERGER WHEN DIVIDED BY 1000.
%FOR EXAMPLE 204.8 kHz WILL NOT WORK (DATA MUST BE RESAMPLED).
if mod(sampling_rate,1000) ~= 0 || resample_opt == 1
    sampling_rate_old = sampling_rate;
    sampling_rate = 8000;
    irig = resample(irig,sampling_rate,sampling_rate_old);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIGNAL CHARACTERISTICS
% LENGTH OF SIGNAL (SECONDS) AND # SAMPLES PER UNIT TIME
max_time = length(irig)/(sampling_rate);
samp_sec = sampling_rate;
samp_msec = samp_sec/1000;

% DETERMINE HOW MUCH DATA TO DECODE (0 FOR FIRST SEC, 1 FOR ENTIRE SIGNAL)
if num_secs_decode == 0
    max_process = 3000;	%3000 ONLY FIRST THREE SECONDS OF SIGNAL
elseif num_secs_decode == 1
    %max_process = ((max_time - 2) + 1)*1000; UPDATE BELOW TO MAKE INTEGER
     max_process = floor(((max_time - 2) + 1)*1000);  
end

% PRE-ALLOCATE LARGE MATRICES CREATED IN LOOPS; USE SINGLE PRECISION
a_cycle = zeros(1,max_process);
a_max = zeros(1,max_process);
%pulse = zeros(1,((max_process-1000)/10)-1); UPDATE BELOW TO MAKE INTEGER
pulse = zeros(1,floor(((max_process-1000)/10)-1));

% MEAN AMPLITUDE MAY DRIFT (I.E. NOT CENTERED AT Y=0), SO SHIFT DATA
irig = irig - mean(irig);

% RANGES TO DEFINE CYCLE VALUES; RATIO RANGES FROM 3:1 TO 6:1
max_amp = max(abs(irig));
% BINARY 1
r1_max = 1.10*max_amp;
r1_min = 0.66*(max_amp);
% BINARY 0
r0_max = 0.4*(max_amp); %r0_max = 0.45*(max_amp);
r0_min = 0.15*(max_amp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEBUGGING: PLOT PART OF THE SIGNAL
% figure
% hold on
% min_plot = 1;  %SECONDS
% max_plot = 5;  %SECONDS
% range = samp_msec*(min_plot*1000):samp_msec*(max_plot*1000);
% plot(range/(sampling_rate/dec_factor),irig(range))
% % plot(range/(sampling_rate/dec_factor),irig(range),'o')
% xlabel('time (sec)')
% ylabel('amplitude of IRIG-B')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIND VALUE BEFORE FIRST ZERO CROSSING (FROM NEGATIVE TO POSITIVE)
first_sig = sign(irig(1:samp_msec*2));
for h = 1:length(first_sig)
    if first_sig(h+1) == 1 && first_sig(h) == -1
        first_zero = h;break;break;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE VARIABLES
ierr = 0;   % ERROR COUNTER
ns = 0;     % NUMBER OF SHIFTS COUNTER
shift = 0;  % SHIFT VALUE

% LOOP OVER EACH CYCLE (i)
for i = 1:max_process
    a_range_s = ((first_zero-1)+((i-1)*samp_msec)+(1:samp_msec)) + shift;
    a_sign = sign(irig(a_range_s))';
    
    % DETERMINE IF WE ARE STILL STARTING ONE POINT BEFORE ZERO CROSSING
    switch sum(a_sign(1:2))
        case 0  % GREAT! WE ARE AT ZERO CROSSING
        case -2 % UH OH, LAGGING BEHIND BY 1 SAMPLE; MOVE UP 1 SAMPLE
            shift = shift + 1; ns = ns+1;
        case 2  % UH OH, AHEAD BY 1 SAMPLE, MOVE BACK ONE SAMPLE
            shift = shift - 1; ns = ns+1;
        otherwise
            disp 'ERROR: Shifting is f*cked up! IRIG Signal may be screwy.'
    end
    
    % CORRECT THE RANGE, STARTING WITH SAMPLE BEFORE ZERO CROSSING
    a_range = ((first_zero-1)+((i-1)*samp_msec)+(1:samp_msec)) + shift;
    a_max(i) = (max(irig(a_range)));
    
    % VARIABLES FOR DEBUGGING ONLY
    % a_index(i) = find(a_max(i)==irig(a_range))+min(a_range)-1;
    % a_time(i) = a_index(i)/(sampling_rate/dec_factor);
    
    % CONVERT MAX CYCLE VALUE TO BINARY DIGIT
    if a_max(i) <= r1_max && a_max(i) >= r1_min
        a_cycle(i) = 1;
    elseif a_max(i) <= r0_max && a_max(i) >= r0_min
        a_cycle(i) = 0;
    else
        % MAX VALUE OF CYCLE IS NOT IN EITHER RANGE
        % BUILD CELL ARRAY OF ERROR MESSAGES
        ierr = ierr + 1;
        ierr_list{ierr} = ['a_cycle(1): ' num2str(a_range(1)) ...
            '  max of cycle: ' num2str(a_max(i))];
        a_cycle(i) = 0; % SINCE THERE IS AN ERROR, SET CYCLE = 0
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIND FIRST OCCURRANCE OF Po AND Pr (SUM OF BINARY = 16)
% ONLY NEED TO LOOP OVER FIRST 2 SECONDS (1 TO 2000 CYCLES)
po_pr_chk = [1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0]; %Po AND Pr ID
for j = 1:2000
    if a_cycle(j-1+(1:20)) == po_pr_chk
        first_pr = j+10;
        break;break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVERT EVERY 10 CYCLES (BINARY) TO ONE PULSE (= 2, 5, OR 8)
% BEGIN WITH FIRST Pr FOUND ABOVE (j+10) (j is cycle #)

for k = 1:((max_process-1000)/10)-1   %PULSES (ALWAYS A MULTIPLE OF 100 PPS)
    pulse(k) = sum(a_cycle(((k-1)*10)+(first_pr:first_pr+9)));

    %FOR TESTING ONLY
    tt(k,:) = [a_cycle(((k-1)*10)+(first_pr:first_pr+9)) ...
        sum(a_cycle(((k-1)*10)+(first_pr:first_pr+9)))];
    
    % CHECK THAT ALL PULSES = 2, 5, OR 8
    switch pulse(k)
        case {2,5,8}    %PULSE IS OK, DO NOTHING.
        otherwise
            disp (['ERROR: Pulse has bad sum; ZERO WRITTEN; time= ' ...
                num2str(k/100,'%02.2f') ' sec'])
            pulse(k) = 2;   % 2 WILL ROUND TO ZERO IN NEXT STEP.
    end
end

% CONVERT PULSES (SUMS) TO BITS; 2 BECOMES 0; 5 AND 8 BECOME 1.
bit = round(pulse/10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVERT BITS TO NUMERICAL TIME AND DAY

for m = 1:((length(pulse)+1)/100)-1
    n = (m-1)*100;
    
    % BCD TIME-OF-YEAR CODE
    seconds(m) = bit(n+2)*1+bit(n+3)*2+bit(n+4)*4+bit(n+5)*8+...
        bit(n+7)*10+bit(n+8)*20+bit(n+9)*40;
    minutes(m) = bit(n+11)*1+bit(n+12)*2+bit(n+13)*4+bit(n+14)*8+...
        bit(n+16)*10+bit(n+17)*20+bit(n+18)*40;
    hours(m) = bit(n+21)*1+bit(n+22)*2+bit(n+23)*4+bit(n+24)*8+...
        bit(n+26)*10+bit(n+27)*20;
    % NUMBER OF DAYS SINCE BEGINNING OF YEAR
    days(m) = bit(n+31)*1+bit(n+32)*2+bit(n+33)*4+bit(n+34)*8+...
        bit(n+36)*10+bit(n+37)*20+bit(n+38)*40+bit(n+39)*80+...
        bit(n+41)*100+bit(n+42)*200;
    
    % STRAIGHT BINARY SECONDS TIME-OF-DAY (OFTEN UNUSED)
    % sec2(m) = bin2dec(num2str([bit(n+98),bit(n+97),bit(n+96),...
    % bit(n+95),bit(n+94),bit(n+93),bit(n+92),bit(n+91),bit(n+89),...
    % bit(n+88),bit(n+87),bit(n+86),bit(n+85),bit(n+84),bit(n+83),...
    % bit(n+82),bit(n+81)]));
    
    %%%%% are there control bits to show GPS lock??? read manuals!
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK DELTA SECONDS
chk_sec = abs(seconds(2:length(seconds)) - seconds(1:length(seconds)-1));
if length(find(chk_sec ~= 1.0 & chk_sec ~= 59.0)) > 0
    disp ' '
    disp 'ERROR: Difference of two consecutive seconds is not equal to 1'
end

% CHECK DAYS
chk_day = days/(days(1));
if length(find(chk_day ~= 1)) > 0
    disp 'NOTICE: Day changes to different day'
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOW WE HAVE IRIG TIME FOR FIRST FULL SECOND
% LET'S BACK UP TO THE BEGINNING OF THE FILE
% IF LESS THAN ONE SECONDS, SUBTRACT ONE MINUTE AND ADD 60 SECONDS
if seconds(1)>=1
    seconds(1) = seconds(1) - ((first_pr-1)*0.001);
elseif seconds(1)<1
    seconds(1) = seconds(1) - ((first_pr-1)*0.001) + 60;
    minutes(1) = minutes(1) - 1;
    % IF LESS THAN ONE MINUTE, SUBTRACT ONE HOUR AND ADD 60 MINUTES
    if minutes(1)<1
        minutes(1) = minutes(1) + 60;
        hours(1) = hours(1) - 1;
        % IF LESS THAN ONE HOUR, SUBTRACT ONE DAY AND ADD 24 HOURS
        if hours(1)<1
            hours(1) = hours(1) + 24;
            days(1) = days(1) - 1;
        end
    end
end

% DETERMINE DATE FILE STARTED, USING CURRENT YEAR ('now')
% USE NUMBER OF DAYS SINCE START OF THIS YEAR
%start_time.date = datestr(days(1)+datenum(datestr(now,10),'yyyy')-1,2);
start_time.date = datestr(days(1)+datenum(int2str(year),'yyyy')-1,2);

start_time.time = [num2str(hours(1),'%02i'),':',...
    num2str(minutes(1),'%02i'),':',num2str(seconds(1),'%06.3f')];

%SECONDS AFTER MIDNIGHT
start_time.sec_aft_mid = hours(1)*3600+minutes(1)*60+seconds(1);

% DISPLAY DAY AND TIME IRIG SIGNAL BEGINS
%disp(['File start in UTC: ',start_time.date,', ',start_time.time])
%disp(['Number of cycle errors [Details in "ierr-list"]: ' num2str(ierr)])
%disp '------------------'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%PLOT RESULTS - SAMPLES ON X AXIS

%ONE CYCLE IS 1 MSEC WHICH IS length(a_range_s) SAMPLES LONG
%NEED TO OFFSECT DATA BY H WHERE FIRST POSITIVE PULSE STARTS AND
%length(a_range_s)/4 WHICH BRINGS THE DATA FROM THE ZERO CROSSING TO THE
%TOP OF THE PULSE TO MAKE THE PLOTS LOOK GOOD
% figure,plot( [0:length(a_cycle)-1]*length(a_range_s)+h+length(a_range_s)/4,...
%     a_cycle,...
%     0:length(irig)-1,irig(1:length(irig)) )

%PLOT RESULTS - SECONDS

%ONE CYLCE IS ONE MSEC THUS THE /1000
%THEN (h+length(a_range_s)/4)/sampling_rate IS ADDED FOR THE TIME OFFSET
% irig_time = 0:1/sampling_rate:((length(irig)-1)/(sampling_rate));
% figure,plot((0:length(a_cycle)-1)/1000+(h+length(a_range_s)/4)/sampling_rate,a_cycle,...
%     irig_time,irig)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%