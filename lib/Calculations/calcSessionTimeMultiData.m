function [totalSessionTime, sessionTimeVector] = calcSessionTimeMultiData(data)
%calcSessionTimeMultiData.m Calculates the total session time in minutes of
%multiple data sets
%
%ASM 9/25/12

if ~iscell(data)
    error('Input to calcSessionTimeMultiData must be a cell array of data arrays');
end

totalSessionTime = 0; %initialize total session time
sessionTimeVector = 0;
for i=1:length(data)
    sessionTimeVector = sessionTimeVector + data{i}(1,end)-data{i}(1,1); %get vector
    [H, M, S, MS] = strread(datestr(sessionTimeVector,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %convert to components
    sessionTime = 60*H + M + S/60 + MS/60000; %convert to minutes
    totalSessionTime = totalSessionTime + sessionTime; %add to total session time
end

end