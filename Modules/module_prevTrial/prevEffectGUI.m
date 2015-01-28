%prevEffectGUI

%function to create a GUI to analyze previous effects

function [prevGUI] = prevEffectGUI()
    screens = get(0,'MonitorPositions');
    if size(screens,1) > 1
        scrn = screens(2,:);
    else
        scrn = screens(1,:);
    end
    
    prevGUI.figHandle = figure('Name','Previous Trial Data','NumberTitle','Off','MenuBar','none');
    set(prevGUI.figHandle,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.5*(scrn(4) - scrn(2))...
        0.5*(scrn(3)-scrn(1)) .5*scrn(4)]);
    
    %create trial size entry
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.05 0.05 0.3 0.045],'String','Window Size (Trials): ','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    prevGUI.winSize = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.32 0.05 0.2 0.05],'String','20','Style','edit'); 
    
    prevGUI.winText = uicontrol('FontName','Arial','FontSize',20,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.1 0.5 0.8 0.05],'String','Calculating...','Style','text','BackgroundColor',[0.7969 0.7969 0.7969],...
        'visible','off');
    
    %create plot button
    prevGUI.reward = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
            'Position',[.6 .05 .25 .05],'String','  Only Rewarded','Style','checkbox','BackgroundColor',[0.7969 0.7969 0.7969]);
end