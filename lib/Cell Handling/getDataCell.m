%script to get live data


path = '\\HARVEYRIG1\Temporary';

load([path,'\tempStorage.mat']);
[dataCell] = catCells([path,'\tempStorageCell.mat'],'data');
[data] = copyData(path,str2double(exper.variables.reshapeSize),false);
clear path;