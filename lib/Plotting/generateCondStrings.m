%generateCondStrings.m

%function to find the number of conditions and generate a cell array of
%strings for trials, rewards and percent correct

function [condStrings] = generateCondStrings(numConds)
    
    condStrings.trials = [];
    condStrings.rewards = [];
    condStrings.percCorr = [];
    for i=1:numConds
       condStrings.trials{i} = ['Condition ',num2str(i),' Trials'];
       condStrings.rewards{i} = ['Condition ',num2str(i),' Rewards'];
       condStrings.percCorr{i} = ['Condition ',num2str(i),' Percent Correct'];
    end
end