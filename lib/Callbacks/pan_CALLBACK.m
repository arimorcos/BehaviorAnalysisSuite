function pan_CALLBACK(src,evnt,guiObjects)
%zoom_CALLBACK Callback to handle zooming in the sliding window and raster
%plots

%get axes
ax = get(guiObjects.windowPlot,'UserData');

%link axes first
linkaxes([ax.ax,guiObjects.trialRaster],'x');

if isfield(guiObjects,'zoom') && ishandle(guiObjects.zoom)
    set(guiObjects.zoom,'enable','off');
end

if isfield(guiObjects,'pan') && ishandle(guiObjects.pan) && strcmp(get(guiObjects.pan,'enable'),'on')
    set(guiObjects.pan,'enable','off');
else
    guiObjects.pan = pan;
    set(guiObjects.pan,'Motion','horizontal','Enable','on','ActionPostCallback',{@panLabels_CALLBACK,guiObjects});
end

set(guiObjects.figHandle,'UserData',guiObjects);
end

function panLabels_CALLBACK(src,evnt,guiObjects)
%Callback to update the xTickLabels

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

timeVec = get(guiObjects.trialRaster,'UserData');
lims = get(evnt.Axes(1),'XLim');

if lims(1) < 0 
    limDiff = lims(2) - lims(1);
    lims(1) = 0;
    lims(2) = limDiff;
    set(guiObjects.trialRaster,'XLim',lims);
elseif lims(2) > 1
    limDiff = lims(2) - lims(1);
    lims(2) = 1;
    lims(1) = lims(2) - limDiff;
    set(guiObjects.trialRaster,'XLim',lims);
end

ind = [round(lims(1)*size(timeVec,2)) round(lims(2)*size(timeVec,2))];
ind(ind==0) = 1;
timeVec = timeVec(ind(1):ind(2));

xTickVals = num2cell(timeVec(round(linspace(1,length(timeVec),11))));
xTickDates = cellfun(@(x) datestr(x,'HH:MM:SS'),xTickVals,'UniformOutput',false);
set(guiObjects.trialRaster,'XTickLabel',xTickDates);

end