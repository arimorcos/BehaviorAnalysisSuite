function patternTrials = findPatternTrials(dataCell,matchPattern)
%findPatternTrials.m Function to find trials which match a specific maze
%pattern
%
%INPUTS
%dataCell - dataCell of trials
%matchPattern - 1 x nSeg array of maze pattern. Any nan elements will be
%   ignored (either option will be accepted)
%
%OUTPUTS
%patternTrials - nTrials x 1 logical of whether each trial matches the maze
%   pattern
%
%ASM 11/13

%get maze patterns
[mazePatterns,nSeg] = getMazePatterns(dataCell);

%ensure length of matchPattern matches nSeg
if length(matchPattern) ~= nSeg
    error('matchPattern must have the same number of elements as nSeg (%d)',...
        nSeg);
end

%find out whether to match absolute answer or to match minority/majority
if any(matchPattern < 0) %if any less than 0, mode is minority/majority
    %convert match pattern to accomodate both values for nans
    nNaNs = sum(matchPattern==-2);
    nPatterns = 2^nNaNs;
    matchPattern = repmat(matchPattern,nPatterns,1);
    possiblePatterns = unique(nchoosek(repmat([1 0],1,nSeg),nNaNs),'rows');
    matchPattern(matchPattern==-2) = possiblePatterns;
    matchPattern(matchPattern == -1) = 0;
    
    %now all possibilities exist in match pattern, except 0 signifies
    %minority and 1 signifies majority
    mazePatternsCorr = getMazePatternsCorr(dataCell);
    
    %loop through each pattern and see if it matches mazePatternsCorr
    patternTrials = zeros(length(dataCell),nPatterns);
    for i = 1:nPatterns %for each pattern
        patternTrials(:,i) = arrayfun(@(mazeInd) all(mazePatternsCorr(mazeInd,:)...
            == matchPattern(i,:)),1:size(mazePatternsCorr,1))';
    end
    
    patternTrials = any(patternTrials,2);
else
    
    %convert match pattern to accomodate both values for nans
    nNaNs = sum(isnan(matchPattern));
    nPatterns = 2^nNaNs;
    matchPattern = repmat(matchPattern,nPatterns,1);
    possiblePatterns = unique(nchoosek(repmat([1 0],1,nSeg),nNaNs),'rows');
    matchPattern(isnan(matchPattern)) = possiblePatterns;
    
    %convert to strings
    % mazePatternStr = sprintf('%d',mazePatterns);
    % mazePatternStr = reshape(mazePatternStr,numel(mazePatternStr)/nSeg,nSeg);
    % matchPatternStr = sprintf('%d',matchPattern);
    % matchPatternStr = reshape(matchPatternStr,numel(matchPatternStr)/nSeg,nSeg);
    % mazePatternCell = mat2cell(mazePatternStr,ones(1,size(mazePatternStr,1)),size(mazePatternStr,2)); %convert to cell
    
    %compare
    patternTrials = zeros(length(dataCell),nPatterns);
    for i = 1:nPatterns %for each pattern
        patternTrials(:,i) = arrayfun(@(mazeInd) all(mazePatterns(mazeInd,:)...
            == matchPattern(i,:)),1:size(mazePatterns,1))';
    end
    
    patternTrials = any(patternTrials,2);
end

