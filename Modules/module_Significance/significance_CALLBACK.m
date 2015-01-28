function significance_CALLBACK(src,evnt,dataCell)
%significance_CALLBACK.m Callback for the significance module
%
%Takes in guiObjects and uses that to get dataCell designated to be fed into
%module callback by condition listbox. Opens significance gui and plots
%histogram of shuffles along with p value. Data can then be exported to
%base workspace for further analysis if desired. 

%open GUI
[shuffleGUIData] = shuffleGUI();

set(0,'CurrentFigure',shuffleGUIData.figHandle); %set current figure to background by directly accessing current figure property

%get default info
nSims = str2double(get(shuffleGUIData.nSims,'String'));
alpha = str2double(get(shuffleGUIData.alpha,'String'));
bias = get(shuffleGUIData.bias,'Value');

%create results array in which first row is whether trial was left and
%second is whether mouse turned left
results(1,:) = getCellVals(dataCell,'maze.leftTrial')';
results(2,:) = getCellVals(dataCell,'result.leftTurn')';

%perform shuffle
[dist] = shuffleTrialLabels(results,nSims,bias);

%plot data
subplot('Position',[0.05 0.15 0.9 0.8]);
cla reset;
percCorr = sum(findTrials(dataCell,'result.correct==1'))/length(dataCell);
[arrow] = plotTrialShuffle(percCorr,dist,alpha);

%set callback for update button
set(shuffleGUIData.plotButton,'Callback',{@updateSignificance_CALLBACK,shuffleGUIData,dataCell,percCorr,arrow});

