function startStopOnline_CALLBACK(src,evnt,guiObjects)
    
%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get directory for files
tempPath = guiObjects.userData.tempDir;
tempCellPath = [tempPath,'\',guiObjects.userData.tempName,'Cell.mat'];

%get update interval
updateInt = str2double(get(guiObjects.updateInt,'String'));

if isfield(guiObjects,'onlineTimer') %if timer exists, stop it and delete
    if isvalid(guiObjects.onlineTimer)
        stop(guiObjects.onlineTimer); %stop the timer
        delete(guiObjects.onlineTimer);
        guiObjects = rmfield(guiObjects,'onlineTimer'); %remove it
    end
    set(guiObjects.openSelected,'enable','on'); %reenable open
    set(guiObjects.openRecent,'enable','on'); %reenable open
    set(guiObjects.modData,'String',{'All Data'},'Value',1);
    set(guiObjects.startStop,'String','Start Live Aq');
    if isfield(guiObjects,'data')
        guiObjects = rmfield(guiObjects,'data');
        guiObjects = rmfield(guiObjects,'dataCell');
    end
else %otherwise create it! 
    %create timer
    guiObjects.onlineTimer = timer;
    set(guiObjects.onlineTimer,'ExecutionMode','fixedDelay','TimerFcn',...
        {@openCellFiles_CALLBACK,guiObjects,true,tempCellPath,true},...
        'Period',updateInt,'Name','Online Timer');
    
    %save guiObjects
    set(guiObjects.figHandle,'UserData',guiObjects);
    
    %change text on button
    set(guiObjects.startStop,'String','Stop Live Aq');
    
    %start timer
    start(guiObjects.onlineTimer);
end

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);
end