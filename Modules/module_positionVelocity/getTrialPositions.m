function [xPosLeft,xPosRight,yPosLeft,yPosRight,thetaLeft,thetaRight,pos] =...
    getTrialPositions(data,dataCell,dataCellInd)
%getTrialVelocity.m Function to get and normalize lengths of trial
%velocities

pos = cell(2,length(dataCell));
dataCellInd = find(dataCellInd == 1);

trialEndInd = find(diff(data(9,:))==1); %find the end indices
trialStartInd = [1 find(diff(data(9,:))==-1)+1]; %find the start indices (including first start)
if ~data(9,end) %if ended in the middle of a trial
    trialStartInd = trialStartInd(1:end-1); %remove incomplete final trial
end

%convert theta trace to degrees
data(4,:) = radtodeg(rem(data(4,:),2*pi));
data(4,data(4,:)<0) = 360 + data(4,data(4,:)<0);

for i = 1:length(dataCellInd) %for each trial
    pos{1,i} = data(2,trialStartInd(dataCellInd(i)):trialEndInd(dataCellInd(i))); %get x position trace
    pos{2,i} = data(3,trialStartInd(dataCellInd(i)):trialEndInd(dataCellInd(i))); %get y position trace
    pos{3,i} = data(4,trialStartInd(dataCellInd(i)):trialEndInd(dataCellInd(i))); %get theta trace 
end  

%find number of left/right trials
nLeft = sum(findTrials(dataCell,'result.leftTurn==1'));
nRight = length(dataCell) - nLeft;

% trialLengths = cell2mat(cellfun(@(x) length(x),pos(1,:),'UniformOutput',false)); %get length of each trial
% minLength = min(trialLengths); %find min length
xPosLeft = cell(nLeft,1);
xPosRight = cell(nRight,1);
yPosLeft = cell(nLeft,1);
yPosRight = cell(nRight,1);
thetaLeft = cell(nLeft,1);
thetaRight = cell(nRight,1);
% extraEl = trialLengths - minLength; %find number of elements to remove
leftInd = 1;
rightInd = 1;

for i=1:length(pos(1,:)) %for each array
%     if extraEl(i) == 0 %if no more elements, continue
%         continue;
%     end
%     loc = randsample(length(pos{1,i}),extraEl(i)); %generate random iteration locations
%     pos{1,i}(loc) = []; %remove all those random elements from x trace
%     pos{2,i}(loc) = []; %remove all those random elements from y trace
%     pos{3,i}(loc) = []; %remove all those random elements form theta trace
    
    if dataCell{i}.result.leftTurn
        xPosLeft{leftInd} = pos{1,i};
        yPosLeft{leftInd} = pos{2,i};
        thetaLeft{leftInd} = pos{3,i};
        leftInd = leftInd + 1;
    else
        xPosRight{rightInd} = pos{1,i};
        yPosRight{rightInd} = pos{2,i};
        thetaRight{rightInd} = pos{3,i};
        rightInd = rightInd + 1;
    end
end

end