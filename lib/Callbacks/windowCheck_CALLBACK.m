function windowCheck_CALLBACK(src,evnt,guiObjects,procData)
%windowCheck_CALLBACK.m Callback for window checks to modulate visibility
%of curves
%
%This callback is called anytime the value of one of the window checks is
%changed and modulates the visibility of curves/legend accordingly
%
%ASM 9/19/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get multiData
if isfield(guiObjects,'multiData')
    multiData = guiObjects.multiData;
else
    multiData = false;
end

%update plot
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

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);