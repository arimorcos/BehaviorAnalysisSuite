function mouseToggle_CALLBACK(src,evnt,guiObjects)
%mouseToggle_CALLBACK Callback for the current/archived toggle
%
%This function gets the current value of the mouse toggle and updates the
%information in the gui accordingly
%
%ASM 9/20/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get file info
fileInfo = get(guiObjects.animalPopup,'UserData'); %get fileInfo stored in animal popup

if strfind(fileInfo.anPath,guiObjects.userData.folders{1}) ~= 0 %if path contains current
    set(guiObjects.mouseToggle,'String',guiObjects.userData.folders{2}); %set string to Archived
    newAnPath = [guiObjects.userData.path,guiObjects.userData.folders{2}];
    indStr = guiObjects.userData.folders{2};
    origStr = guiObjects.userData.folders{1};
elseif strfind(fileInfo.anPath,guiObjects.userData.folders{2}) ~= 0 %if path contains current
    set(guiObjects.mouseToggle,'String',guiObjects.userData.folders{1}); %set string to Archived
    newAnPath = [guiObjects.userData.path,guiObjects.userData.folders{1}];
    indStr = guiObjects.userData.folders{1};
    origStr = guiObjects.userData.folders{2};
end

origDir = cd(newAnPath); %change to new directory 
folderList = dir([guiObjects.userData.initials,'*']); %get list of folders
cd([newAnPath,'\',folderList(1).name]);
fileList = dir([guiObjects.userData.initials,'*Cell*.mat']); %get list of files
cd(origDir); %change back to original directory
ind = 0;
while isempty(fileList)
    ind = ind + 1;
    if ind > length(folderList)
        errordlg(['No Cell Array Files in ',indStr,' Folder']);
        set(guiObjects.mouseToggle,'String',origStr,'enable','off');
        cd(origDir);
        return
    end
    cd([newAnPath,'\',folderList(ind).name]);
    fileList = dir([guiObjects.userData.initials,'*Cell*.mat']); %get list of files
end

fileStr = [newAnPath,'\',folderList(ind).name,'\',fileList(1).name]; %createFileStr

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);

openCellFiles_CALLBACK(src,evnt,guiObjects,true,fileStr);
end