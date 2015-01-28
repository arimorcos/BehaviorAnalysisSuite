function integration_CALLBACK(src,evnt,dataCell,guiObjects,dataFlag)
%integration_CALLBACK.m Callback for the integration module
%
%Takes in dataCell designated to be fed into module callback by condition
%listbox. Opens integration gui and plots pyschometric function.
%Data/figure can then be exported to base workspace for further analysis if
%desired.

if ~isfield(dataCell{1}.maze,'numWhite') &&...
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



%open GUI
[integrationGUIData] = integrationGUI();

if flagWhite
    %calculate condition breakdown
    if flagCap
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    else
        numSeg = max(getCellVals(dataCell,'maze.numwhite'));
    end
    numConds = numSeg + 1;
    percWhite = nan(1,numConds);
    numTrials = nan(1,numConds);
    numWhite = nan(1,numConds);
    pVal = nan(1,numConds);
    percCorr = nan(1,numConds);
    results = cell(1,numConds);
    for i=0:numSeg
        if flagCap
            trialSub = getTrials(dataCell,['maze.numWhite==',num2str(i)]);
        else
            trialSub = getTrials(dataCell,['maze.numwhite==',num2str(i)]);
        end
        percWhite(i+1) = 100*sum(findTrials(trialSub,'result.whiteTurn==1'))/length(trialSub);
        numTrials(i+1) = length(trialSub);
        numWhite(i+1) = sum(findTrials(trialSub,'result.whiteTurn==1'));

        if ~isempty(trialSub)
            %determine significance
            percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
            results{i+1}(1,:) = getCellVals(trialSub,'maze.whiteTrial')';
            results{i+1}(2,:) = getCellVals(trialSub,'result.whiteTurn')';
            [dist] = shuffleTrialLabels(results{i+1},10000,false);
            pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
        end
    end
else %left
    %calculate condition breakdown
    numSeg = max(getCellVals(dataCell,'maze.numLeft'));
    numConds = numSeg + 1;
    percLeft = nan(1,numConds);
    numTrials = nan(1,numConds);
    numLeft = nan(1,numConds);
    pVal = nan(1,numConds);
    percCorr = nan(1,numConds);
    results = cell(1,numConds);
    for i=0:numSeg
        trialSub = getTrials(dataCell,['maze.numLeft==',num2str(i)]);
        percLeft(i+1) = 100*sum(findTrials(trialSub,'result.leftTurn==1'))/length(trialSub);
        numTrials(i+1) = length(trialSub);
        numLeft(i+1) = sum(findTrials(trialSub,'result.leftTurn==1'));
        
        if ~isempty(trialSub)
            %determine significance
            percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
            results{i+1}(1,:) = getCellVals(trialSub,'maze.leftTrial')';
            results{i+1}(2,:) = getCellVals(trialSub,'result.leftTurn')';
            [dist] = shuffleTrialLabels(results{i+1},10000,false);
            pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
        end
    end
end

%plot data
integrationGUIData.intPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
xlim([0 numSeg]);
if flagWhite
    integrationGUIData.intScatter = scatter(0:numSeg,percWhite,'MarkerFaceColor','b');
    ylabel('Percent Turns Toward White');
    xlabel('Number of White Dot Segments');
else
    integrationGUIData.intScatter = scatter(0:numSeg,percLeft,'MarkerFaceColor','b');
    ylabel('Percent Turns Toward Left');
    xlabel('Number of Left Dot Segments');
end
set(integrationGUIData.intPlot,'XTick',0:numSeg);
title('Integration Breakdown');
integrationGUIData.textMarkers = gobjects(3,numConds);
if flagWhite
    for i=1:numConds
        if percWhite(i) > 50
            integrationGUIData.textMarkers(1,i) = text(i-1,percWhite(i)-10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percWhite(i)-5,[num2str(round(percWhite(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'N.S.','FontWeight','Bold');
            end
        else
            integrationGUIData.textMarkers(1,i) = text(i-1,percWhite(i)+10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percWhite(i)+5,[num2str(round(percWhite(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'N.S.','FontWeight','Bold');
            end
        end
    end
else %left
    for i=1:numConds
        if percLeft(i) > 50
            integrationGUIData.textMarkers(1,i) = text(i-1,percLeft(i)-10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percLeft(i)-5,[num2str(round(percLeft(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'N.S.','FontWeight','Bold');
            end
        else
            integrationGUIData.textMarkers(1,i) = text(i-1,percLeft(i)+10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percLeft(i)+5,[num2str(round(percLeft(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'N.S.','FontWeight','Bold');
            end
        end
    end
end
ylim([0 100]);
axis square;

%setup timer
integrationGUIData.onlineTimer = timer;
set(integrationGUIData.onlineTimer,'ExecutionMode','fixedDelay','TimerFcn',...
    {@updateIntegration_CALLBACK,integrationGUIData,guiObjects,dataFlag},...
    'Period',str2double(get(guiObjects.updateInt,'String')));

%set callback for update button
set(integrationGUIData.exportFig,'Callback',{@exportFig_CALLBACK,integrationGUIData,false});
if flagWhite
    set(integrationGUIData.exportData,'Callback',{@exportData_CALLBACK,...
        flagWhite,percWhite,numWhite,numTrials,pVal});
else
    set(integrationGUIData.exportData,'Callback',{@exportData_CALLBACK,...
        flagWhite,percLeft,numLeft,numTrials,pVal});
end
set(integrationGUIData.printFig,'Callback',{@exportFig_CALLBACK,integrationGUIData,true});
set(integrationGUIData.update,'Callback',{@updateButton_CALLBACK,integrationGUIData});
set(integrationGUIData.figHandle,'CloseRequestFcn',{@closeGUI_CALLBACK,integrationGUIData});

%start timer
start(integrationGUIData.onlineTimer);
end

function exportFig_CALLBACK(src,evnt,integrationGUIData,shouldPrint)
saveFig = figure('visible','off','OuterPosition',get(integrationGUIData.figHandle,'Position'));

% if ~shouldPrint
%     oldTextSize = get(integrationGUIData.textMarkers(1,1),'FontSize');
%     set(integrationGUIData.textMarkers(:),'FontSize',20);
%     oldMarkerSize = get(integrationGUIData.intScatter,'SizeData');
%     set(integrationGUIData.intScatter,'SizeData',3*oldMarkerSize);
% end

savePlot = copyobj(integrationGUIData.intPlot,saveFig);

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
            export_fig(saveFig,[pathname,filename],'-jpg','-transparent');
        case 'FIG'
            saveas(saveFig,[pathname,filename],'-loose','-r300');
        case 'PNG'
            export_fig(saveFig,[pathname,filename],'-png','-transparent');
        case 'TIF'
            export_fig(saveFig,[pathname,filename],'-tif','-transparent');
        case 'PDF'
            export_fig(saveFig,[pathname,filename],'-pdf');
    end
end
close(saveFig);

    
end

function exportData_CALLBACK(src,evnt,flagWhite,percSeg,numSeg,numTrials,pVal)
if flagWhite
    assignin('base','percWhite',percSeg);
    assignin('base','numWhite',numSeg);
    assignin('base','numTrials',numTrials);
    assignin('base','pVal',pVal);
else
    assignin('base','percLeft',percSeg);
    assignin('base','numLeft',numSeg);
    assignin('base','numTrials',numTrials);
    assignin('base','pVal',pVal);
end
end

function updateButton_CALLBACK(src,evnt,integrationGUIData)
%get value of button
buttonVal = get(integrationGUIData.update,'Value');

if buttonVal %if button pressed down
    start(integrationGUIData.onlineTimer);
else
    stop(integrationGUIData.onlineTimer);
end

end

function updateIntegration_CALLBACK(src,evnt,integrationGUIData,guiObjects,dataFlag)
%get datasets
modData = get(guiObjects.modData,'UserData');
if regexp(dataFlag,'ALL')
    dataCell = modData.datasets.all;
elseif regexp(dataFlag,'LAST')
    dataCell = modData.datasets.lastX;
elseif regexp(dataFlag,'COND')
    condNum = str2double(dataFlag(end));
    dataCell = modData.datasets.condition{condNum};
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

if flagWhite
    %calculate condition breakdown
    if flagCap
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    else
        numSeg = max(getCellVals(dataCell,'maze.numwhite'));
    end
    numConds = numSeg + 1;
    percWhite = nan(1,numConds);
    numTrials = nan(1,numConds);
    numWhite = nan(1,numConds);
    pVal = nan(1,numConds);
    percCorr = nan(1,numConds);
    results = cell(1,numConds);
    for i=0:numSeg
        if flagCap
            trialSub = getTrials(dataCell,['maze.numWhite==',num2str(i)]);
        else
            trialSub = getTrials(dataCell,['maze.numwhite==',num2str(i)]);
        end
        percWhite(i+1) = 100*sum(findTrials(trialSub,'result.whiteTurn==1'))/length(trialSub);
        numTrials(i+1) = length(trialSub);
        numWhite(i+1) = sum(findTrials(trialSub,'result.whiteTurn==1'));

        if ~isempty(trialSub)
            %determine significance
            percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
            results{i+1}(1,:) = getCellVals(trialSub,'maze.whiteTrial')';
            results{i+1}(2,:) = getCellVals(trialSub,'result.whiteTurn')';
            [dist] = shuffleTrialLabels(results{i+1},10000,false);
            pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
        end
    end
else %left
    %calculate condition breakdown
    numSeg = max(getCellVals(dataCell,'maze.numLeft'));
    numConds = numSeg + 1;
    percLeft = nan(1,numConds);
    numTrials = nan(1,numConds);
    numLeft = nan(1,numConds);
    pVal = nan(1,numConds);
    percCorr = nan(1,numConds);
    results = cell(1,numConds);
    for i=0:numSeg
        trialSub = getTrials(dataCell,['maze.numLeft==',num2str(i)]);
        percLeft(i+1) = 100*sum(findTrials(trialSub,'result.leftTurn==1'))/length(trialSub);
        numTrials(i+1) = length(trialSub);
        numLeft(i+1) = sum(findTrials(trialSub,'result.leftTurn==1'));
        
        if ~isempty(trialSub)
            %determine significance
            percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
            results{i+1}(1,:) = getCellVals(trialSub,'maze.leftTrial')';
            results{i+1}(2,:) = getCellVals(trialSub,'result.leftTurn')';
            [dist] = shuffleTrialLabels(results{i+1},10000,false);
            pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
        end
    end
end

%plot data
set(0,'CurrentFigure',integrationGUIData.figHandle); %set current figure to background by directly accessing current figure property
integrationGUIData.intPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
ylim([0 100]);
xlim([0 numSeg]);
if flagWhite
    integrationGUIData.intScatter = scatter(0:numSeg,percWhite,'MarkerFaceColor','b');
    ylabel('Percent Turns Toward White');
    xlabel('Number of White Dot Segments');
else
    integrationGUIData.intScatter = scatter(0:numSeg,percLeft,'MarkerFaceColor','b');
    ylabel('Percent Turns Toward Left');
    xlabel('Number of Left Dot Segments');
end
set(integrationGUIData.intPlot,'XTick',0:numSeg);
title('Integration Breakdown');
integrationGUIData.textMarkers = gobjects(3,numConds);
if flagWhite
    for i=1:numConds
        if percWhite(i) > 50
            integrationGUIData.textMarkers(1,i) = text(i-1,percWhite(i)-10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percWhite(i)-5,[num2str(round(percWhite(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'N.S.','FontWeight','Bold');
            end
        else
            integrationGUIData.textMarkers(1,i) = text(i-1,percWhite(i)+10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percWhite(i)+5,[num2str(round(percWhite(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'N.S.','FontWeight','Bold');
            end
        end
    end
else %left
    for i=1:numConds
        if percLeft(i) > 50
            integrationGUIData.textMarkers(1,i) = text(i-1,percLeft(i)-10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percLeft(i)-5,[num2str(round(percLeft(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'N.S.','FontWeight','Bold');
            end
        else
            integrationGUIData.textMarkers(1,i) = text(i-1,percLeft(i)+10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percLeft(i)+5,[num2str(round(percLeft(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'N.S.','FontWeight','Bold');
            end
        end
    end
end
ylim([0 100]);
axis square;

%set callback for update button
set(integrationGUIData.exportFig,'Callback',{@exportFig_CALLBACK,integrationGUIData,false});
if flagWhite
    set(integrationGUIData.exportData,'Callback',{@exportData_CALLBACK,...
        flagWhite,percWhite,numWhite,numTrials,pVal});
else
    set(integrationGUIData.exportData,'Callback',{@exportData_CALLBACK,...
        flagWhite,percLeft,numLeft,numTrials,pVal});
end
set(integrationGUIData.printFig,'Callback',{@exportFig_CALLBACK,integrationGUIData,true});
end

function closeGUI_CALLBACK(src,evnt,integrationGUIData)

stop(integrationGUIData.onlineTimer);

delete(integrationGUIData.figHandle);
end