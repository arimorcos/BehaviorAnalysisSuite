function updateSignificance_CALLBACK(src,evnt,shuffleGUIData,dataCell,percCorr,arrow)

%create results array in which first row is whether trial was left and
%second is whether mouse turned left
results(1,:) = getCellVals(dataCell,'maze.leftTrial')';
results(2,:) = getCellVals(dataCell,'result.leftTurn')';

nSims = str2double(get(shuffleGUIData.nSims,'String'));
alpha = str2double(get(shuffleGUIData.alpha,'String'));
bias = get(shuffleGUIData.bias,'Value');

%perform shuffle
[dist] = shuffleTrialLabels(results,nSims,bias);

%plot data
subplot('Position',[0.05 0.15 0.9 0.8]);
cla reset;
delete(arrow);
[arrow] = plotTrialShuffle(percCorr,dist,alpha);

%reset callback
set(shuffleGUIData.plotButton,'Callback',{@updateSignificance_CALLBACK,shuffleGUIData,dataCell,percCorr,arrow});

end

