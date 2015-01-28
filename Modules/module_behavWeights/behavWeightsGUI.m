function [behavWeightsGUI] = behavWeightsGUI()
%behavWeightsGUI function to create behavWeightsGUI

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end

behavWeightsGUI.figHandle = figure('Name','Behavioral Weights','NumberTitle','Off','MenuBar','none');
set(behavWeightsGUI.figHandle,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.5*(scrn(4) - scrn(2))...
    0.5*(scrn(3)-scrn(1)) .5*scrn(4)]);

%create update button
behavWeightsGUI.update = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.025 .02 .2 .05],'String','Update','Style','togglebutton','BackgroundColor',[0.7969 0.7969 0.7969],'Value',1);

%create export buttons
behavWeightsGUI.exportFig = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.275 .02 .2 .05],'String','Export Figure','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
behavWeightsGUI.exportData = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.525 .02 .2 .05],'String','Export Data','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
behavWeightsGUI.printFig = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[.775 .02 .2 .05],'String','Print Figure','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);

end

