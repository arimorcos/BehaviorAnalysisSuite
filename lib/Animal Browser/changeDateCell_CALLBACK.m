function changeDateCell_CALLBACK(src,evnt,guiObjects,popup,direction)
%changeDateCell.m Callback to change the current date used by the
%date arrows
%
%dir - direction of arrow pressed

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get file info
fileInfo = get(guiObjects.animalPopup,'UserData'); %get fileInfo stored in animal popup

if popup %if called by popup
    newDate = get(guiObjects.datePopup,'Value'); %get new value of date
    fileInd = newDate;
else
    oldDate = get(guiObjects.datePopup,'Value'); %get current value of date

    if direction && oldDate < length(get(guiObjects.datePopup,'String')) %if right click and less than end
        set(guiObjects.datePopup,'Value',oldDate + 1); %increment value of popup
        fileInd = fileInfo.loadedFile + 1; %increment file indiex
    elseif ~direction && oldDate > 1 %if left click and greater than first file
        set(guiObjects.datePopup,'Value',oldDate - 1); %decrease value of popup by 1
        fileInd = fileInfo.loadedFile - 1; %decrease file index
    else
        return; %if at first or last file, return
    end
end

fileStr = [fileInfo.anPath,'\',fileInfo.folderList(fileInfo.loadedFolder).name,...
    '\',fileInfo.fileCell{fileInd}]; %create file string

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);

openCellFiles_CALLBACK(src,evnt,guiObjects,true,fileStr)
end