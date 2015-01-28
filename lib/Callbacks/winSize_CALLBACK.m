function winSize_CALLBACK(src,evnt,dataCell,data,guiObjects)
%winSize_CALLBACK Callback for window size text edit box to update window
%size of sliding window plot
%
%ASM 9/19/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

multiData = guiObjects.multiData;
if multiData
    catData = guiObjects.catData;
    indDataCells = guiObjects.indDataCells;
end

winSize = str2double(get(guiObjects.winSize,'String'));

%process data
[procData] = processDataCell(data,dataCell);

%calculate sliding window
if procData.sessionTime > winSize
    if multiData
        for i=1:length(catData)
            [procData.winData{i},guiObjects] = calcSlidingWindowCell(...
                indDataCells{i},catData{i},procData.sessionTime,winSize,guiObjects);
        end
    else
        [procData.winData,guiObjects] = calcSlidingWindowCell(dataCell,data,...
            procData.sessionTime,winSize,guiObjects);
    end
    procData.winFlag = false;
else
    procData.winFlag = true;
end

%plot
if ~all(procData.winFlag)
    set(guiObjects.winText,'visible','off');
    if multiData
        [guiObjects] = plotWindowDataCellMulti(procData.winData,guiObjects);
    else
        [guiObjects] = plotWindowDataCell(procData.winData,guiObjects);
    end
    set(guiObjects.winDisp,'enable','on');
    set(guiObjects.legendCheck,'enable','on');
    set(guiObjects.panButton,'enable','on');
    set(guiObjects.zoomButton,'enable','on');
else
    set(guiObjects.winText,'visible','on');
    if isfield(guiObjects,'windowPlot') && ishandle(guiObjects.windowPlot)
        delete(guiObjects.windowPlot); %delete old plot
    end
    set(guiObjects.winDisp,'String',{'Correct','Trials'},'Value',[1 2]);
    set(guiObjects.winDisp,'enable','off');
    set(guiObjects.legendCheck,'enable','off');
    set(guiObjects.panButton,'enable','off');
    set(guiObjects.zoomButton,'enable','off');
end

%update check callbacks
set(guiObjects.legendCheck,'Callback',{@windowCheck_CALLBACK,guiObjects,procData});
set(guiObjects.winDisp,'Callback',{@windowCheck_CALLBACK,guiObjects,procData});

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);

end