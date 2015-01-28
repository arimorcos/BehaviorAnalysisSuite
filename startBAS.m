function startBAS(userFile,varargin)
%startBAS.m function to open the GUI

if nargin<1
    silent = false;
    userFile = '';
else
    silent = true;
end

guiObjects.rootPath = mfilename('fullpath'); %get path of package
guiObjects.rootPath = guiObjects.rootPath(1:...
   regexp(guiObjects.rootPath,'startBAS')-1); %remove cellGUI from path

bAS(guiObjects,silent,userFile,varargin);
end