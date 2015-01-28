%calcSessionTime.m

%function to calculate the elapsed session time 

%ASM 6/13/12

function [sessionTime] = calcSessionTime(dataCell)
   
    sessionTime = dataCell{end}.time.stop - dataCell{1}.time.start;
    [H, M, S, MS] = strread(datestr(sessionTime,'HH:MM:SS:FFF'),'%d:%d:%d:%d');
    sessionTime = 60*H + M + S/60 + MS/60000;
    
end