function deleteMice(mice,paths,folders)
%deleteMice.m Deletes mice on all computers present in paths
%
%INPUTS
%mice - string containing name of mouse or cell array of strings containing
%   mouse names
%paths - paths to folders containing current and archived mice. If empty,
%   defaulted
%folders - folders for current and archived. If empty, defaulted to
%   'Current Mice' and 'Archived Mice'
%
%ASM 10/13

if nargin < 3 || isempty(folders)
    folders = {'Current Mice','Archived Mice'};
end
if nargin < 2 || isempty(paths)
    paths = {'\\HARVEYRIG1\Ari','D:\DATA\Ari','\\Resscanvirmen\data\Ari'};
end
if ischar(mice)
    mice = {mice};
end

%cycle through each path
for i = 1:length(paths)
    
    %generate curr and archMice folders
    currMice = fullfile(paths{i},folders{1});
    archMice = fullfile(paths{i},folders{2});
    
    %cycle through mice and move folders
    for j = 1:length(mice)
        if exist(fullfile(currMice,mice{j}),'dir')
            rmdir(fullfile(currMice,mice{j}),'s');
        end
        if exist(fullfile(archMice,mice{j}),'dir')
            rmdir(fullfile(archMice,mice{j}),'s');
        end
    end
end