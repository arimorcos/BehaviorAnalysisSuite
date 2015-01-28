%%

%initialize arrays
theta = cell(1,length(dataCell));
xVel = cell(1,length(dataCell));
evArray = cell(1,length(dataCell));
yPos = cell(1,length(dataCell));
numSeg = max(getCellVals(dataCell,'maze.numLeft'));

for i=1:length(dataCell) %for each trial
    
    %remove any trials in which mouse turned around before the end of the
    %segments
    yPos{i} = dataCell{i}.dat(3,:);
    tempTheta = rad2deg(mod(dataCell{i}.dat(4,:),2*pi));
    if any(yPos{i} > ranges(1) & yPos{i} < ranges(end) & tempTheta > 180)
        theta{i} = nan(size(yPos{i}));
        xVel{i} = nan(size(yPos{i}));
        evArray{i} = nan(size(yPos{i}));
        yPos{i}(:) = NaN;
        continue;
    else
        theta{i} = tempTheta;
    end
    
    %get xVelocity
    xVel{i} = dataCell{i}.dat(5,:);
    
    %for each virmen iteration, determine how many pieces of evidence in
    %favor of the correct answer the mouse has seen 
    
    %first create an array containing the amount of evidence after each
    %range
    evRange = zeros(1,numSeg);
    if dataCell{i}.maze.leftTrial %if a left trial 
        evRange(dataCell{i}.maze.leftDotLoc) = 1;
        evRange = cumsum(evRange);
    else
        evRange(setdiff(1:numSeg,dataCell{i}.maze.leftDotLoc)) = 1;
        evRange = cumsum(evRange);
    end
    
    %next expand based on position
    evArray{i} = zeros(size(xVel{i}));
    for j=1:numSeg %for each segment
        if j < numSeg %if j is less than numSeg, find all indices in which current range
            ind = yPos{i} >= ranges(j) & yPos{i} < ranges(j+1);
        else %otherwise find all indices from last range to end
            ind = yPos{i} >= ranges(j);
        end
        evArray{i}(ind) = evRange(j);
    end
    
    %normalize xVelocity and theta
    if dataCell{i}.maze.leftTrial %if left trial
        theta{i} = theta{i} - 90;
        xVel{i} = -xVel{i}; %if left trial, make negative x velocity positive
    else
        theta{i} = 90 - theta{i};
    end     
end

evArrayAll = [evArray{:}];
thetaAll = [theta{:}];
xVelAll = [xVel{:}];
yPosAll = [yPos{:}];

%remove nans
evArrayAll = evArrayAll(~isnan(evArrayAll));
thetaAll = thetaAll(~isnan(thetaAll));
xVelAll = xVelAll(~isnan(xVelAll));
yPosAll = yPosAll(~isnan(yPosAll));

%% roc analysis

leftTurn = nan(1,length(dataCell));
for i=1:length(dataCell) %for each trial
    
    %remove any trials in which mouse turned around before the end of the
    %segments
    yPos{i} = dataCell{i}.dat(3,:);
    tempTheta = rad2deg(mod(dataCell{i}.dat(4,:),2*pi));
    if any(yPos{i} > ranges(1) & yPos{i} < ranges(end) & tempTheta > 180)
        theta{i} = nan(size(yPos{i}));
        xVel{i} = nan(size(yPos{i}));
        evArray{i} = nan(size(yPos{i}));
        yPos{i}(:) = NaN;
        continue;
    else
        theta{i} = tempTheta;
    end
    
    %did mouse turn left
    leftTurn(i) = dataCell{i}.result.leftTurn;
    
    %get xVelocity
    xVel{i} = dataCell{i}.dat(5,:);
    
    %for each virmen iteration, determine how many pieces of evidence in
    %favor of the correct answer the mouse has seen 
    
    %first create an array containing the amount of evidence after each
    %range
    evRange = zeros(1,numSeg);
    if dataCell{i}.maze.leftTrial %if a left trial 
        evRange(dataCell{i}.maze.leftDotLoc) = 1;
        evRange = cumsum(evRange);
    else
        evRange(setdiff(1:numSeg,dataCell{i}.maze.leftDotLoc)) = 1;
        evRange = cumsum(evRange);
    end
    
    %next expand based on position
    evArray{i} = zeros(size(xVel));
    for j=1:numSeg %for each segment
        if j < numSeg %if i is less than numSeg, find all indices in which current range
            ind = find(yPos{i} >= ranges(j) & yPos{i} < ranges(j+1));
        else %otherwise find all indices from last range to end
            ind = find(yPos{i} >= ranges(j));
        end
        evArray{i}(ind) = evRange(j);
    end
end

evArrayAll = [evArray{:}];
thetaAll = [theta{:}];
xVelAll = [xVel{:}];
yPosAll = [yPos{:}];

%remove nans
evArrayAll = evArrayAll(~isnan(evArrayAll));
thetaAll = thetaAll(~isnan(thetaAll));
xVelAll = xVelAll(~isnan(xVelAll));
yPosAll = yPosAll(~isnan(yPosAll));

yPosBins = linspace(min(yPosAll),max(yPosAll),500);
binTheta = cell(numSeg+1,length(yPosBins)-1);
binXVel = cell(numSeg+1,length(yPosBins)-1);
for i=2:length(yPosBins) %for each bin
    for j=1:numSeg+1 %for each amount of evidence
        posInd = yPosAll >= yPosBins(i-1) & yPosAll < yPosBins(i);
        evInd = evArrayAll == j-1;
        binTheta(j,i-1) = thetaAll(posInd & evInd);
        binXVel(j,i-1) = xVelAll(posInd & evInd);
    end
end



%% plot individual trials
figH = figure;
subplot(2,1,1);
colors = distinguishable_colors(numSeg+1);
gscatter(yPosAll,xVelAll,evArrayAll,colors,[],4);
xlabel('Y Position');
ylabel('X Velocity');
for i=1:numSeg
    line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
end

subplot(2,1,2);
gscatter(yPosAll,thetaAll,evArrayAll,colors,[],4);
xlabel('Y Position');
ylabel('Relative View Angle');
ylim([-90 90]);
for i=1:numSeg
    line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
end

%% plot means

%bin yPos
yPosBins = linspace(min(yPosAll),max(yPosAll),500);
meanTheta = zeros(numSeg+1,length(yPosBins)-1);
meanXVel = zeros(numSeg+1,length(yPosBins)-1);
for i=2:length(yPosBins) %for each bin
    for j=1:numSeg+1 %for each amount of evidence
        posInd = yPosAll >= yPosBins(i-1) & yPosAll < yPosBins(i);
        evInd = evArrayAll == j-1;
        meanTheta(j,i-1) = mean(thetaAll(posInd & evInd));
        meanXVel(j,i-1) = mean(xVelAll(posInd & evInd));
    end
end

figH = figure;
subplot(2,1,1);
hold on;
colors = distinguishable_colors(numSeg+1);
for i=1:size(meanXVel,1)
    plot(yPosBins(2:end),meanXVel(i,:),'Color',colors(i,:),'LineWidth',2);
end
xlabel('Y Position');
ylabel('X Velocity');
for i=1:numSeg
    line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
end
legEnt = 0:numSeg;
legend(cellstr(num2str(legEnt')));

subplot(2,1,2);
hold on;
for i=1:size(meanTheta,1)
    plot(yPosBins(2:end),meanTheta(i,:),'Color',colors(i,:),'LineWidth',2);
end

legEnt = 0:numSeg;
legend(cellstr(num2str(legEnt')));
xlabel('Y Position');
ylabel('Relative View Angle');
ylim([-90 90]);
for i=1:numSeg
    line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
end


%% triggered

plotInd = true;
plotXVel = true;
plotTheta = ~true;

%find yPosBins for each range
yPosBins = linspace(min(yPosAll),max(yPosAll),500);
yPosBinRanges = cell(1,numSeg);
triggeredTheta = cell(1,numSeg);
triggeredXVel = cell(1,numSeg);
triggeredEvRange = cell(1,numSeg);
thetaBinned = cell(1,numSeg);
xVelBinned = cell(1,numSeg);
for i=2:length(yPosBins) %for each bin
    for j=1:numSeg+1 %for each amount of evidence
        posInd = yPosAll >= yPosBins(i-1) & yPosAll < yPosBins(i);
        evInd = evArrayAll == j-1;
        thetaBinned{j}(i-1) = thetaAll(posInd & evInd);
        xVelBinned{j}(i-1) = xVelAll(posInd & evInd);
    end
end
for i=1:numSeg
    yPosBinRanges{i} = yPosBins >= ranges(i) & yPosBins < ranges(i+1);
    triggeredTheta{i} = thetaBinned{i}(yPosBinRanges{i});
    triggeredXVel{i} = xVelAllBinned{i}(yPosBinRanges{i});
end

if plotInd
    if plotXVel
        figXVel = figure;
        colors = distinguishable_colors(numSeg+1);
        for i=1:numSeg
            subplot(2,3,i);
            for j=1:numSeg+1 %for each evidence category
                hold on;
                scatter(yPosBins(yPosBinRanges{i}),triggeredXVel{j},colors(j,:));
            end
            title(['Segment ',num2str(i)]);
            xlabel('Y Position');
            ylabel('X Velocity');
        end
        
    end
    
    if plotTheta
        figXVel = figure;
        colors = distinguishable_colors(numSeg+1);
        for i=1:numSeg
            subplot(2,3,i);
            gscatter(yPosBins(yPosBinRanges{i}),triggeredXVel{i},triggeredEvRange{i},colors);
            title(['Segment ',num2str(i)]);
            xlabel('Y Position');
            ylabel('X Velocity');
        end
    end
end