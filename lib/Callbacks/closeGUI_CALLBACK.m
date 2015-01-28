function closeGUI_CALLBACK(src,evnt,guiObjects)
%closeGUI_Callback.m function called when gui closes. Turns off timer and
%deletes
%
%ASM 9/21/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%stop timer
if isfield(guiObjects,'onlineTimer') && isvalid(guiObjects.onlineTimer)
    startStopOnline_CALLBACK(src,evnt,guiObjects);
end

%close window
delete(guiObjects.figHandle);
end