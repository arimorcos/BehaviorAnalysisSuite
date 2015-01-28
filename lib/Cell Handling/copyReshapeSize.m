%copyReshapeSize.m 

%function to get the experiment file from the remote computer 

%ASM 6/13/12

function [reshapeSize] = copyReshapeSize(path,tempName)

%load experiment file
fileName = [path,tempName,'.mat'];
if exist(fileName) ~= 0
    load(fileName,'reshapeSize');
else
    reshapeSize = 0;
end

end