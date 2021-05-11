function [qtRes] = tenthToQuarter(x)
% Function takes in data in tenth-second resolution and converts to
% quarter-second resolution.
% x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,1,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
qtRes = [];
for i = 1:length(x)/10
    inc = (i * 10) - 10;
    for j = 1:4
        if j == 1
            val = (x(1,(2 + inc)) + x(1,(3 + inc))) / 2;
            new = [qtRes, val];
            qtRes = new;
        end
        if j == 2
            new = [qtRes, x(1,5 + inc)];
            qtRes = new;
        end
        if j == 3
            val = (x(1,(7 + inc)) + x(1,(8 + inc))) / 2;
            new = [qtRes, val];
            qtRes = new;
        end
        if j == 4
            new = [qtRes, x(1,10 + inc)];
            qtRes = new;
        end
    end
end
end