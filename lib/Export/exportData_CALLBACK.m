function exportData_CALLBACK(src,evnt,guiObjects)
%exportData_CALLBACK.m Callback to export data to the workspace
%
%ASM 9/27/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%open gui
exportGUIData = exportGUI();

%update strings
set(exportGUIData.dataList,'String',get(guiObjects.modData,'String'));

%set callbacks
set(exportGUIData.winButton,'Callback',{@saveWin_CALLBACK,guiObjects});
set(exportGUIData.subsetButton,'Callback',{@assignToBase,guiObjects,exportGUIData});

end

function assignToBase(src,evnt,guiObjects,exportGUIData)

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get datasets
modData = get(guiObjects.modData,'UserData');

%get which dataset to feed into module
dataStrings = get(exportGUIData.dataList,'String');
whichData = dataStrings{get(exportGUIData.dataList,'Value')};
if regexp(whichData,'All')
    dataCell = modData.datasets.all;
    procData = modData.proc.all;
elseif regexp(whichData,'Last')
    dataCell = modData.datasets.lastX;
    procData = modData.proc.lastX;
elseif regexp(whichData,'Condition')
    condNum = str2double(whichData(isstrprop(whichData,'digit')));
    dataCell = modData.datasets.condition{condNum};
    procData = modData.proc.condition(condNum);
end
data = guiObjects.data;
exper = guiObjects.exper;
if isfield(guiObjects,'indDataCells')
    indDataCells = guiObjects.indDataCells;
else
    indDataCells = [];
end

assignin('base','data',data);
assignin('base','dataCell',dataCell);
assignin('base','procData',procData);
assignin('base','exper',exper);
assignin('base','indDataCells',indDataCells);
end

function saveWin_CALLBACK(src,evnt,guiObjects)
[filename,pathname] = uiputfile({'*.eps','EPS (*.eps)';...
    '*.jpg','JPEG Image(*.jpg)';'*.fig','MATLAB Figure (*.fig)';...
    '*.png','PNG Image (*.png)';'*.tif','TIFF Image (*.tif)';...
    '*.pdf','PDF File (*.pdf)'});

saveFig = figure('visible','off','Position',get(guiObjects.figHandle,'Position'));
copyobj(guiObjects.windowPlot,saveFig);
copyobj(guiObjects.trialRaster,saveFig);
if isfield(guiObjects,'winLegend') && ishandle(guiObjects.winLegend)
    copyobj(guiObjects.winLegend,saveFig);
end
h = get(guiObjects.windowPlot,'UserData');
if isfield(h,'h2')
    ax2 = copyobj(h.ax(2),saveFig);
    copyobj(h.h2,ax2);
end
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
close(saveFig);
end