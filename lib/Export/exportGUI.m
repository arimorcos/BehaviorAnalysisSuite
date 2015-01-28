function [exportGUIData] = exportGUI()
%exportGUI.m Function to create export data GUI

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end

exportGUIData.figHandle = figure('Name','Export Data','NumberTitle','Off','MenuBar','none');
set(exportGUIData.figHandle,'OuterPosition',[scrn(1)+0.5*scrn(3) 0.7*scrn(4)...
    0.2*scrn(3) .3*scrn(4)]);

exportGUIData.winButton = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 .75 .8 .2],...
    'String','Save Sliding Window','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);

exportGUIData.dataList = uicontrol('FontName','Arial','FontSize',11,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 .3 .8 .4],...
    'Style','listbox','BackgroundColor',[1 1 1],'String',{'All Data'},...
    'HorizontalAlignment','Center');

exportGUIData.subsetButton = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 .05 .8 .2],...
    'String','Export Data Subset','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
    
    