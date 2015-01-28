function behavWeights_CALLBACK(src,evnt,dataCell,guiObjects,dataFlag)
%behavWeights_CALLBACK.m Callback for the integration module
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
[behavGUI] = behavWeightsGUI();

if flagWhite
    %get explanatory variables (segments)
    numTrials = length(dataCell);
    if flagCap
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    else
        numSeg = max(getCellVals(dataCell,'maze.numwhite'));
    end
    segVals = zeros(numTrials,numSeg);
    for i=1:numTrials
        segVals(i,dataCell{i}.maze.whiteDots') = 1;
    end

    %get response variables (turns toward white)
    whiteTurns = getCellVals(dataCell,'result.whiteTurn')';

    %perform regression
    [beta,betaConf,r,rConf] = regress(whiteTurns,segVals);

    %plot data
    behavGUI.behavPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
    behavGUI.behavScatter = errorbar(1:length(beta),beta,beta-betaConf(:,1),abs(beta-betaConf(:,2)),...
        'bo','MarkerFaceColor','b','MarkerSize',10,'LineStyle','none');
    xlim([0 length(beta)+1]);
    ylabel('Beta');
    xlabel('Segment Number');
    set(behavGUI.behavPlot,'XTick',1:length(beta));
    title('Behavioral Weights');
else
    %get explanatory variables (segments)
    numTrials = length(dataCell);
    numSeg = max(getCellVals(dataCell,'maze.numLeft'));
    segVals = zeros(numTrials,numSeg);
    for i=1:numTrials
        segVals(i,dataCell{i}.maze.leftDotLoc') = 1;
    end

    %get response variables (turns toward white)
    leftTurns = getCellVals(dataCell,'result.leftTurn')';

    %perform regression
    [beta,betaConf,r,rConf] = regress(leftTurns,segVals);

    %plot data
    behavGUI.behavPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
    behavGUI.behavScatter = errorbar(1:length(beta),beta,beta-betaConf(:,1),abs(beta-betaConf(:,2)),...
        'bo','MarkerFaceColor','b','MarkerSize',10,'LineStyle','none');
    xlim([0 length(beta)+1]);
    ylabel('Beta');
    xlabel('Segment Number');
    set(behavGUI.behavPlot,'XTick',1:length(beta));
    title('Behavioral Weights');
end


behavGUI.onlineTimer = timer;
set(behavGUI.onlineTimer,'ExecutionMode','fixedDelay','TimerFcn',...
    {@updateBehav_CALLBACK,behavGUI,guiObjects,dataFlag},...
    'Period',str2double(get(guiObjects.updateInt,'String')));

%set callback for buttons
set(behavGUI.exportFig,'Callback',{@exportFig_CALLBACK,behavGUI,false});
if flagWhite
    set(behavGUI.exportData,'Callback',{@exportData_CALLBACK,beta,betaConf,segVals,whiteTurns,...
        r,rConf});
else
    set(behavGUI.exportData,'Callback',{@exportData_CALLBACK,beta,betaConf,segVals,leftTurns,...
        r,rConf});
end
set(behavGUI.printFig,'Callback',{@exportFig_CALLBACK,behavGUI,true});
set(behavGUI.update,'Callback',{@updateButton_CALLBACK,behavGUI});
set(behavGUI.figHandle,'CloseRequestFcn',{@closeGUI_CALLBACK,behavGUI});

%start timer
start(behavGUI.onlineTimer);
end

function exportFig_CALLBACK(src,evnt,behavGUI,shouldPrint)
saveFig = figure('visible','off','OuterPosition',get(behavGUI.figHandle,'Position'));
savePlot = copyobj(behavGUI.behavPlot,saveFig);
set(saveFig,'Units','Normalized','OuterPosition',[0 0 1 1],'PaperPositionMode','auto');

if shouldPrint
    set(savePlot,'FontSize',15);
    set(get(savePlot,'XLabel'),'FontSize',22);
    set(get(savePlot,'YLabel'),'FontSize',22);
    set(get(savePlot,'Title'),'FontSize',22);
    orient landscape;
    printdlg(saveFig);
    return;
else
    set(savePlot,'FontSize',20);
    set(get(savePlot,'XLabel'),'FontSize',28);
    set(get(savePlot,'YLabel'),'FontSize',28);
    set(get(savePlot,'Title'),'FontSize',28);
end
saveFig = behavGUI.figHandle;

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

function exportData_CALLBACK(src,evnt,beta,betaConf,segVals,whiteTurns,...
    r,rConf)
assignin('base','beta',beta);
assignin('base','betaConf',betaConf);
assignin('base','segVals',segVals);
assignin('base','whiteTurns',whiteTurns);
assignin('base','r',r);
assignin('base','rConf',rConf);
end

function updateBehav_CALLBACK(src,evnt,behavGUI,guiObjects,dataFlag)
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
    %get explanatory variables (segments)
    numTrials = length(dataCell);
    if flagCap
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    else
        numSeg = max(getCellVals(dataCell,'maze.numwhite'));
    end
    segVals = zeros(numTrials,numSeg);
    for i=1:numTrials
        segVals(i,dataCell{i}.maze.whiteDots') = 1;
    end

    %get response variables (turns toward white)
    whiteTurns = getCellVals(dataCell,'result.whiteTurn')';

    %perform regression
    [beta,betaConf,r,rConf] = regress(whiteTurns,segVals);

    %plot data
    set(0,'CurrentFigure',behavGUI.figHandle); %set current figure to background by directly accessing current figure property
    behavGUI.behavPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
    behavGUI.behavScatter = errorbar(1:length(beta),beta,beta-betaConf(:,1),abs(beta-betaConf(:,2)),...
        'bo','MarkerFaceColor','b','MarkerSize',10,'LineStyle','none');
    xlim([0 length(beta)+1]);
    ylabel('Beta');
    xlabel('Segment Number');
    set(behavGUI.behavPlot,'XTick',1:length(beta));
    title('Behavioral Weights');
else
    %get explanatory variables (segments)
    numTrials = length(dataCell);
    numSeg = max(getCellVals(dataCell,'maze.numLeft'));
    segVals = zeros(numTrials,numSeg);
    for i=1:numTrials
        segVals(i,dataCell{i}.maze.leftDotLoc') = 1;
    end

    %get response variables (turns toward white)
    leftTurns = getCellVals(dataCell,'result.leftTurn')';

    %perform regression
    [beta,betaConf,r,rConf] = regress(leftTurns,segVals);

    %plot data
    set(0,'CurrentFigure',behavGUI.figHandle); %set current figure to background by directly accessing current figure property
    behavGUI.behavPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
    behavGUI.behavScatter = errorbar(1:length(beta),beta,beta-betaConf(:,1),abs(beta-betaConf(:,2)),...
        'bo','MarkerFaceColor','b','MarkerSize',10,'LineStyle','none');
    xlim([0 length(beta)+1]);
    ylabel('Beta');
    xlabel('Segment Number');
    set(behavGUI.behavPlot,'XTick',1:length(beta));
    title('Behavioral Weights');
end

%set callback for buttons
set(behavGUI.exportFig,'Callback',{@exportFig_CALLBACK,behavGUI,false});
if flagWhite
    set(behavGUI.exportData,'Callback',{@exportData_CALLBACK,beta,betaConf,segVals,whiteTurns,...
        r,rConf});
else
    set(behavGUI.exportData,'Callback',{@exportData_CALLBACK,beta,betaConf,segVals,leftTurns,...
        r,rConf});
end
set(behavGUI.printFig,'Callback',{@exportFig_CALLBACK,behavGUI,true});
end

function updateButton_CALLBACK(src,evnt,behavGUI)
%get value of button
buttonVal = get(behavGUI.update,'Value');

if buttonVal %if button pressed down
    start(behavGUI.onlineTimer);
else
    stop(behavGUI.onlineTimer);
end

end

function closeGUI_CALLBACK(src,evnt,behavGUI)

stop(behavGUI.onlineTimer);

delete(behavGUI.figHandle);
end