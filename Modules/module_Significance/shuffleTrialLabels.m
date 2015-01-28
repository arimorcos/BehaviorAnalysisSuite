function [dist] = shuffleTrialLabels(results,nSim,bias)
%SHUFFLETRIALLABELS This function shuffles the labels of trials nSim times
%to create a distribution of percent corrects for behavioral data
%
%results - 2xnTrial array (1,:) = boolean of whether
%correct answer was left, (2,:) = boolean of whether mouse turned left
%
%nSim - number of simulations to run
%
%bias - flag for whether or not to incorporate mouse's bias. If so, simply
%shuffle the mouse's responses. Otherwise, generate a random set of
%responses.

dist = zeros(1,nSim); %preallocate array for the distribution of percent corrects

for i=1:nSim %for loop to perform nSim simulations
    
    simData = results;
    if bias
        simData(1,:) = simData(1,randperm(size(simData,2))); %shuffle boolean of whether correct answer was left - shuffle correct answer
    else
        simData(2,:) = randi([0 1],size(simData(2,:))); %generate random responses for the mouse
    end
    dist(1,i) = sum(simData(1,:)==simData(2,:))/size(simData,2); %calculate percent correct in shuffled condition and store in dist
    
end
end

