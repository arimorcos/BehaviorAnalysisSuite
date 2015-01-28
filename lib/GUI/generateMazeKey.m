function [mazeKey,folders,folderNames,fileNames,cancel] = generateMazeKey(path,folders,guiObjects)
%generateMazeKey.m This function generates a maze key for lists of mat
%files. It loads exper, and saves the maze names into a cell array as a mat
%file titled 'mazeKey.mat.' This is a cell of cells with each initial cell
%being an animal, and each element of the cell corresponding to the a given
%date

SHOWNONCELL = false; %flag to show non-cell values as well -- generally should be set to false

rootDir = cd(path);

if SHOWNONCELL
    saveName = 'mazeKeyStorageNonCell.mat';
else
    saveName = 'mazeKeyStorageCell.mat';
end


if exist([path,'\',saveName],'file') ~= 2
    updateAll = true;
    saveDate = datenum('00000101','yyyymmdd'); %set saveDate to Jan 1 0000
else
    updateAll = false;
    load([path,saveName]);
end

if updateAll;mazeKey = cell(1,length(folders));end

%create waitbar
multiWaitbar('Animal Progress','Value',0,'Color','r');
multiWaitbar('Maze Progress','Value',0,'Color','b','CanCancel','on');

changeMade = false;

%get total folder number
for i=1:length(folders)
    numAnimals(i) = length(dir(fullfile(path,folders{i},[guiObjects.userData.initials,'*'])));
end
totalAnimals = sum(numAnimals);
cumSumAnimals = cumsum(numAnimals);

for i=1:length(folders)
    folderDir = cd([path,'\',folders{i}]); %change to directory with mouse folders
    folderNames{i} = dir([guiObjects.userData.initials,'*']);
    if updateAll;mazeKey{i} = cell(1,length(folderNames{i}));end
    
    %check if cancel
    cancel = multiWaitbar('Maze Progress');
    if cancel
        break;
    end
    
    for j=1:length(folderNames{i}) %go through each folder
        %check if cancel
        cancel = multiWaitbar('Maze Progress');
        if cancel
            break;
        end
        
        %update waitbar
        if i == 1
            multiWaitbar('Animal Progress','Value',j/totalAnimals);
        else
            multiWaitbar('Animal Progress','Value',(cumSumAnimals(i-1)+j)/totalAnimals);
        end
        multiWaitbar('Maze Progress','Value',j/length(folderNames{i}));
        
        if folderNames{i}(j).isdir~=1;continue; end %skip if not a folder
        
        cd([path,'\',folders{i},'\',folderNames{i}(j).name]); %change to animal directory
        
        if SHOWNONCELL
            allFileNamesStruc = dir([guiObjects.userData.initials,'*.mat']); %get list of all files
            for k=1:length(allFileNamesStruc) %convert to cell
                allFileCell{k} = allFileNamesStruc(k).name;
            end
            match = regexp(allFileCell,'Cell'); %find which files have cell in them
            nonCellFiles = allFileCell(cell2mat(cellfun(@(x) isempty(x),match,'UniformOutput',false))); %take all files but those with cell in them
            fileNamesStruc = dir([guiObjects.userData.initials,'*Cell*.mat']); %get all filenames with cell
            for k=1:length(nonCellFiles)
                fileNames{i}{j}{k}.experFile = nonCellFiles{k}; %get experFile names
                %find corresponding cell file if it exists
                dateStr = nonCellFiles{k}(7:12);
                match = regexp(allFileCell,[guiObjects.userData.initials,'.*',dateStr,'.*Cell.*mat']);
                sameDateCellFiles = allFileCell(cell2mat(cellfun(@(x) ~isempty(x),match,'UniformOutput',false)));
                if isempty(sameDateCellFiles)
                    fileNames{i}{j}{k}.cellFile = [];
                elseif length(sameDateCellFiles) == 1 || length(nonCellFiles{k}) == 16 %if only one file or if the nonCellFile doesn't have any extra numbers (lenght of 16 characters)
                    fileNames{i}{j}{k}.cellFile = sameDateCellFiles{1};
                else
                    matFileNum = nonCellFiles{k}(14:regexp(nonCellFiles{k},'.mat')-1);
                    for l=2:length(sameDateCellFiles)
                        cellFileNum(l) = sameDateCellFiles{l}(19:regexp(sameDateCellFiles{l},'.mat')-1);
                    end
                    [cellFilePresent,fileInd] = ismember(matFileNum,cellFileNum);
                    if cellFilePresent
                        fileNames{i}{j}{k}.cellFile =sameDateCellFiles{fileInd};
                    else
                        fileNames{i}{j}{k}.cellFile = [];
                    end
                end
            end
            clear allFileCell;
        else
            fileNamesStruc = dir([guiObjects.userData.initials,'*Cell*.mat']); %get all filenames with cell
            for k=1:length(fileNamesStruc)
                fileNames{i}{j}{k}.experFile = fileNamesStruc(k).name([1:12,18:end]);
                fileNames{i}{j}{k}.cellFile = fileNamesStruc(k).name;
            end
        end
        
        if length(fileNames)<i || length(fileNames{i})<j;fileNames{i}{j} = {};end
        if updateAll;mazeKey{i}{j} = cell(1,length(fileNames{i}{j}));end
        
        for k=1:length(fileNames{i}{j})
            info = dir(fileNames{i}{j}{k}.experFile);
            if isempty(info); continue; end;
            if (j > length(mazeKey{i})) ||...
                    (~updateAll && (info.datenum > saveDate) && length(mazeKey{i}{j}) < k) || updateAll
                changeMade = true;
                load(fileNames{i}{j}{k}.experFile,'exper'); %load experiment from each filename
                mazeKey{i}{j}{k}.experiment=func2str(exper.experimentCode);
                clear exper;
                if isempty(fileNames{i}{j}{k}.cellFile)
                    load(fileNames{i}{j}{k}.experFile,'data'); %load data
                    mazeKey{i}{j}{k}.percCorr=100*sum(data(8,:)~=0)/sum(diff(data(9,:))==1);
                    mazeKey{i}{j}{k}.tpm = sum(diff(data(9,:))==1)/dNumToMin(data(1,end)-data(1,1));
                    mazeKey{i}{j}{k}.trials = sum(diff(data(9,:))==1);
                    mazeKey{i}{j}{k}.time = dNumToMin(data(1,end)-data(1,1));
                    clear data;
                else
                    load(fileNames{i}{j}{k}.cellFile,'dataCell'); %load dataCell from each filename
                    mazeKey{i}{j}{k}.percCorr=100*sum(findTrials(dataCell,'result.correct==1'))/length(dataCell);
                    mazeKey{i}{j}{k}.tpm = length(dataCell)/dNumToMin(dataCell{end}.time.stop - dataCell{1}.time.start);
                    mazeKey{i}{j}{k}.trials = length(dataCell);
                    mazeKey{i}{j}{k}.time = dNumToMin(dataCell{end}.time.stop - dataCell{1}.time.start);
                    clear dataCell;
                end
            end
            
            %check if cancel
            cancel = multiWaitbar('Maze Progress');
            if cancel
                break;
            end
        end
        
        cd(folderDir);
    end
    cd(rootDir) %change back to input folder directory
end

%if cancel
if cancel
    multiWaitbar('closeAll');
    cd(rootDir);
    return;
end

%set to saving
multiWaitbar('Maze Progress','Close');
multiWaitbar('Saving...','busy');
multiWaitbar('Animal Progress','Close');

cd(rootDir);
saveDate = addtodate(now,-1,'day');
if changeMade
    save([path,'\',saveName],'mazeKey','folders','folderNames','fileNames','saveDate');
else
    save([path,'\',saveName],'saveDate','-append');
end

%close waitbar
multiWaitbar('closeAll');