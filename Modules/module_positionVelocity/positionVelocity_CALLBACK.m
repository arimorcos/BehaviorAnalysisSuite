function positionVelocity_CALLBACK(src,evnt,dataCell,data,dataCellInd)
%trialVelocity_CALLBACK.m callback function to generate trial velocity
%module

%open GUI
posVelGUIData = posVelGUI();

%get trial velocities
[xVelLeft,xVelRight,yVelLeft,yVelRight,vel] =...
    getTrialVelocity(data,dataCell,dataCellInd);

%get trial positions
[xPosLeft,xPosRight,yPosLeft,yPosRight,thetaLeft,thetaRight,pos] =...
    getTrialPositions(data,dataCell,dataCellInd);

%calculate means and standard error
nBins = 100;
nLeft = length(xVelLeft);
nRight = length(xVelRight);
[binArrayLeft{1:nLeft,1}] = deal(nBins);
[binArrayRight{1:nRight,1}] = deal(nBins);

xVelLeftBinned = cell2mat(cellfun(@binVals,xVelLeft,binArrayLeft,'UniformOutput',false));
xVelRightBinned = cell2mat(cellfun(@binVals,xVelRight,binArrayRight,'UniformOutput',false));
xVelLeftMean = mean(xVelLeftBinned);
xVelLeftSEM = std(xVelLeftBinned)/sqrt(nLeft);
xVelRightMean = mean(xVelRightBinned);
xVelRightSEM = std(xVelRightBinned)/sqrt(nRight);

xPosLeftBinned = cell2mat(cellfun(@binVals,xPosLeft,binArrayLeft,'UniformOutput',false));
xPosRightBinned = cell2mat(cellfun(@binVals,xPosRight,binArrayRight,'UniformOutput',false));
xPosLeftMean = mean(xPosLeftBinned);
xPosLeftSEM = std(xPosLeftBinned)/sqrt(nLeft);
xPosRightMean = mean(xPosRightBinned);
xPosRightSEM = std(xPosRightBinned)/sqrt(nRight);

yVelLeftBinned = cell2mat(cellfun(@binVals,yVelLeft,binArrayLeft,'UniformOutput',false));
yVelRightBinned = cell2mat(cellfun(@binVals,yVelRight,binArrayRight,'UniformOutput',false));
yVelLeftMean = mean(yVelLeftBinned);
yVelLeftSEM = std(yVelLeftBinned)/sqrt(nLeft);
yVelRightMean = mean(yVelRightBinned);
yVelRightSEM = std(yVelRightBinned)/sqrt(nRight);

yPosLeftBinned = cell2mat(cellfun(@binVals,yPosLeft,binArrayLeft,'UniformOutput',false));
yPosRightBinned = cell2mat(cellfun(@binVals,yPosRight,binArrayRight,'UniformOutput',false));
yPosLeftMean = mean(yPosLeftBinned);
yPosLeftSEM = std(yPosLeftBinned)/sqrt(nLeft);
yPosRightMean = mean(yPosRightBinned);
yPosRightSEM = std(yPosRightBinned)/sqrt(nRight);

thetaLeftBinned = cell2mat(cellfun(@binVals,thetaLeft,binArrayLeft,'UniformOutput',false));
thetaRightBinned = cell2mat(cellfun(@binVals,thetaRight,binArrayRight,'UniformOutput',false));
thetaLeftMean = mean(thetaLeftBinned);
thetaLeftSEM = std(thetaLeftBinned)/sqrt(nLeft);
thetaRightMean = mean(thetaRightBinned);
thetaRightSEM = std(thetaRightBinned)/sqrt(nRight);

%plot
trialCheck = get(posVelGUIData.indTrials,'Value');
if trialCheck %if individual trials checked
    
    %get fraction
    frac = str2double(get(posVelGUIData.fracTrials,'String'));
    if frac>1; frac =1;end
    nLeft = round(frac*size(yVelLeft,1));
    nRight = round(frac*size(yVelRight,1));
    trialArrayLeft = randsample(size(yVelLeft,1),nLeft);
    trialArrayRight = randsample(size(yVelRight,1),nRight);
    
    %get trial lengths
    trialLengthsLeft = cell2mat(cellfun(@(x) length(x),xVelLeft,'UniformOutput',false));
    trialLengthsRight = cell2mat(cellfun(@(x) length(x),xVelRight,'UniformOutput',false));
    
    set(0,'CurrentFigure',posVelGUIData.figHandle); %set current figure to background by directly accessing current figure property
    
    %Y velocity
    posVelGUIData.yVelPlot = subplot(6,1,1,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.yVelLeftLines = nan(1,size(yVelLeft,1));
    posVelGUIData.yVelRightLines = gobjects(1,size(yVelRight,1));
    for i=1:nLeft
        posVelGUIData.yVelLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),...
            yVelLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.yVelRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),yVelRight{trialArrayRight(i),:},'b');
    end
    posVelGUIData.YVelTitle = title('Positions and Velocities','fontsize',15);
    set(gca,'fontsize',12);
    posVelGUIData.YVelyLabel = ylabel('Y Velocity','fontsize',15);
    posVelGUIData.yVelLegend = legend([posVelGUIData.yVelLeftLines(1);...
        posVelGUIData.yVelRightLines(1)],{'Left';'Right'},'Location','NorthWest');
    
    %X velocity
    posVelGUIData.xVelPlot = subplot(6,1,2,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.xVelLeftLines = nan(1,size(xVelLeft,1));
    posVelGUIData.xVelRightLines = gobjects(1,size(xVelRight,1));
    for i=1:nLeft
        posVelGUIData.xVelLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),xVelLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.xVelRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),xVelRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    lim = 5 + abs(max([xVelLeftBinned(:); xVelRightBinned(:)]));
    ylim([-lim lim]);
    posVelGUIData.xVelyLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelLegend = legend([posVelGUIData.xVelLeftLines(1);...
        posVelGUIData.xVelRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %y position
    posVelGUIData.yPosPlot = subplot(6,1,3,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.yPosLeftLines = gobjects(1,size(yPosLeft,1));
    posPosGUIData.yPosRightLines = nan(1,size(yPosRight,1));
    for i=1:nLeft
        posVelGUIData.yPosLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),yPosLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.yPosRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),yPosRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    posVelGUIData.YPosyLabel = ylabel('Y Position','fontsize',15);
    posVelGUIData.yPosLegend = legend([posVelGUIData.yPosLeftLines(1);...
        posVelGUIData.yPosRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %x position
    posVelGUIData.xPosPlot = subplot(6,1,4,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.xPosLeftLines = gobjects(1,size(xPosLeft,1));
    posPosGUIData.xPosRightLines = nan(1,size(xPosRight,1));
    for i=1:nLeft
        posVelGUIData.xPosLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),xPosLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.xPosRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),xPosRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    lim = 5 + abs(max([xPosLeftBinned(:); xPosRightBinned(:)]));
    ylim([-lim lim]);
    posVelGUIData.xPosyLabel = ylabel('X Position','fontsize',15);
    posVelGUIData.xPosLegend = legend([posVelGUIData.xPosLeftLines(1);...
        posVelGUIData.xPosRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %theta
    posVelGUIData.thetaPlot = subplot(6,1,5,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.thetaLeftLines = gobjects(1,size(thetaLeft,1));
    posPosGUIData.thetaRightLines = nan(1,size(thetaRight,1));
    for i=1:nLeft
        posVelGUIData.thetaLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),thetaLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.thetaRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),thetaRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
%     ylim([0 360]);
    ylim([70 110]);
    posVelGUIData.thetaLegend = legend([posVelGUIData.thetaLeftLines(1);...
        posVelGUIData.thetaRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.thetaYLabel = ylabel('View Angle (degrees)','fontsize',15);
    posVelGUIData.thetaXLabel = xlabel('Normalized Trial Time','fontsize',15);
    
    %xVel vs. yPos
    posVelGUIData.xVelYPosPlot = subplot(6,1,6,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.xVelYPosLeftLines = gobjects(1,size(xVelLeft,1));
    posPosGUIData.xVelYPosRightLines = nan(1,size(xVelRight,1));
    for i=1:nLeft
        posVelGUIData.xVelYPosLeftLines(i) =...
            plot(yPosLeft(trialArrayLeft(i)),xVelLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.xVelYPosRightLines(i) =...
            plot(yPosRight(trialArrayRight(i)),xVelRight{trialArrayRight(i),:},'b');
    end
    lim = 5 + abs(max([xVelLeftBinned(:); xVelRightBinned(:)]));
    ylim([-lim lim]);
    xlim([min([yPosLeft(:); yPosRight(:)]) max([yPosLeft(:) yPosRight(:)])]);
    set(gca,'fontsize',12);
    posVelGUIData.xVelYPosLegend = legend([posVelGUIData.xVelYPosLeftLines(1);...
        posVelGUIData.xVelYPosRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.xVelYPosYLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelYPosXLabel = xlabel('Y Position (ViRMEn Units)','fontsize',15);
    
else
    normLength = linspace(0,1,nBins);
    set(0,'CurrentFigure',posVelGUIData.figHandle); %set current figure to background by directly accessing current figure property
    
    %Y velocity
    posVelGUIData.yVelPlot = subplot(6,1,1,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.yVelLeftLine = shadedErrorBar(normLength,yVelLeftMean,yVelLeftSEM,'r');
    hold on;
    posVelGUIData.yVelRightLine = shadedErrorBar(normLength,yVelRightMean,yVelRightSEM,'b');
    posVelGUIData.YVelTitle = title('Positions and Velocities','fontsize',15);
    set(gca,'fontsize',12);
    posVelGUIData.YVelyLabel = ylabel('Y Velocity','fontsize',15);
    posVelGUIData.yVelLegend = legend([posVelGUIData.yVelLeftLine.mainLine;...
        posVelGUIData.yVelRightLine.mainLine],{'Left';'Right'},'Location','NorthWest');
    
    %X velocity
    posVelGUIData.xVelPlot = subplot(6,1,2,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.xVelLeftLine = shadedErrorBar(normLength,xVelLeftMean,xVelLeftSEM,'r');
    hold on;
    posVelGUIData.xVelRightLine = shadedErrorBar(normLength,xVelRightMean,xVelRightSEM,'b');
    set(gca,'fontsize',12);
    lim = 5 + max(abs([xVelRightMean xVelLeftMean])) + max(abs([xVelLeftSEM xVelRightSEM]));
    ylim([-lim lim]);
    posVelGUIData.xVelyLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelLegend = legend([posVelGUIData.xVelLeftLine.mainLine;...
        posVelGUIData.xVelRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %y position
    posVelGUIData.yPosPlot = subplot(6,1,3,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.yPosLeftLine = shadedErrorBar(normLength,yPosLeftMean,yPosLeftSEM,'r');
    hold on;
    posVelGUIData.yPosRightLine = shadedErrorBar(normLength,yPosRightMean,yPosRightSEM,'b');
    set(gca,'fontsize',12);
    posVelGUIData.YPosyLabel = ylabel('Y Position','fontsize',15);
    posVelGUIData.yPosLegend = legend([posVelGUIData.yPosLeftLine.mainLine;...
        posVelGUIData.yPosRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %x position
    posVelGUIData.xPosPlot = subplot(6,1,4,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.xPosLeftLine = shadedErrorBar(normLength,xPosLeftMean,xPosLeftSEM,'r');
    hold on;
    posVelGUIData.xPosRightLine = shadedErrorBar(normLength,xPosRightMean,xPosRightSEM,'b');
    set(gca,'fontsize',12);
    lim = 5 + abs(max([xPosRightMean xPosLeftMean])) + abs(max([xPosLeftSEM xPosRightSEM]));
    ylim([-lim lim]);
    posVelGUIData.xPosyLabel = ylabel('X Position','fontsize',15);
    posVelGUIData.xPosLegend = legend([posVelGUIData.xPosLeftLine.mainLine;...
        posVelGUIData.xPosRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %theta
    posVelGUIData.thetaPlot = subplot(6,1,5,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.thetaLeftLine = shadedErrorBar(normLength,thetaLeftMean,thetaLeftSEM,'r');
    hold on;
    posVelGUIData.thetaRightLine = shadedErrorBar(normLength,thetaRightMean,thetaRightSEM,'b');
    set(gca,'fontsize',12);
    ylim([0 360]);
    posVelGUIData.thetaLegend = legend([posVelGUIData.thetaLeftLine.mainLine;...
        posVelGUIData.thetaRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.thetaYLabel = ylabel('View Angle (degrees)','fontsize',15);
    posVelGUIData.YVelxLabel = xlabel('Normalized Trial Time','fontsize',15);
    
    %xVel vs. yPos
    posVelGUIData.xVelYPosPlot = subplot(6,1,6,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.xVelYPosLeftLine = shadedErrorBar(yPosLeftMean,xVelLeftMean,xVelLeftSEM,'r');
    hold on;
    posVelGUIData.xVelYPosRightLine = shadedErrorBar(yPosRightMean,xVelRightMean,xVelRightSEM,'b');
    set(gca,'fontsize',12);
    lim = 5 + max(abs([xVelRightMean xVelLeftMean])) + max(abs([xVelLeftSEM xVelRightSEM]));
    ylim([-lim lim]);
    xlim([min([yPosLeftMean yPosRightMean]) max([yPosLeftMean yPosRightMean])]);
    posVelGUIData.xVelYPosLegend = legend([posVelGUIData.xVelYPosLeftLine.mainLine;...
        posVelGUIData.xVelYPosRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.xVelYPosYLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelYPosXLabel = xlabel('Y Position (ViRMEn Units)','fontsize',15);
end

%turn off legends
set(posVelGUIData.xVelLegend,'visible','off');
set(posVelGUIData.xPosLegend,'visible','off');
set(posVelGUIData.yPosLegend,'visible','off');
set(posVelGUIData.thetaLegend,'visible','off');

%set callback for buttons
set(posVelGUIData.exportFig,'Callback',{@exportFig_CALLBACK,posVelGUIData,false});
set(posVelGUIData.exportData,'Callback',{@exportData_CALLBACK,xVelLeft,xVelRight,...
    yVelLeft,yVelRight,vel,xPosLeft,xPosRight,thetaLeft,...
    thetaRight,yPosLeft,yPosRight,pos});
set(posVelGUIData.printFig,'Callback',{@exportFig_CALLBACK,posVelGUIData,true});
set([posVelGUIData.indTrials posVelGUIData.fracTrials],'Callback',{@updateFig_CALLBACK,...
    posVelGUIData,xVelLeft,xVelRight,...
    yVelLeft,yVelRight,xPosLeft,xPosRight,thetaLeft,...
    thetaRight,yPosLeft,yPosRight,xVelLeftMean,xVelLeftSEM,...
    xVelRightMean,xVelRightSEM,xPosLeftMean,xPosLeftSEM,xPosRightMean,...
    xPosRightSEM,yVelLeftMean,yVelLeftSEM,yVelRightMean,yVelRightSEM,...
    yPosLeftMean,yPosLeftSEM,yPosRightMean,yPosRightSEM,thetaLeftMean,...
    thetaLeftSEM,thetaRightMean,thetaRightSEM,xVelLeftBinned,xVelRightBinned,...
    xPosLeftBinned,xPosRightBinned,nBins});
end

function exportData_CALLBACK(src,evnt,xVelLeftMat,xVelRightMat,...
    yVelLeftMat,yVelRightMat,vel,xPosLeftMat,xPosRightMat,thetaLeftMat,...
    thetaRightMat,yPosLeftMat,yPosRightMat,pos)
assignin('base','xVelLeftMat',xVelLeftMat);
assignin('base','xVelRightMat',xVelRightMat);
assignin('base','yVelLeftMat',yVelLeftMat);
assignin('base','yVelRightMat',yVelRightMat);
assignin('base','vel',vel);
assignin('base','xPosLeftMat',xPosLeftMat);
assignin('base','xPosRightMat',xPosRightMat);
assignin('base','thetaLeftMat',thetaLeftMat);
assignin('base','thetaRightMat',thetaRightMat);
assignin('base','yPosLeftMat',yPosLeftMat);
assignin('base','yPosRightMat',yPosRightMat);
assignin('base','pos',pos);
end

function exportFig_CALLBACK(src,evnt,trialVelGUIData,shouldPrint)
exportPosVelGUI(trialVelGUIData,shouldPrint);
end

function updateFig_CALLBACK(src,evnt,posVelGUIData,xVelLeft,xVelRight,...
    yVelLeft,yVelRight,xPosLeft,xPosRight,thetaLeft,...
    thetaRight,yPosLeft,yPosRight,xVelLeftMean,xVelLeftSEM,...
    xVelRightMean,xVelRightSEM,xPosLeftMean,xPosLeftSEM,xPosRightMean,...
    xPosRightSEM,yVelLeftMean,yVelLeftSEM,yVelRightMean,yVelRightSEM,...
    yPosLeftMean,yPosLeftSEM,yPosRightMean,yPosRightSEM,thetaLeftMean,...
    thetaLeftSEM,thetaRightMean,thetaRightSEM,xVelLeftBinned,xVelRightBinned,...
    xPosLeftBinned,xPosRightBinned,nBins)

%clear axes
set(0,'CurrentFigure',posVelGUIData.figHandle); %set current figure to background by directly accessing current figure property
delete([posVelGUIData.yVelPlot posVelGUIData.xVelPlot ...
     posVelGUIData.yPosPlot posVelGUIData.xPosPlot posVelGUIData.thetaPlot]);

%plot
trialCheck = get(posVelGUIData.indTrials,'Value');
if trialCheck %if individual trials checked
    
    %get fraction
    frac = str2double(get(posVelGUIData.fracTrials,'String'));
    if frac>1; frac =1;end
    nLeft = round(frac*size(yVelLeft,1));
    nRight = round(frac*size(yVelRight,1));
    trialArrayLeft = randsample(size(yVelLeft,1),nLeft);
    trialArrayRight = randsample(size(yVelRight,1),nRight);
    
    %get trial lengths
    trialLengthsLeft = cell2mat(cellfun(@(x) length(x),xVelLeft,'UniformOutput',false));
    trialLengthsRight = cell2mat(cellfun(@(x) length(x),xVelRight,'UniformOutput',false));
    
    set(0,'CurrentFigure',posVelGUIData.figHandle); %set current figure to background by directly accessing current figure property
    
    %Y velocity
    posVelGUIData.yVelPlot = subplot(6,1,1,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.yVelLeftLines = nan(1,size(yVelLeft,1));
    posVelGUIData.yVelRightLines = gobjects(1,size(yVelRight,1));
    for i=1:nLeft
        posVelGUIData.yVelLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),...
            yVelLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.yVelRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),yVelRight{trialArrayRight(i),:},'b');
    end
    posVelGUIData.YVelTitle = title('Positions and Velocities','fontsize',15);
    set(gca,'fontsize',12);
    posVelGUIData.YVelyLabel = ylabel('Y Velocity','fontsize',15);
    posVelGUIData.yVelLegend = legend([posVelGUIData.yVelLeftLines(1);...
        posVelGUIData.yVelRightLines(1)],{'Left';'Right'},'Location','NorthWest');
    
    %X velocity
    posVelGUIData.xVelPlot = subplot(6,1,2,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.xVelLeftLines = nan(1,size(xVelLeft,1));
    posVelGUIData.xVelRightLines = gobjects(1,size(xVelRight,1));
    for i=1:nLeft
        posVelGUIData.xVelLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),xVelLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.xVelRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),xVelRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    lim = 5 + max(abs([xVelLeftBinned(:); xVelRightBinned(:)]));
    ylim([-lim lim]);
    posVelGUIData.xVelyLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelLegend = legend([posVelGUIData.xVelLeftLines(1);...
        posVelGUIData.xVelRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %y position
    posVelGUIData.yPosPlot = subplot(6,1,3,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.yPosLeftLines = gobjects(1,size(yPosLeft,1));
    posPosGUIData.yPosRightLines = nan(1,size(yPosRight,1));
    for i=1:nLeft
        posVelGUIData.yPosLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),yPosLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.yPosRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),yPosRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    posVelGUIData.YPosyLabel = ylabel('Y Position','fontsize',15);
    posVelGUIData.yPosLegend = legend([posVelGUIData.yPosLeftLines(1);...
        posVelGUIData.yPosRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %x position
    posVelGUIData.xPosPlot = subplot(6,1,4,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.xPosLeftLines = gobjects(1,size(xPosLeft,1));
    posPosGUIData.xPosRightLines = nan(1,size(xPosRight,1));
    for i=1:nLeft
        posVelGUIData.xPosLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),xPosLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.xPosRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),xPosRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    lim = 5 + abs(max([xPosLeftBinned(:); xPosRightBinned(:)]));
    ylim([-lim lim]);
    posVelGUIData.xPosyLabel = ylabel('X Position','fontsize',15);
    posVelGUIData.xPosLegend = legend([posVelGUIData.xPosLeftLines(1);...
        posVelGUIData.xPosRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %theta
    posVelGUIData.thetaPlot = subplot(6,1,5,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.thetaLeftLines = gobjects(1,size(thetaLeft,1));
    posPosGUIData.thetaRightLines = nan(1,size(thetaRight,1));
    for i=1:nLeft
        posVelGUIData.thetaLeftLines(i) = plot(linspace(0,1,trialLengthsLeft(trialArrayLeft(i))),thetaLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.thetaRightLines(i) = plot(linspace(0,1,trialLengthsRight(trialArrayRight(i))),thetaRight{trialArrayRight(i),:},'b');
    end
    set(gca,'fontsize',12);
    ylim([0 360]);
    posVelGUIData.thetaLegend = legend([posVelGUIData.thetaLeftLines(1);...
        posVelGUIData.thetaRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.thetaYLabel = ylabel('View Angle (degrees)','fontsize',15);
    posVelGUIData.thetaXLabel = xlabel('Normalized Trial Time','fontsize',15);
    
    %xVel vs. yPos
    posVelGUIData.xVelYPosPlot = subplot(6,1,6,'Parent',posVelGUIData.plotPanel);
    hold on;
    posVelGUIData.xVelYPosLeftLines = gobjects(1,size(xVelLeft,1));
    posPosGUIData.xVelYPosRightLines = nan(1,size(xVelRight,1));
    for i=1:nLeft
        posVelGUIData.xVelYPosLeftLines(i) =...
            plot(yPosLeft{trialArrayLeft(i)},xVelLeft{trialArrayLeft(i),:},'r');
    end
    for i=1:nRight
        posVelGUIData.xVelYPosRightLines(i) =...
            plot(yPosRight{trialArrayRight(i)},xVelRight{trialArrayRight(i),:},'b');
    end
    lim = 5 + max(abs([xVelLeftBinned(:); xVelRightBinned(:)]));
    ylim([-lim lim]);
    xlim([min([yPosLeft{:} yPosRight{:}]) max([yPosLeft{:} yPosRight{:}])]);
    set(gca,'fontsize',12);
    posVelGUIData.xVelYPosLegend = legend([posVelGUIData.xVelYPosLeftLines(1);...
        posVelGUIData.xVelYPosRightLines(1)],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.xVelYPosYLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelYPosXLabel = xlabel('Y Position (ViRMEn Units)','fontsize',15);
    
else
    normLength = linspace(0,1,nBins);
    set(0,'CurrentFigure',posVelGUIData.figHandle); %set current figure to background by directly accessing current figure property
    
    %Y velocity
    posVelGUIData.yVelPlot = subplot(6,1,1,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.yVelLeftLine = shadedErrorBar(normLength,yVelLeftMean,yVelLeftSEM,'r');
    hold on;
    posVelGUIData.yVelRightLine = shadedErrorBar(normLength,yVelRightMean,yVelRightSEM,'b');
    posVelGUIData.YVelTitle = title('Positions and Velocities','fontsize',15);
    set(gca,'fontsize',12);
    posVelGUIData.YVelyLabel = ylabel('Y Velocity','fontsize',15);
    posVelGUIData.yVelLegend = legend([posVelGUIData.yVelLeftLine.mainLine;...
        posVelGUIData.yVelRightLine.mainLine],{'Left';'Right'},'Location','NorthWest');
    
    %X velocity
    posVelGUIData.xVelPlot = subplot(6,1,2,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.xVelLeftLine = shadedErrorBar(normLength,xVelLeftMean,xVelLeftSEM,'r');
    hold on;
    posVelGUIData.xVelRightLine = shadedErrorBar(normLength,xVelRightMean,xVelRightSEM,'b');
    set(gca,'fontsize',12);
    lim = 5 + max(abs([xVelRightMean xVelLeftMean])) + max(abs([xVelLeftSEM xVelRightSEM]));
    ylim([-lim lim]);
    posVelGUIData.xVelyLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelLegend = legend([posVelGUIData.xVelLeftLine.mainLine;...
        posVelGUIData.xVelRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %y position
    posVelGUIData.yPosPlot = subplot(6,1,3,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.yPosLeftLine = shadedErrorBar(normLength,yPosLeftMean,yPosLeftSEM,'r');
    hold on;
    posVelGUIData.yPosRightLine = shadedErrorBar(normLength,yPosRightMean,yPosRightSEM,'b');
    set(gca,'fontsize',12);
    posVelGUIData.YPosyLabel = ylabel('Y Position','fontsize',15);
    posVelGUIData.yPosLegend = legend([posVelGUIData.yPosLeftLine.mainLine;...
        posVelGUIData.yPosRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %x position
    posVelGUIData.xPosPlot = subplot(6,1,4,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.xPosLeftLine = shadedErrorBar(normLength,xPosLeftMean,xPosLeftSEM,'r');
    hold on;
    posVelGUIData.xPosRightLine = shadedErrorBar(normLength,xPosRightMean,xPosRightSEM,'b');
    set(gca,'fontsize',12);
    lim = 5 + abs(max([xPosRightMean xPosLeftMean])) + abs(max([xPosLeftSEM xPosRightSEM]));
    ylim([-lim lim]);
    posVelGUIData.xPosyLabel = ylabel('X Position','fontsize',15);
    posVelGUIData.xPosLegend = legend([posVelGUIData.xPosLeftLine.mainLine;...
        posVelGUIData.xPosRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    
    %theta
    posVelGUIData.thetaPlot = subplot(6,1,5,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.thetaLeftLine = shadedErrorBar(normLength,thetaLeftMean,thetaLeftSEM,'r');
    hold on;
    posVelGUIData.thetaRightLine = shadedErrorBar(normLength,thetaRightMean,thetaRightSEM,'b');
    set(gca,'fontsize',12);
    ylim([0 360]);
    posVelGUIData.thetaLegend = legend([posVelGUIData.thetaLeftLine.mainLine;...
        posVelGUIData.thetaRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.thetaYLabel = ylabel('View Angle (degrees)','fontsize',15);
    posVelGUIData.YVelxLabel = xlabel('Normalized Trial Time','fontsize',15);
    
    %xVel vs. yPos
    posVelGUIData.xVelYPosPlot = subplot(6,1,6,'Parent',posVelGUIData.plotPanel);
    posVelGUIData.xVelYPosLeftLine = shadedErrorBar(yPosLeftMean,xVelLeftMean,xVelLeftSEM,'r');
    hold on;
    posVelGUIData.xVelYPosRightLine = shadedErrorBar(yPosRightMean,xVelRightMean,xVelRightSEM,'b');
    set(gca,'fontsize',12);
    lim = 5 + max(abs([xVelRightMean xVelLeftMean])) + max(abs([xVelLeftSEM xVelRightSEM]));
    ylim([-lim lim]);
    xlim([min([yPosLeft(:); yPosRight(:)]) max([yPosLeft(:) yPosRight(:)])]);
    posVelGUIData.xVelYPosLegend = legend([posVelGUIData.xVelYPosLeftLine.mainLine;...
        posVelGUIData.xVelYPosRightLine.mainLine],{'Left';'Right'},'Location','NorthWest',...
        'visible','off');
    posVelGUIData.xVelYPosYLabel = ylabel('X Velocity','fontsize',15);
    posVelGUIData.xVelYPosXLabel = xlabel('Y Position (ViRMEn Units)','fontsize',15);
end

%turn off legends
set(posVelGUIData.xVelLegend,'visible','off');
set(posVelGUIData.xPosLegend,'visible','off');
set(posVelGUIData.yPosLegend,'visible','off');
set(posVelGUIData.thetaLegend,'visible','off');

%update callbacks
set(posVelGUIData.exportFig,'Callback',{@exportFig_CALLBACK,posVelGUIData,false});
set(posVelGUIData.printFig,'Callback',{@exportFig_CALLBACK,posVelGUIData,true});
set([posVelGUIData.indTrials posVelGUIData.fracTrials],'Callback',{@updateFig_CALLBACK,...
    posVelGUIData,xVelLeft,xVelRight,...
    yVelLeft,yVelRight,xPosLeft,xPosRight,thetaLeft,...
    thetaRight,yPosLeft,yPosRight,xVelLeftMean,xVelLeftSEM,...
    xVelRightMean,xVelRightSEM,xPosLeftMean,xPosLeftSEM,xPosRightMean,...
    xPosRightSEM,yVelLeftMean,yVelLeftSEM,yVelRightMean,yVelRightSEM,...
    yPosLeftMean,yPosLeftSEM,yPosRightMean,yPosRightSEM,thetaLeftMean,...
    thetaLeftSEM,thetaRightMean,thetaRightSEM,xVelLeftBinned,xVelRightBinned,...
    xPosLeftBinned,xPosRightBinned,nBins});
end

function binMeans = binVals(vals,nBins)

binStarts = round(linspace(1,length(vals)-(length(vals)/nBins),nBins)); %determine bin starts
binEnds = [binStarts(2:end)-1 length(vals)]; %deteremine bin ends

binMeans = nan(1,nBins);
for i=1:nBins %for each bin
    binMeans(i) = mean(vals(binStarts(i):binEnds(i)));
end
end


