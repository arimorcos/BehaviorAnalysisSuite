function [guiObjects] = plotWindowDataCell(winData,guiObjects)
%plotWindowDataCell.m function to plot the data from the sliding window
%
%ASM 9/18/12 based on plotWindowData.m


set(0,'CurrentFigure',guiObjects.figHandle); %set current figure to background by directly accessing current figure property

warning('off','MATLAB:legend:PlotEmpty');

%reshape data
[winData] = shiftWinCell(winData);

xTimes = 1:size(winData.nTrials,2);
xTimes = xTimes/winData.totTime;

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
names = winData.names(cellfun(@(x) ~isempty(x),winData.names));

for i=1:length(selValsSpec)
    plotStr = ['plot(xTimes,',names{selValsSpec(i)-1},...
        ',''parent'',guiObjects.windowPlot,''Color'',winPlotColorsSub(selValsSpec(i)-2,:));'];
    eval(plotStr);
end

%generate legend strings
if get(guiObjects.legendCheck,'Value')
    legNames = winData.legNames(cellfun(@(x) ~isempty(x),winData.legNames));
    legStrings = legNames(selVals);
    if any(strcmp(legStrings,'Trials')) %if trials move to end
        legStrings{length(legStrings)+1} = legStrings{strcmp(legStrings,'Trials')};
        legStrings = legStrings([1:find(strcmp(legStrings,'Trials'))-1,...
            find(strcmp(legStrings,'Trials'))+1:end]);
    end
    guiObjects.winLegend = legend(legStrings,'Location','SouthWest');
end

if ismember(2,selVals)
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