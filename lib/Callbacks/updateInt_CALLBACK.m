function updateInt_CALLBACK(src,evnt,guiObjects)
%updateInt_CALLBACK Callback for update interval modification 

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

if ~isfield(guiObjects,'onlineTimer') %if no timer exists
    return;
end

updateInt = str2double(get(guiObjects.updateInt,'String'));

stop(guiObjects.onlineTimer); %stop timer
set(guiObjects.onlineTimer,'Period',updateInt); %update period
start(guiObjects.onlineTimer); %restart timer

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);
end