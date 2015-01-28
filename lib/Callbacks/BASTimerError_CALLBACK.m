function startStopOnline_CALLBACK(src,evnt,guiObjects)

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');



%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);
end