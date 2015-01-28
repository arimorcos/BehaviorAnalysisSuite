function [integrationGUI] = integrationGUI()
%integrationGUI function to create integrationGUI

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end

integrationGUI.figHandle = figure('Name','Integration Curve','NumberTitle','Off','MenuBar','none');
set(integrationGUI.figHandle,'OuterPosition',[scrn(1)+0.5*scrn(3) 0.5*scrn(4)...
    0.5*scrn(3) .5*scrn(4)]);

%create update button
integrationGUI.update = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.025 .02 .2 .05],'String','Update','Style','togglebutton','BackgroundColor',[0.94 0.94 0.94],'Value',1);

%create export button
integrationGUI.exportFig = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.275 .02 .2 .05],'String','Export Figure','Style','pushbutton','BackgroundColor',[0.94 0.94 0.94]);
integrationGUI.exportData = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.525 .02 .2 .05],'String','Export Data','Style','pushbutton','BackgroundColor',[0.94 0.94 0.94]);
integrationGUI.printFig = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.775 .02 .2 .05],'String','Print Figure','Style','pushbutton','BackgroundColor',[0.94 0.94 0.94]);

end

