function mazeKey_CALLBACK(src,evnt,guiObjects)

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%generate figure
mazeFig = figure('Name','Maze Key','NumberTitle','Off','MenuBar','none');
screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end
set(mazeFig,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) scrn(2)/30 ...
    0.3*(scrn(3)-scrn(1)) 29*scrn(4)/30]); %set position

[mazeKey,folders,folderNames,fileNames,cancel] = generateMazeKey(guiObjects.userData.path,...
    guiObjects.userData.folders,guiObjects); %generate the maze key

if cancel
    close(mazeFig);
    return;
end

ind = 1;
for i=1:length(folders) %for each rootFolder
    for j=1:length(folderNames{i}) %for each animal folder
        if ~isempty(mazeKey{i}{j})
            for k=1:length(mazeKey{i}{j}) %for each file
                tableData{ind,1} = folders{i}; %list rootFolder
                tableData{ind,2} = folderNames{i}(j).name; %list animalFolder
                if ~isempty(mazeKey{i}{j}{k})
                    tableData{ind,3} = mazeKey{i}{j}{k}.experiment; %list maze name
                    tableData{ind,4} = mazeKey{i}{j}{k}.percCorr; %list percent correct
                    tableData{ind,5} = fileNames{i}{j}{k}.experFile(7:12); %list date
                end
                folderNamesCell{i}{j} = folderNames{i}(j).name;
                ind = ind + 1;
            end
        else
            folderNamesCell{i}{j} = folderNames{i}(j).name;
        end
    end
end

set(0,'CurrentFigure',mazeFig); %set current figure to background by directly accessing current figure property

%create table
tableHandle = uitable;
set(tableHandle,'Units','Normalized','Position',[0.025 0.05 0.95 0.9],'Data',tableData,...
    'ColumnWidth',{80 50 170 100 50},'ColumnName',{'Root','Mouse','Maze Name','Percent Correct','Date'},...
    'CellSelectionCallback',{@cellSelect_CALLBACK,tableData,mazeFig});

%create listboxes
rootFolderList = uicontrol('Style','popup','FontName','Arial','FontSize',15,...
    'Units','Normalized','ForeGroundColor',[0 0 0],'String',folders,...
    'Position',[0.1 0.95 0.35 0.03]);
animalList = uicontrol('Style','popup','FontName','Arial','FontSize',15,...
    'Units','Normalized','ForeGroundColor',[0 0 0],'String',folderNamesCell{1},...
    'Position',[0.55 0.95 0.35 0.03]);
set(rootFolderList,'Callback',{@rootFolderList_CALLBACK,animalList,rootFolderList,folderNamesCell});
set(animalList,'Callback',{@animalList_CALLBACK,animalList,rootFolderList,...
    tableHandle,mazeKey,folders,folderNames,fileNames,mazeFig});

%create export button
exportMaze = uicontrol('Style','pushButton','FontName','Arial','FontSize',15,...
    'Units','Normalized','ForeGroundColor',[0 0 0],'String','Export to Excel',...
    'Position',[0.05 0.01 0.9 0.03],'Callback',{@exportExcel_CALLBACK,mazeKey,...
    folders,folderNames,fileNames});

end

function rootFolderList_CALLBACK(src,evnt,animalList,rootFolderList,folderNamesCell)
set(animalList,'String',folderNamesCell{get(rootFolderList,'Value')});
end

function animalList_CALLBACK(src,evnt,animalList,rootFolderList,...
    tableHandle,mazeKey,folders,folderNames,fileNames,mazeFig)

set(0,'CurrentFigure',mazeFig); %set current figure to background by directly accessing current figure property

rootVal = get(rootFolderList,'Value');
anVal = get(animalList,'Value');
ind = 1;
if ~isempty(mazeKey{rootVal}{anVal})
    for k=1:length(mazeKey{rootVal}{anVal}) %for each file
        if ~isempty(mazeKey{rootVal}{anVal}{k})
            tableData{ind,1} = folders{rootVal}; %list rootFolder
            tableData{ind,2} = folderNames{rootVal}(anVal).name; %list animalFolder
            tableData{ind,3} = mazeKey{rootVal}{anVal}{k}.experiment; %list maze name
            tableData{ind,4} = mazeKey{rootVal}{anVal}{k}.percCorr;
            tableData{ind,5} = fileNames{rootVal}{anVal}{k}.experFile(7:12); %list date
            ind = ind + 1;
        end
    end
else
    tableData{ind,1} = folders{rootVal}; %list rootFolder
    tableData{ind,2} = folderNames{rootVal}(anVal).name; %list animalFolder
    tableData{ind,3} = 'N/A'; %list maze name
    tableData{ind,4} = 'N/A'; %list date
end
set(tableHandle,'Data',tableData,'CellSelectionCallback',{@cellSelect_CALLBACK,tableData,mazeFig});
end

function cellSelect_CALLBACK(src,evnt,tableData,mazeFig)
try
    for i=1:size(tableData,1)
        x(i,1) = strcmp(tableData{evnt.Indices(1),3},tableData{i,3})...
            & strcmp(tableData{evnt.Indices(1),2},tableData{i,2});
    end

    if isempty(get(mazeFig,'UserData'))
        dateFig = figure('Name','Maze Key','NumberTitle','Off','MenuBar','none');
        set(dateFig,'CloseRequestFcn',{@closeDateFig_CALLBACK,mazeFig,dateFig});
        set(mazeFig,'CloseRequestFcn',{@closeMazeFig_CALLBACK,mazeFig,dateFig});
        set(0,'CurrentFigure',dateFig); %set current figure to background by directly accessing current figure property
        screens = get(0,'MonitorPositions');
        if size(screens,1) > 1
            scrn = screens(2,:);
        else
            scrn = screens(1,:);
        end
        set(dateFig,'OuterPosition',[scrn(1)+0.8*(scrn(3)-scrn(1)) 0.5*(scrn(4)-scrn(2))...
            0.1*(scrn(3)-scrn(1)) 0.5*scrn(4)]); %set position

        dateTable = uitable;
        set(dateTable,'Units','Normalized','Position',[0.025 0.025 0.95 0.95],...
            'Data',tableData(x,5),'ColumnName',{'Dates'},'FontSize',14);
    else
        dateTable = get(mazeFig,'UserData');
        set(dateTable,'Data',tableData(x,5));
    end
    set(mazeFig,'UserData',dateTable);
end
end

function closeDateFig_CALLBACK(src,evnt,mazeFig,dateFig)
set(mazeFig,'UserData',[]);
delete(dateFig);
end

function closeMazeFig_CALLBACK(src,evnt,mazeFig,dateFig)
delete(mazeFig);
delete(dateFig);
end

function exportExcel_CALLBACK(src,evnt,mazeKey,folders,folderNames,fileNames)

[filename,pathname] = uiputfile({'*.xls','Excel File (*.xls)'});

excelFile = fullfile(pathname,filename);

totalAnimals = 0;
for i=1:length(folders)
    totalAnimals = totalAnimals + length(folderNames{i});
end
excelWait = waitbar(0,['Exporting 0/',num2str(totalAnimals)]);

warning off MATLAB:xlswrite:AddSheet;
anNum = 0;
for i=1:length(folders)
    for j=1:length(folderNames{i})
        rootVal = i;
        anVal = j;
        ind = 1;
        if ~isempty(mazeKey{rootVal}{anVal})
            for k=1:length(mazeKey{rootVal}{anVal}) %for each file
                if isempty(mazeKey{rootVal}{anVal}{k})
                    continue;
                end
                tableData{ind,1} = folders{rootVal}; %list rootFolder
                tableData{ind,2} = folderNames{rootVal}(anVal).name; %list animalFolder
                tableData{ind,3} = mazeKey{rootVal}{anVal}{k}.experiment; %list maze name
                tableData{ind,4} = mazeKey{rootVal}{anVal}{k}.percCorr;
                tableData{ind,5} = mazeKey{rootVal}{anVal}{k}.tpm;
                tableData{ind,6} = mazeKey{rootVal}{anVal}{k}.trials;
                tableData{ind,7} = mazeKey{rootVal}{anVal}{k}.time;
                tableData{ind,8} = fileNames{rootVal}{anVal}{k}.experFile(7:12); %list date
                ind = ind + 1;
            end
        else
            tableData{ind,1} = folders{rootVal}; %list rootFolder
            tableData{ind,2} = folderNames{rootVal}(anVal).name; %list animalFolder
            tableData{ind,3} = 'N/A'; %list maze name
            tableData{ind,4} = 'N/A'; %list date
            tableData{ind,5} = 'N/A'; %list maze name
            tableData{ind,6} = 'N/A'; %list maze name
            tableData{ind,7} = 'N/A'; %list maze name
            tableData{ind,8} = 'N/A'; %list maze name
        end
        
        %write to spreadsheet
        xlswrite(excelFile,tableData,folderNames{rootVal}(anVal).name);
        
        clear tableData;
        anNum = anNum + 1;
        waitbar(anNum/totalAnimals,excelWait,['Exporting ',num2str(anNum),'/',num2str(totalAnimals)]);
    end
end

close(excelWait);
end