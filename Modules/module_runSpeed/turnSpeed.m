%turnSpeed.m

%function to analyze the running speed of the mouse through the end of the
%maze

%ASM 6/26/12

function [turnData] = turnSpeed(data,dataCell,exper,turnStartPerc)

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
startVal = turnStartPerc*mazeLength;

turnTime = zeros(2,length(startTimes));

for i=1:length(startTimes)
    indexValues = find(startTimes(i) >= data(1,:),1,'last'):find(endTimes(i) >= data(1,:),1,'last');
    if isempty(indexValues)
        indexValues = 1:find(endTimes(i) >= data(1,:),1,'last');
    end
    index(1) = indexValues(find(data(3,indexValues) >= startVal,1,'first'));
    index(2) = find(endTimes(i) >= data(1,:),1,'last');
    
    turnTime(1,i) = data(1,index(2)) - data(1,index(1));
end
turnTime(2,:) = getCellVals(dataCell,'maze.leftTrial');

[turnData.secs] = dnum2secs(turnTime(1,:));
[turnData.secsLeft] = dnum2secs(turnTime(1,turnTime(2,:) == 1));
[turnData.secsRight] = dnum2secs(turnTime(1,turnTime(2,:) == 0));

turnData.mean = mean(turnData.secs);
turnData.median = median(turnData.secs);
turnData.STD = std(turnData.secs);

turnData.meanLeft = mean(turnData.secsLeft);
turnData.medianLeft = median(turnData.secsLeft);
turnData.STDLeft = std(turnData.secsLeft);

turnData.meanRight = mean(turnData.secsRight);
turnData.medianRight = median(turnData.secsRight);
turnData.STDRight = std(turnData.secsRight);
end