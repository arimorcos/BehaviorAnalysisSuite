function exportBASToExcel()
%EXPORTBASTOEXCEL Summary of this function goes here
%   Detailed explanation goes here

%get file
[FileName,PathName] = uigetfile('*_Cell.mat');
filePath = fullfile(PathName,FileName);

%check if valid path
if ~exist(filePath)
    error('file does not exist');
end

%load in data
load(filePath,'dataCell');

%initialize array
excelArray = zeros(5,length(dataCell));

%save trial correct as first row
excelArray(1,:) = getCellVals(dataCell,'result.correct');

%save left turn as second row 
excelArray(2,:) = getCellVals(dataCell,'result.leftTurn');

%save left trial as third row
excelArray(3,:) = getCellVals(dataCell,'maze.leftTrial');

%save condition as fourth row
excelArray(4,:) = getCellVals(dataCell,'maze.condition');

%save trial time as fifth row
startTime = getCellVals(dataCell,'time.start');
stopTime = getCellVals(dataCell,'time.stop');
time = stopTime - startTime;
excelArray(5,:) = dnum2secs(time);

%save total session time as 6th row
excelArray(6,:) = nan(1,length(dataCell));
excelArray(6,1) = dnum2secs(dataCell{end}.time.stop - dataCell{1}.time.start)/60;

%create excel file name
[path,name] = fileparts(filePath);
excelName = [fullfile(path,name),'.xlsx'];
if exist(excelName)
    delete(excelName);
end
xlswrite(excelName,excelArray);


end

function [seconds] = dnum2secs(dnum)

    if length(dnum) == 1
        [H, M, S, MS] = strread(datestr(dnum,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); 
        seconds = 3600*H + 60*M + S + MS/1000; 
    else
        seconds = zeros(1,length(dnum));
        for i=1:length(dnum)
            [H, M, S, MS] = strread(datestr(dnum(i),'HH:MM:SS:FFF'),'%d:%d:%d:%d'); 
            seconds(i) = 3600*H + 60*M + S + MS/1000; 
        end
    end
end

