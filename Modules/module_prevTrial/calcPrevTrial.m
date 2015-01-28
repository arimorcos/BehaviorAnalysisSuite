function [meanLeft,meanWhite,stdLeft,stdWhite] = calcPrevTrial(dataCell,win,reward)

if length(dataCell) > win + 20
    
    probLastLeft = cell(1,5);
    probLastWhite = cell(1,5);
    ranges = [0 0.2 0.4 0.6 0.8];
    
    if reward
        dataCell = getTrials(dataCell,'result.correct==1');
    end
    
    for i=win+1:length(dataCell) %for each trial
        dataSub = dataCell(i-win:i-1);
        
        probLeft = sum(findTrials(dataSub,'maze.leftTrial==1'))/win;
        probWhite = sum(findTrials(dataSub,'maze.whiteTrial==1'))/win;
        
        leftInd = find(probLeft >= ranges,1,'last');
        whiteInd = find(probWhite >= ranges,1,'last');
        probLastLeft{leftInd}(length(probLastLeft{leftInd})+1) = dataCell{i}.result.leftTurn;
        probLastWhite{whiteInd}(length(probLastWhite{whiteInd})+1) = dataCell{i}.result.whiteTurn;
    end
    
    meanLeft = zeros(1,5);
    meanWhite = zeros(1,5);
    stdLeft = zeros(1,5);
    stdWhite = zeros(1,5);
    for i=1:5
        meanLeft(i) = mean(probLastLeft{i});
        meanWhite(i) = mean(probLastWhite{i});
        stdLeft(i) = std(probLastLeft{i});
        stdWhite(i) = std(probLastWhite{i});
    end
end
end