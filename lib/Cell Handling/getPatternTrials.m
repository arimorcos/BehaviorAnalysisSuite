function patternTrials = getPatternTrials(dataCell,matchPattern)
%getPatternTrials.m Function to grab trials which match a specific maze
%pattern
%
%INPUTS
%dataCell - dataCell of trials
%matchPattern - 1 x nSeg array of maze pattern. Any nan elements will be
%   ignored (either option will be accepted)
%
%OUTPUTS
%patternTrials - nTrials x 1 cell array containing cells of trials which
%   match pattern
%
%ASM 11/13

%find trials
patternInd = findPatternTrials(dataCell,matchPattern);

%get trials
patternTrials = dataCell(patternInd);