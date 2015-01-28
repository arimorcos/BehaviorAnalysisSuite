%dnum2secs.m

%function to convert a date number into total seconds

function [seconds] = dnum2secs(dnum)

    if length(dnum) == 1
        [H, M, S, MS] = strread(datestr(dnum,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); 
        seconds = 3600*H + 60*M + S + MS/1000; 
    else
        seconds = zeros(1,length(dnum));
        for i=1:length(dnum)
            [H, M, S, MS] = strread(datestr(dnum(i),'HH:MM:SS:FFF'),'%d:%d:%d:%d'); 
            seconds(i) = 3600*H + 60*M + S + MS/1000; 
        end
    end
end