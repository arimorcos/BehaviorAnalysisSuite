function turnSegment_CALLBACK(src,evnt,dataCell,guiObjects)
%turnSegment_CALLBACK.m Callback for the integration module
%
%Takes in dataCell designated to be fed into module callback by condition
%listbox. Opens integration gui and plots pyschometric function.
%Data/figure can then be exported to base workspace for further analysis if
%desired.

if ~isfield(dataCell{1}.maze,'numWhite') &&... %check if any integration data
        ~isfield(dataCell{1}.maze,'numwhite') && ~isfield(dataCell{1}.maze,'numLeft')
    warndlg('This maze does not contain any integration data');
    return
end

if isfield(dataCell{1}.maze,'numWhite')
    flagCap = true;
    flagWhite = true;
elseif isfield(dataCell{1}.maze,'numwhite')
    flagCap = false;
    flagWhite = true;
elseif isfield(dataCell{1}.maze,'numLeft')
    flagCap = true;
    flagWhite = false;    
end

%get ranges (positions which correspond to each segment 
if isfield(guiObjects,'vr')
    vr = guiObjects.vr;
    ranges = vr.ranges;
else
    ranges = [0 80 160 240 320 400 480];
end

%initialize arrays
theta = cell(1,length(dataCell));
xVel = cell(1,length(dataCell));
evArray = cell(1,length(dataCell));
yPos = cell(1,length(dataCell));
if flagWhite
    if flagCap
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    else
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    end
else
    numSeg = max(getCellVals(dataCell,'maze.numLeft'));
end

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
    if flagWhite
        if dataCell{i}.maze.whiteTrial %if a left trial 
            evRange(dataCell{i}.maze.whiteDots) = 1;
            evRange = cumsum(evRange);
        else
            evRange(setdiff(1:numSeg,dataCell{i}.maze.whiteDots)) = 1;
            evRange = cumsum(evRange);
        end
    else
        if dataCell{i}.maze.leftTrial %if a left trial 
            evRange(dataCell{i}.maze.leftDotLoc) = 1;
            evRange = cumsum(evRange);
        else
            evRange(setdiff(1:numSeg,dataCell{i}.maze.leftDotLoc)) = 1;
            evRange = cumsum(evRange);
        end
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
    
    %normalize xVelocity and theta
    if dataCell{i}.maze.leftTrial %if left trial
        theta{i} = theta{i} - 90;
        xVel{i} = -xVel{i}; %if left trial, make negative x velocity positive
    else
        theta{i} = 90 - theta{i};
    end     
end

%process large cell arrays
evArrayAll = [evArray{:}];
thetaAll = [theta{:}];
xVelAll = [xVel{:}];
yPosAll = [yPos{:}];

%remove nans
evArrayAll = evArrayAll(~isnan(evArrayAll));
thetaAll = thetaAll(~isnan(thetaAll));
xVelAll = xVelAll(~isnan(xVelAll));
yPosAll = yPosAll(~isnan(yPosAll));

%create gui
[turnSegGUIData] = turnSegGUI();

if get(turnSegGUIData.means,'Value') %if means is checked
    %bin yPos
    yPosBins = linspace(min(yPosAll),max(yPosAll),500);
    meanTheta = zeros(numSeg+1,length(yPosBins)-1);
    meanXVel = zeros(numSeg+1,length(yPosBins)-1);
    for i=2:length(yPosBins) %for each bin
        for j=1:numSeg+1 %for each amount of evidence
            posInd = yPosAll >= yPosBins(i-1) & yPosAll < yPosBins(i); %find all indices with positions in bin
            evInd = evArrayAll == j-1; %find all indices with correct amount of evidence
            meanTheta(j,i-1) = mean(thetaAll(posInd & evInd)); %take mean of vals with both correct pos and ev
            meanXVel(j,i-1) = mean(xVelAll(posInd & evInd)); %take mean of vals with both correct pos and ev
        end
    end
    
    turnSegGUIData.xVelPlot = subplot(2,1,1);
    hold on;
    colors = distinguishable_colors(numSeg+1);
    for i=1:size(meanXVel,1) %for each line
        plot(yPosBins(2:end),meanXVel(i,:),'Color',colors(i,:),'LineWidth',2);
    end
    xlabel('Y Position');
    ylabel('X Velocity');
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
    legEnt = 0:numSeg;
    turnSegGUIData.legends(1) = legend(cellstr(num2str(legEnt')));
    
    turnSegGUIData.thetaPlot = subplot(2,1,2);
    hold on;
    for i=1:size(meanTheta,1)
        plot(yPosBins(2:end),meanTheta(i,:),'Color',colors(i,:),'LineWidth',2);
    end
    
    legEnt = 0:numSeg;
    turnSegGUIData.legends(2) = legend(cellstr(num2str(legEnt')));
    xlabel('Y Position');
    ylabel('Relative View Angle');
    ylim([-90 90]);
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
else
    turnSegGUIData.xVelPlot = subplot(2,1,1);
    colors = distinguishable_colors(numSeg+1);
    gscatter(yPosAll,xVelAll,evArrayAll,colors);
    xlabel('Y Position');
    ylabel('X Velocity');
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
    legEnt = 0:numSeg;
    turnSegGUIData.legends(1) = legend(cellstr(num2str(legEnt')));
    
    turnSegGUIData.thetaPlot = subplot(2,1,2);
    gscatter(yPosAll,thetaAll,evArrayAll,colors);
    xlabel('Y Position');
    ylabel('Relative View Angle');
    ylim([-90 90]);
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
    legEnt = 0:numSeg;
    turnSegGUIData.legends(2) = legend(cellstr(num2str(legEnt')));
end

set(turnSegGUIData.figHandle,'UserData',[turnSegGUIData.xVelPlot,turnSegGUIData.thetaPlot turnSegGUIData.legends]);

set(turnSegGUIData.printFig,'Callback',{@exportFig_CALLBACK,turnSegGUIData,true});
set(turnSegGUIData.exportFig,'Callback',{@exportFig_CALLBACK,turnSegGUIData,false});
set(turnSegGUIData.means,'Callback',{@updateMeans_CALLBACK,turnSegGUIData,evArrayAll,...
    thetaAll,xVelAll,yPosAll,numSeg,ranges});
end

function updateMeans_CALLBACK(src,evnt,turnSegGUI,evArrayAll,thetaAll,...
    xVelAll,yPosAll,numSeg,ranges)

set(0,'CurrentFigure',turnSegGUI.figHandle);
cla;

if get(turnSegGUI.means,'Value') %if means is checked
    %bin yPos
    yPosBins = linspace(min(yPosAll),max(yPosAll),500);
    meanTheta = zeros(numSeg+1,length(yPosBins)-1);
    meanXVel = zeros(numSeg+1,length(yPosBins)-1);
    for i=2:length(yPosBins) %for each bin
        for j=1:numSeg+1 %for each amount of evidence
            posInd = yPosAll >= yPosBins(i-1) & yPosAll < yPosBins(i); %find all indices with positions in bin
            evInd = evArrayAll == j-1; %find all indices with correct amount of evidence
            meanTheta(j,i-1) = mean(thetaAll(posInd & evInd)); %take mean of vals with both correct pos and ev
            meanXVel(j,i-1) = mean(xVelAll(posInd & evInd)); %take mean of vals with both correct pos and ev
        end
    end
    
    turnSegGUI.xVelPlot = subplot(2,1,1);
    hold on;
    colors = distinguishable_colors(numSeg+1);
    for i=1:size(meanXVel,1) %for each line
        plot(yPosBins(2:end),meanXVel(i,:),'Color',colors(i,:),'LineWidth',2);
    end
    xlabel('Y Position');
    ylabel('X Velocity');
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
    legEnt = 0:numSeg;
    turnSegGUI.legends(1) = legend(cellstr(num2str(legEnt')));
    
    turnSegGUI.thetaPlot = subplot(2,1,2);
    hold on;
    for i=1:size(meanTheta,1)
        plot(yPosBins(2:end),meanTheta(i,:),'Color',colors(i,:),'LineWidth',2);
    end
    
    legEnt = 0:numSeg;
    turnSegGUI.legends(2) = legend(cellstr(num2str(legEnt')));
    xlabel('Y Position');
    ylabel('Relative View Angle');
    ylim([-90 90]);
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
else
    turnSegGUI.xVelPlot = subplot(2,1,1);
    colors = distinguishable_colors(numSeg+1);
    gscatter(yPosAll,xVelAll,evArrayAll,colors);
    xlabel('Y Position');
    ylabel('X Velocity');
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
    legEnt = 0:numSeg;
    turnSegGUI.legends(1) = legend(cellstr(num2str(legEnt')));
    
    turnSegGUI.thetaPlot = subplot(2,1,2);
    gscatter(yPosAll,thetaAll,evArrayAll,colors);
    xlabel('Y Position');
    ylabel('Relative View Angle');
    ylim([-90 90]);
    for i=1:numSeg
        line([ranges(i) ranges(i)], get(gca,'ylim'),'LineStyle','--');
    end
    legEnt = 0:numSeg;
    turnSegGUI.legends(2) = legend(cellstr(num2str(legEnt')));
end

set(turnSegGUI.figHandle,'UserData',[turnSegGUI.xVelPlot,turnSegGUI.thetaPlot turnSegGUI.legends]);
end

function exportFig_CALLBACK(src,evnt,turnSegGUI,shouldPrint)
% saveFig = figure('visible','off','OuterPosition',get(turnSegGUI.figHandle,'Position'));
saveFig = turnSegGUI.figHandle;
% if ~shouldPrint
%     oldTextSize = get(integrationGUIData.textMarkers(1,1),'FontSize');
%     set(integrationGUIData.textMarkers(:),'FontSize',20);
%     oldMarkerSize = get(integrationGUIData.intScatter,'SizeData');
%     set(integrationGUIData.intScatter,'SizeData',3*oldMarkerSize);
% end

% plotHandles=get(turnSegGUI.figHandle,'UserData');
% 
% savePlot = copyobj(plotHandles,saveFig);
% savePlot = copyobj(thetaPlot,saveFig);

% if ~shouldPrint
%     set(integrationGUIData.textMarkers(:),'FontSize',oldTextSize);
%     set(integrationGUIData.intScatter,'SizeData',oldMarkerSize);
% end

if shouldPrint
    set(saveFig,'Units','Normalized','OuterPosition',[0 0 1 1],'PaperPositionMode','auto');
end

if shouldPrint
    set(savePlot,'FontSize',15);
    set(get(savePlot,'XLabel'),'FontSize',16);
    set(get(savePlot,'YLabel'),'FontSize',16);
    set(get(savePlot,'Title'),'FontSize',18);
%     axis square;
    orient landscape;
    printdlg(saveFig);
    return;
else
%     set(savePlot,'FontSize',20);
%     set(get(savePlot,'XLabel'),'FontSize',28);
%     set(get(savePlot,'YLabel'),'FontSize',28);
% %     axis square;
%     set(get(savePlot,'Title'),'FontSize',28);
end


[filename,pathname] = uiputfile({'*.eps','EPS (*.eps)';...
    '*.jpg','JPEG Image(*.jpg)';'*.fig','MATLAB Figure (*.fig)';...
    '*.png','PNG Image (*.png)';'*.tif','TIFF Image (*.tif)';...
    '*.pdf','PDF File (*.pdf)'});
if filename ~= 0
    switch upper(filename(find(filename=='.',1,'last')+1:end))
        case 'EPS'
            export_fig(saveFig,[pathname,filename],'-eps');
        case 'JPG'
            export_fig(saveFig,[pathname,filename],'-jpg');
        case 'FIG'
            saveas(saveFig,[pathname,filename],'-loose','-r300');
        case 'PNG'
            export_fig(saveFig,[pathname,filename],'-png');
        case 'TIF'
            export_fig(saveFig,[pathname,filename],'-tif');
        case 'PDF'
            export_fig(saveFig,[pathname,filename],'-pdf');
    end
end
% close(saveFig);

    
end

function exportData_CALLBACK(src,evnt,percWhite,numWhite,numTrials)
% assignin('base','percWhite',percWhite);
% assignin('base','numWhite',numWhite);
% assignin('base','numTrials',numTrials);
end