%runSpeedPerc.m

%function to analyze the running speed of the mouse through a specific percentage of the MazeLengthAhead Vector

%ASM 6/26/12

function [runData] = runSpeedPerc(data,dataCell,exper,startPerc,endPerc)

%get times of trial start and end
startTimes = getCellVals(dataCell,'time.start');
endTimes = getCellVals(dataCell,'time.stop');

%get MazeLengthAhead
if isfield(exper.variables,'mazeLengthAhead')
    mazeLength = str2double(exper.variables.mazeLengthAhead);
elseif isfield(exper.variables,'MazeLengthAhead')
    mazeLength = str2double(exper.variables.MazeLengthAhead);
else
    error('No mazelength variable');
    return;
end
startVal = startPerc*mazeLength;
endVal = endPerc*mazeLength;

travelTime = zeros(1,length(startTimes));

for i=1:length(startTimes)
    indexValues = find(startTimes(i) >= data(1,:),1,'last'):find(endTimes(i) >= data(1,:),1,'last');
    if isempty(indexValues)
        indexValues = 1:find(endTimes(i) >= data(1,:),1,'last');
    end
    index(1) = indexValues(find(data(3,indexValues) >= startVal,1,'first'));
    index(2) = indexValues(find(data(3,indexValues)<=endVal,1,'last'));
    
    travelTime(i) = data(1,index(2)) - data(1,index(1));
end

runData.secs = dnum2secs(travelTime);
runData.mean = mean(runData.secs);
runData.median = median(runData.secs);
runData.STD = std(runData.secs);
end