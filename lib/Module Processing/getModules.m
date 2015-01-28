function [modCallbacks,names] = getModules(path)
%getModules.m Function to get module info from text file
%
%path should be a string designating the path of the modules folder, which
%should contain another folder for each module.
%
%ASM 9/21/12

origDir = cd(path); %change directory to path

folders = dir('module*'); %get folder info

numMods = length(folders); %get number of modules

modInfo = cell(1,numMods);
names = cell(1,numMods);
modCallbacks = cell(1,numMods);

for i=1:numMods %for each module
    modDir = cd(folders(i).name); %change to folder directory 
    txtFileList = dir('*.txt'); %get list of text files
    if length(txtFileList) > 1 %if more than one text file
        error('Can only have one text file in a given module folder');
    end
    fid = fopen(txtFileList.name); %open file
    modInfo{i} = textscan(fid,'%s','Delimiter','|','CommentStyle','%')'; %read strings
    fclose(fid); %close file
    cd(modDir); %change back to module directory
    names{i} = modInfo{i}{1}{1}; %first string in modInfo of i
    modCallbacks{i} = modInfo{i}{1}(2:end); % get callback info
end

cd(origDir);
