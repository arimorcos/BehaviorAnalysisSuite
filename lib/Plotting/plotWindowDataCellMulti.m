function [guiObjects] = plotWindowDataCellMulti(winData,guiObjects)
%plotWindowDataCell.m function to plot the data from the sliding window
%
%ASM 9/18/12 based on plotWindowData.m

if ~iscell(winData) %throw error if not a cell
    error('winData must be a cell array of winData structures for plotWindowDataCellMulti');
end

set(0,'CurrentFigure',guiObjects.figHandle); %set current figure to background by directly accessing current figure property

warning('off','MATLAB:legend:PlotEmpty');

%get filenames
info = get(guiObjects.openSelected,'UserData');
filenames = info.filenames;
for i=1:length(filenames)
    lastInd = 1;
    unInds = find(filenames{i}=='_');
    convName = [];
    for j=1:length(unInds)
        if j == length(unInds)
            convName = [convName,filenames{i}(lastInd:unInds(j)-1),'\_',filenames{i}(unInds(j)+1:end)];
        else
            convName = [convName,filenames{i}(lastInd:unInds(j)-1),'\_']; %#ok<*AGROW>
            lastInd = unInds(j)+1;
        end
    end
    filenames{i} = convName;
end

%reshape data
winLengths = zeros(1,length(winData));
totTime = 0;
for i=1:length(winData)
    [winData{i}] = shiftWinCell(winData{i});
    winLengths(i) = size(winData{i}.nTrials,2);
    totTime = totTime + winData{i}.totTime;
end
winLengths = cumsum(winLengths);
winLengths = winLengths/winLengths(end);

%concatenate each data array
winData = catWinData(winData);

xTimes = 1:size(winData.nTrials,2);
xTimes = xTimes/totTime;

guiObjects.windowPlot = subplot('Position',[0.05 0.69 0.9 0.25]);
cla reset;

selVals = get(guiObjects.winDisp,'Value');

hold on;

if all(ismember([1 2],selVals)) %if correct and trials are selected
    [ax, h1, h2] = plotyy(xTimes,winData.percCorr,xTimes,winData.trialsPerMinute,...
        'parent',guiObjects.windowPlot);
    set(h1,'Color','b');
    set(h2,'Color','r');
elseif ismember(1,selVals) && ~ismember(2,selVals) %if only correct chosen
    percCorrPlot = plot(xTimes,winData.percCorr,'b',...
        'parent',guiObjects.windowPlot);
elseif (~ismember(1,selVals) && ismember(2,selVals)) %if only trials chosen and no others
    [ax, h1, h2] = plotyy(xTimes,winData.percCorr,xTimes,winData.trialsPerMinute,...
        'parent',guiObjects.windowPlot);
    set(h1,'Color','b');
    set(h2,'Color','r');
    delete(h1);
end

selValsSpec = selVals(selVals>2); %get all values greater than 2
load('winPlotColors.mat','winPlotColors'); % load colormap
winPlotColorsSub = winPlotColors(round(linspace(1,size(winPlotColors,1),...
    length(get(guiObjects.winDisp,'String'))-2)),:); %sample colorspace

for i=1:length(selValsSpec)
    plotStr = ['plot(xTimes,',winData.names{selValsSpec(i)-1},...
        ',''parent'',guiObjects.windowPlot,''Color'',winPlotColorsSub(selValsSpec(i),:));'];
    eval(plotStr);
end

%generate legend strings
if get(guiObjects.legendCheck,'Value')
    legStrings = winData.legNames(selVals);
    if any(strcmp(legStrings,'Trials')) %if trials move to end
        legStrings{length(legStrings)+1} = legStrings{strcmp(legStrings,'Trials')};
        legStrings = legStrings([1:find(strcmp(legStrings,'Trials'))-1,...
            find(strcmp(legStrings,'Trials'))+1:end]);
    end
    legend(legStrings,'Location','SouthWest');
end

%plot dividers and names
for i=1:length(winLengths)
    line([winLengths(i) winLengths(i)],[0 1000],'Color','k','LineStyle','--');
    if i==1
        text(0,2,filenames{i},'HorizontalAlignment','Left','VerticalAlignment','Bottom');
    else
        text(winLengths(i-1),2,filenames{i},'HorizontalAlignment','Left','VerticalAlignment','Bottom');
    end
end

%modify axis properties
if ismember(2,selVals) && any(selVals>2 | selVals == 1)
    set(get(ax(1),'Ylabel'),'String','Percent','Color','k');
    set(ax(1),'ylim',[0 100],'YColor','k','ytick',0:10:100,'xlim',[0 1]);
    set(get(ax(2),'Ylabel'),'String','Trials Per Minute','Color','r');
    set(ax(2),'ylim',[0 10],'ytick',0:1:10,'yticklabel',0:1:10,'YColor','r','xlim',[0 1]);
    set(ax(1),'XTickLabel','')
    set(ax(2),'XTickLabel','')
    h.ax = ax;
    h.h2 = h2;
    set(guiObjects.windowPlot,'UserData',h);
else
    ylabel('Percent');
    ylim([0 100]);
    set(gca,'ytick',0:10:100);
    xlim([0 1]);
    set(gca,'XTickLabel','');
    set(guiObjects.windowPlot,'UserData',gca);
end

title('Trials Throughout Session')

%set callbacks
set(guiObjects.zoomButton,'Callback',{@zoom_CALLBACK,guiObjects},'enable','on');
set(guiObjects.panButton,'Callback',{@pan_CALLBACK,guiObjects},'enable','on');

end