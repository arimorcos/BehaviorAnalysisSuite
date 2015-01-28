%updateRunPlot

%function callback for runSpeed plot to update with new values

function updateRunPlot(src,evnt,data,dataCell,exper,runGUI)

turnStartPerc = str2double(get(runGUI.turnStart,'String'))/100;
runStartPerc = str2double(get(runGUI.runStart,'String'))/100;
runEndPerc = str2double(get(runGUI.runEnd,'String'))/100;

[runData] = runSpeedPerc(data,dataCell,exper,runStartPerc,runEndPerc);
[turnData] = turnSpeed(data,dataCell,exper,turnStartPerc);

%set callback for export button
set(runGUI.exportButton,'Callback',{@assignToBase,runData,turnData});

subplot('Position',[0.05 0.15 0.9 0.8]);
cla reset;
plotHistRunSpeedGUI(runData,turnData);

end

function assignToBase(src,evnt,runData,turnData)
assignin('base','runData',runData);
assignin('base','turnData',turnData);
end