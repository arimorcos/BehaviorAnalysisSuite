function [listGUI] = listFiles(filenames)
%listFiles.m Function to create window with list of files currently open

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end

if iscell(filenames)
    numFiles = length(filenames);
else
    numFiles = 1;
    filenames = {filenames};
end

listGUI = figure('Name','Currently Loaded Files','NumberTitle','Off','MenuBar','none');
set(listGUI,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) (1-numFiles/20)*(scrn(4) - scrn(2))...
    0.2*(scrn(3)-scrn(1)) (numFiles/20)*scrn(4)]);

for i=1:numFiles
    uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold','ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.05 (i-1.25)/numFiles 0.9 1/numFiles],'String',filenames{i},...
    'Style','text','BackgroundColor',[0.7969 0.7969 0.7969],'HorizontalAlignment','Center');
end

end