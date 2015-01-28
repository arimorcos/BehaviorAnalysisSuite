function exportPosVelGUI(posVelGUIData,shouldPrint)
%exportGUI.m Function to create export data GUI

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end

exportGUIData.figHandle = figure('Name','Export Data','NumberTitle','Off','MenuBar','none');
set(exportGUIData.figHandle,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.5*(scrn(4) - scrn(2))...
    0.2*(scrn(3)-scrn(1)) .3*scrn(4)]);

yHeights = linspace(0.05,0.95,10);

exportGUIData.yVelPlot = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-1) .8 .1],...
    'String','Y Velocity','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,1,shouldPrint,exportGUIData});

exportGUIData.xVelPlot = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-2) .8 .1],...
    'String','X Velocity','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,0,shouldPrint,exportGUIData});

exportGUIData.bothVel = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-3) .8 .1],...
    'String','Both Velocities','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,2,shouldPrint,exportGUIData});

exportGUIData.yPosPlot = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-4) .8 .1],...
    'String','Y Position','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,3,shouldPrint,exportGUIData});

exportGUIData.xPosPlot = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-5) .8 .1],...
    'String','X Position','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,4,shouldPrint,exportGUIData});

exportGUIData.viewAngle = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-6) .8 .1],...
    'String','View Angle','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,5,shouldPrint,exportGUIData});

exportGUIData.allPos = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-7) .8 .1],...
    'String','Both Positions and View Angle','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,6,shouldPrint,exportGUIData});

exportGUIData.xVelyPos = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-8) .8 .1],...
    'String','X Velocity vs. Y Position','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,7,shouldPrint,exportGUIData});

exportGUIData.all = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.1 yHeights(end-9) .8 .1],...
    'String','Position and Velocity','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@exportFig_CALLBACK,posVelGUIData,8,shouldPrint,exportGUIData});

align([exportGUIData.all exportGUIData.allPos exportGUIData.viewAngle ...
    exportGUIData.xPosPlot exportGUIData.yPosPlot exportGUIData.bothVel ...
    exportGUIData.xVelPlot exportGUIData.yVelPlot exportGUIData.xVelyPos],...
    'HorizontalAlignment','Distribute','Vertical Alignment','Distribute');

end

function exportFig_CALLBACK(src,evnt,trialVelGUIData,subset,shouldPrint,exportGUIData)
delete(exportGUIData.figHandle);

saveFig = figure('visible','off','OuterPosition',get(trialVelGUIData.figHandle,'Position'));
set(saveFig,'Units','Normalized','OuterPosition',[0 0 1 1]);

switch subset 
    case 0 %x velocity plot only
        savePlot = copyobj(trialVelGUIData.xVelPlot,saveFig);
        set(savePlot,'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.8150]);
        legend = copyobj(trialVelGUIData.xVelLegend,saveFig);
        set(legend,'visible','on');
        title('X Velocity vs. Trial Time');
    case 1 %y velocity plot only
        savePlot = copyobj(trialVelGUIData.yVelPlot,saveFig);
        set(savePlot,'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.8150]);
        legend = copyobj(trialVelGUIData.yVelLegend,saveFig);
        set(legend,'visible','on');
        title('Y Velocity vs. Trial Time')
    case 2 %both velocities
        savePlot(1) = copyobj(trialVelGUIData.xVelPlot,saveFig);
        savePlot(2) = copyobj(trialVelGUIData.yVelPlot,saveFig);
        legend = copyobj(trialVelGUIData.yVelLegend,saveFig);
        set(legend,'visible','on');
        set(savePlot(1),'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.3412]);
        set(savePlot(2),'Units','Normalized','Position',[0.1300 0.5838 0.7750 0.3412]);
        title('Velocity vs. Trial Time');
    case 3 %y position
        savePlot = copyobj(trialVelGUIData.yPosPlot,saveFig);
        set(savePlot,'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.8150]);
        legend = copyobj(trialVelGUIData.yPosLegend,saveFig);
        set(legend,'visible','on');
        title('Y Position vs. Trial Time');
    case 4 %x position
        savePlot = copyobj(trialVelGUIData.xPosPlot,saveFig);
        set(savePlot,'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.8150]);
        legend = copyobj(trialVelGUIData.xPosLegend,saveFig);
        set(legend,'visible','on');
        title('X Position vs. Trial Time');
    case 5 %theta
        savePlot = copyobj(trialVelGUIData.thetaPlot,saveFig);
        set(savePlot,'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.8150]);
        legend = copyobj(trialVelGUIData.thetaLegend,saveFig);
        set(legend,'visible','on');
        title('View Angle vs. Trial Time');
        
    case 6 %all positions
        savePlot(1) = copyobj(trialVelGUIData.xPosPlot,saveFig);
        savePlot(2) = copyobj(trialVelGUIData.yPosPlot,saveFig);
        savePlot(3) = copyobj(trialVelGUIData.thetaPlot,saveFig);
        legend = copyobj(trialVelGUIData.yPosLegend,saveFig);
        set(legend,'visible','on');
        set(savePlot(1),'Units','Normalized','Position',[0.1300 0.4096 0.7750 0.2157]);
        set(savePlot(2),'Units','Normalized','Position',[0.1300 0.7093 0.7750 0.2157]);
        set(savePlot(3),'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.2157]);
    case 7 %xVel vs. yPos
        savePlot = copyobj(trialVelGUIData.xVelYPosPlot,saveFig);
        set(savePlot,'Units','Normalized','Position',[0.1300 0.1100 0.7750 0.8150]);
        legend = copyobj(trialVelGUIData.xVelYPosLegend,saveFig);
        set(legend,'visible','on');
        title('X Velocity vs. Y Position');
    case 8 %all plots
        savePlot(1) = copyobj(trialVelGUIData.yVelPlot,saveFig);
        savePlot(2) = copyobj(trialVelGUIData.xVelPlot,saveFig);
        savePlot(3) = copyobj(trialVelGUIData.yPosPlot,saveFig);
        savePlot(4) = copyobj(trialVelGUIData.xPosPlot,saveFig);
        savePlot(5) = copyobj(trialVelGUIData.thetaPlot,saveFig);
        savePlot(6) = copyobj(trialVelGUIData.xVelYPosPlot,saveFig);
        legend = copyobj(trialVelGUIData.yVelLegend,saveFig);
        set(legend,'visible','on');
        set(savePlot(1),'Units','Normalized','Position',[0.1300 0.8 0.7750 0.1131]);
        set(savePlot(2),'Units','Normalized','Position',[0.1300 0.65 0.7750 0.1131]);
        set(savePlot(3),'Units','Normalized','Position',[0.1300 0.5 0.7750 0.1131]);
        set(savePlot(4),'Units','Normalized','Position',[0.1300 0.35 0.7750 0.1131]);
        set(savePlot(5),'Units','Normalized','Position',[0.1300 0.2 0.7750 0.1131]);   
        set(savePlot(6),'Units','Normalized','Position',[0.1300 0.05 0.7750 0.1131]);   
end

if shouldPrint
    for i=1:length(savePlot)
        set(savePlot(i),'FontSize',15);
        set(get(savePlot(i),'XLabel'),'FontSize',16);
        set(get(savePlot(i),'YLabel'),'FontSize',16);
        set(get(savePlot(i),'Title'),'FontSize',18);
    end
    set(saveFig,'PaperPositionMode', 'manual', ...
    'PaperUnits','centimeters', ...
    'Paperposition',[1.27 1.27 20.32 26.67])
    printdlg(saveFig);
    return;
else
    for i=1:length(savePlot)
        set(savePlot(i),'FontSize',20);
        set(get(savePlot(i),'XLabel'),'FontSize',28);
        set(get(savePlot(i),'YLabel'),'FontSize',28);
        set(get(savePlot(i),'Title'),'FontSize',28);
    end
end


[filename,pathname] = uiputfile({'*.eps','EPS (*.eps)';...
    '*.jpg','JPEG Image(*.jpg)';'*.fig','MATLAB Figure (*.fig)';...
    '*.png','PNG Image (*.png)';'*.tif','TIFF Image (*.tif)';...
    '*.pdf','PDF File (*.pdf)'});
if filename ~= 0
    switch upper(filename(find(filename=='.',1,'last')+1:end))
        case 'EPS'
            export_fig(saveFig,[pathname,filename],'-eps');
        case 'JPG'
            export_fig(saveFig,[pathname,filename],'-jpg');
        case 'FIG'
            saveas(saveFig,[pathname,filename],'-loose','-r300');
        case 'PNG'
            export_fig(saveFig,[pathname,filename],'-png');
        case 'TIF'
            export_fig(saveFig,[pathname,filename],'-tif');
        case 'PDF'
            export_fig(saveFig,[pathname,filename],'-pdf');
    end
end
close(saveFig);
end
    
    