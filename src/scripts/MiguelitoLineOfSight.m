x = [13890.721649484536,14210.996563573883];
y = [157.1885521885522,92.96296296296296];

a = max(x) - min(x);
b = max(y) - min(y);

theta = atand(b/a) % Angle above horizon

altitude = 14211*tand(theta)/1000 + min(y)/1000 % Altitude at which line of sight is achieved.

