function resetCondFields_CALLBACK(src,evnt,guiObjects,dataCell,data,online)
%resetCondFields_CALLBACK.m Function to reset all fields

for i=1:4
    set(guiObjects.condRange(i),'String',':');
    set(guiObjects.condText(i),'String','Enter Condition Text Here');
    set(guiObjects.condCheck(i),'Value',0);
end

condText_CALLBACK(src,evnt,dataCell,data,guiObjects,online);