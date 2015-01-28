function [shuffleGUI] = shuffleGUI()
%SHUFFLEGUI function to create shuffleGUI
    
    screens = get(0,'MonitorPositions');
    if size(screens,1) > 1
        scrn = screens(2,:);
    else
        scrn = screens(1,:);
    end
    
    shuffleGUI.figHandle = figure('Name','Shuffle','NumberTitle','Off','MenuBar','none');
    set(shuffleGUI.figHandle,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.5*(scrn(4) - scrn(2))...
        0.5*(scrn(3)-scrn(1)) .5*scrn(4)]);
    
    %create text entry
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.05 0.02 0.2 0.045],'String','# of Simulations','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    shuffleGUI.nSims = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.26 0.02 0.1 0.05],'String','10000','Style','edit'); 
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.37 0.02 0.06 0.045],'String','Alpha','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    shuffleGUI.alpha = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.44 0.02 0.1 0.05],'String','0.05','Style','edit'); 
    uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[0.55 0.02 0.06 0.045],'String','Bias','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    shuffleGUI.bias = uicontrol('ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[0.7969 0.7969 0.7969],...
        'Position',[0.61 0.02 0.02 0.05],'Style','checkbox'); 
    
    %create plot button
    shuffleGUI.plotButton = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
            'Position',[.7 .02 .25 .05],'String','Update','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
end

