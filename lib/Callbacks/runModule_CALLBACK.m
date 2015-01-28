function runModule_CALLBACK(src,evnt,guiObjects)
%runModule_CALLBACK.m Callback for the run module button
%
%Takes in which data to process and runs module necessary for that process
%
%ASM 9/24/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%get datasets
modData = get(guiObjects.modData,'UserData');

%get which dataset to feed into module
dataStrings = get(guiObjects.modData,'String');
whichData = dataStrings{get(guiObjects.modData,'Value')};
if regexp(whichData,'All')
    dataCell = modData.datasets.all;
    dataCellInd = modData.datasetInd.all;
    procData = modData.proc.all;
    dataFlag = 'ALL';
elseif regexp(whichData,'Last')
    dataCell = modData.datasets.lastX;
    dataCellInd = modData.datasetInd.lastX;
    procData = modData.proc.lastX;
    dataFlag = 'LAST';
elseif regexp(whichData,'Condition')
    condNum = str2double(whichData(isstrprop(whichData,'digit')));
    dataCell = modData.datasets.condition{condNum};
    dataCellInd = modData.datasetInd.condition{condNum};
    procData = modData.proc.condition(condNum);
    dataFlag = ['COND',num2str(condNum)];
end
data = guiObjects.data;
exper = guiObjects.exper;

%get module number
modNum = get(guiObjects.moduleList,'Value');

%run module
eval(guiObjects.modCallbacks{modNum}{1});
end