f9NameParams = ["IRIDIUM 7", "IRIDIUM 7", "IRIDIUM 7", "SAOCOM 1A", "SAOCOM 1A", "RADARSAT Constellation", "RADARSAT Constellation", "RADARSAT Constellation", "RADARSAT Constellation";
    "West Field 1", "West Field 2", "North Field", "North Field", "West Field", "North Field", "West Field", "Miguelito", "East Field"];
    
f9IntParams = [51200, 51200, 51200, 51200, 51200, 102400, 51200, 51200, 51200;
    0, 0, 0, 1, 1, 1, 1, 1, 1;
    0, 0, 0, 0, 0, 0, 1, 1, 1;
    0, 0, 0, 0, 0, 0, 2, 2, 2;
    6565,6565,8345,8291,7695,8208,7758,13685,11388;
    52.24,48.15,52.23,63.31,74.14,57.72,52.04,25.76,51.47
    131.5,131.5,133.5,133.5,134.5,133.5,134.5,83.8,112.7];
save("f9NameParams.mat", 'f9NameParams')
save("f9IntParams.mat", 'f9IntParams')
s1 = ["0","1","2","3","4","5","6","7";
    "378A07","378A07","378A07","378A07","40AE","46AO","40AE","46AO";
    "COUGAR","COUGAR","COUGAR","COUGAR","5ft Source","5ft Grazing","12ft Source","12ft Grazing"];
s2 = ["0","1","2";
    "378A07","46AO","46AO";
    "COUGAR","0ft Grazing","0ft Inverted"];
s3 = ["0","1","2";
    "378A07","46AO","46AO";
    "COUGAR","Old COUGAR","5ft Grazing"];
s4 = ["0","1","2","3","4","5";
    "378A07","40AE","46AO","378A07","40AE","46AO";
    "COUGAR","COUGAR","0ft Grazing","COUGAR","COUGAR","5ft Grazing"];
s5 = ["0","1","2","3","4","5","6";
    "40AE","378A07","378A07","40AE","378A07","378A07","46AO";
    "0ft Source","COUGAR","COUGAR","5ft Source","COUGAR","COUGAR","5ft Grazing"];
s6 = ["0","1","2","3","4","5","6","7","8","9","10";
    "40AE","40AE","40AE","40AE","47AC","47AC","47AC","47AC","GPS500","378A07","378A07";
    "Vertical","Vertical","Vertical","Vertical","COUGAR","COUGAR","COUGAR","COUGAR","GPS","COUGAR","5ft Source"];
s7 = ["0","1","2","3","4";
    "378A07","46AO","GPS500","378A07","46AO";
    "COUGAR","5ft Grazing","GPS","COUGAR","5ft Grazing"];
s8 = ["0","1","2";
    "378A07","46AO","GPS500";
    "COUGAR","5ft Grazing","GPS"];
s9 = ["0","1","2";
    "378A07","46AO","GPS500";
    "COUGAR","5ft Grazing","GPS"];
save("s1.mat",'s1')
save("s2.mat",'s2')
save("s3.mat",'s3')
save("s4.mat",'s4')
save("s5.mat",'s5')
save("s6.mat",'s6')
save("s7.mat",'s7')
save("s8.mat",'s8')
save("s9.mat",'s9')