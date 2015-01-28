function runSpeed_CALLBACK(src,evnt,data,dataCell,exper)
%runSpeed_CALLBACK.m Callback for the runSpeed module
%
%Calculates running speed between different regions of the maze and turn
%speed. It then plots these values to a histogram.

if length(dataCell) <= 10
    msgbox('Not enough trials to analyze');
    return;
end

[runGUIData] = runGUI();

set(0,'CurrentFigure',runGUIData.figHandle); %set current figure to background by directly accessing current figure property

turnStartPerc = str2double(get(runGUIData.turnStart,'String'))/100;
runStartPerc = str2double(get(runGUIData.runStart,'String'))/100;
runEndPerc = str2double(get(runGUIData.runEnd,'String'))/100;

%set callback for update button
set(runGUIData.plotButton,'Callback',{@updateRunPlot,data,dataCell,exper,runGUIData});
set(runGUIData.turnStart,'Callback',{@updateRunPlot,data,dataCell,exper,runGUIData});
set(runGUIData.runStart,'Callback',{@updateRunPlot,data,dataCell,exper,runGUIData});
set(runGUIData.runEnd,'Callback',{@updateRunPlot,data,dataCell,exper,runGUIData});

[runData] = runSpeedPerc(data,dataCell,exper,runStartPerc,runEndPerc);
[turnData] = turnSpeed(data,dataCell,exper,turnStartPerc);

%set callback for export button
set(runGUIData.exportButton,'Callback',{@assignToBase,runData,turnData});

subplot('Position',[0.05 0.15 0.9 0.8]);
plotHistRunSpeedGUI(runData,turnData);

end

function assignToBase(src,evnt,runData,turnData)
assignin('base','runData',runData);
assignin('base','turnData',turnData);
end