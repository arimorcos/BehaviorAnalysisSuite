function moveCurrentToArchived(mice,paths,folders)
%moveCurrentToArchived.m Moves mice from current mice folder to archived
%mice folder on all computers present in paths
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
    paths = {'\\HARVEYRIG1\Ari','D:\DATA\Ari',...
        'Z:\HarveyLab\Ari\DATA\Ari','\\HARVYELAB-RESSC\Data\Ari'};
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
        fileToMove = fullfile(currMice,mice{j});
        if exist(fileToMove,'dir')
            movefile(fileToMove,archMice,'f'); %move folder
        end
    end
end