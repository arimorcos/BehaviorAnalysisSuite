function [turnSegGUI] = turnSegGUI()
%integrationGUI function to create integrationGUI

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end

turnSegGUI.figHandle = figure('Name','Integration Curve','NumberTitle','Off','MenuBar','none');
set(turnSegGUI.figHandle,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.5*(scrn(4) - scrn(2))...
    0.5*(scrn(3)-scrn(1)) .5*scrn(4)]);

%create update button
turnSegGUI.means = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.025 .02 .2 .05],'String','Means','Style','togglebutton','BackgroundColor',[0.7969 0.7969 0.7969],'Value',1);

%create export button
turnSegGUI.exportFig = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.275 .02 .2 .05],'String','Export Figure','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
turnSegGUI.exportData = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.525 .02 .2 .05],'String','Export Data','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
turnSegGUI.printFig = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.775 .02 .2 .05],'String','Print Figure','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);

end

