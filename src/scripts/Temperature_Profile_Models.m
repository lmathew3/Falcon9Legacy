h = 1:100000;
figure
plot(getTemp(h),h)

function T = getTemp(h)
    for i = 1:length(h)
        if h(i) < 11000
            T(i) = 15.04 - 0.00649*h(i);
        elseif h(i) >= 11000 && h(i) < 25000
            T(i) = -56.46;
        else
            T(i) = -131.21 + 0.00299*h(i);
        end
    end
end