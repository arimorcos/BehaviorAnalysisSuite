function changeAnimalCell_CALLBACK(src,evnt,guiObjects,popup,direction)
%changeAnimalCell.m Callback to change the current animal used by the
%animal arrows
%
%dir - direction of arrow pressed


%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get file info
fileInfo = get(guiObjects.animalPopup,'UserData');

if popup %if called by popup
    newAnimal = get(guiObjects.animalPopup,'Value'); %ger updated value
    folderInd = newAnimal; %set folderInd to that value
else
    oldAnimal = get(guiObjects.animalPopup,'Value'); %get current value

    if direction && oldAnimal < length(get(guiObjects.animalPopup,'String')) %if right and less than max
        set(guiObjects.animalPopup,'Value',oldAnimal + 1); %update animal popup
        folderInd = fileInfo.loadedFolder + 1; %increment folderInd
    elseif ~direction && oldAnimal > 1 %if left and greater than min
        set(guiObjects.animalPopup,'Value',oldAnimal - 1); %udpate animal popup
        folderInd = fileInfo.loadedFolder - 1; %decrease folderInd by one
    end
end 

%get file names
origDir = cd([fileInfo.anPath,'\',fileInfo.folderList(folderInd).name]); %change to directory
fileList = dir([guiObjects.userData.initials,'*Cell*.mat']); %list files with cell array
fileCell = cell(1,length(fileList)); %initialize cell
for i=1:length(fileList) %for each file
    fileCell{i} = fileList(i).name; %set equal to name
end
cd(origDir);

fileStr = [fileInfo.anPath,'\',fileInfo.folderList(folderInd).name,...
    '\',fileCell{end}];

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);

openCellFiles_CALLBACK(src,evnt,guiObjects,true,fileStr)
end