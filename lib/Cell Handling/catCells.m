function [data] = catCells(path,startString,startCell)
%catCells.m This function loads in multiple structures and concatenates
%them in one cell array. It then saves the file and overwrites the old
%structures

%turn off warning for not finding load pattern
warning('off','MATLAB:load:variablePatternNotFound');

try
    %load all variables
    matObj = matfile(path);
    fileInfo = whos(matObj);
    totCells = length(fileInfo)-1;
    cellNum = startCell:totCells;
    varToLoad = cellfun(@(x) ['data',num2str(x)],num2cell(cellNum),'UniformOutput',false);
    if ~isempty(varToLoad)
        load(path,varToLoad{:});
    end
catch
    pause(0.5);
     %load all variables
    matObj = matfile(path);
    fileInfo = whos(matObj);
    totCells = length(fileInfo)-1;
    cellNum = startCell:totCells;
    varToLoad = cellfun(@(x) ['data',num2str(x)],num2cell(cellNum),'UniformOutput',false);
    if ~isempty(varToLoad)
        load(path,varToLoad{:});
    end
end

%get number of files
numFiles = length(varToLoad);

if numFiles == 0
    data = {};
    return;
end

%initialize cell array
data = cell(1,numFiles);

%import data into cell
for i=1:numFiles
    eval(['data{i} = ',varToLoad{i},';']);
end
end

