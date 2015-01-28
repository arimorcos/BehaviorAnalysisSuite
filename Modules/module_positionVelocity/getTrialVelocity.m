function [xVelLeft,xVelRight,yVelLeft,yVelRight,vel] =...
    getTrialVelocity(data,dataCell,dataCellInd)
%getTrialVelocity.m Function to get and normalize lengths of trial
%velocities 

vel = cell(2,length(dataCell));
dataCellInd = find(dataCellInd == 1);

trialEndInd = find(diff(data(9,:))==1); %find the end indices
trialStartInd = [1 find(diff(data(9,:))==-1)+1]; %find the start indices (including first start)
if ~data(9,end) %if ended in the middle of a trial
    trialStartInd = trialStartInd(1:end-1); %remove incomplete final trial
end

for i = 1:length(dataCell) %for each trial
    vel{1,i} = data(5,trialStartInd(dataCellInd(i)):trialEndInd(dataCellInd(i))); %get x velocity trace 
    vel{2,i} = data(6,trialStartInd(dataCellInd(i)):trialEndInd(dataCellInd(i))); %get y velocity trace 
end

%find number of left/right trials
nLeft = sum(findTrials(dataCell,'result.leftTurn==1'));
nRight = length(dataCell) - nLeft;

% trialLengths = cell2mat(cellfun(@(x) length(x),vel(1,:),'UniformOutput',false)); %get length of each trial
% minLength = min(trialLengths); %find min length
xVelLeft = cell(nLeft,1);
xVelRight = cell(nRight,1);
yVelLeft = cell(nLeft,1);
yVelRight = cell(nRight,1);
% extraEl = trialLengths - minLength; %find number of elements to remove
leftInd = 1;
rightInd = 1;
% velShort = vel;

for i=1:length(vel(1,:)) %for each array
%     if extraEl(i) == 0 %if no more elements, continue
%         continue;
%     end
%     loc = randsample(length(vel{1,i}),extraEl(i)); %generate random iteration locations
%     velShort{1,i}(loc) = []; %remove all those random elements from x trace
%     velShort{2,i}(loc) = []; %remove all those random elements from y trace
    
    if dataCell{i}.result.leftTurn
        xVelLeft{leftInd} = vel{1,i};
        yVelLeft{leftInd} = vel{2,i};
        leftInd = leftInd + 1;
    else
        xVelRight{rightInd} = vel{1,i};
        yVelRight{rightInd} = vel{2,i};
        rightInd = rightInd + 1;
    end
    
end

end