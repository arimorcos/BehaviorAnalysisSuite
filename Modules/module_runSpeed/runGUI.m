%runGUI

%function to create a GUI to analyze run Speed

function [runGUI] = runGUI()
    screens = get(0,'MonitorPositions');
    if size(screens,1) > 1
        scrn = screens(2,:);
    else
        scrn = screens(1,:);
    end
    
    runGUI.figHandle = figure('Name','Run Speed','NumberTitle','Off','MenuBar','none');
    set(runGUI.figHandle,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.5*(scrn(4) - scrn(2))...
        0.5*(scrn(3)-scrn(1)) .5*scrn(4)]);
    
    %create percentages entry
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.05 0.02 0.13 0.045],'String','Run Start %','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    runGUI.runStart = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.19 0.02 0.05 0.05],'String','25','Style','edit'); 
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.26 0.02 0.13 0.045],'String','Run End %','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    runGUI.runEnd = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.4 0.02 0.05 0.05],'String','75','Style','edit'); 
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.47 0.02 0.13 0.045],'String','Turn Start %','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    runGUI.turnStart = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.62 0.02 0.05 0.05],'String','90','Style','edit'); 
    
    %create plot button
    runGUI.plotButton = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
            'Position',[.7 .02 .125 .05],'String','Update','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
        
    %Create export button
    runGUI.exportButton = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
            'Position',[.85 .02 .125 .05],'String','Export','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
end