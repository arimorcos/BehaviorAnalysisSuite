%copyExper.m 

%function to get the experiment file from the remote computer 

%ASM 6/13/12

function [exper] = copyExper(path,tempName)

%load experiment file
fileName = [path,tempName,'.mat'];
if exist(fileName) ~= 0
    load(fileName,'exper');
else
    exper = 0;
end

end