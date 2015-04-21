function [ind] = findTrials(dataCell,cond)
%findTrials.m This function returns the indices of trials in data which
%meet cond
%
%ASM 9/12 modified from tfind.m ART

%check if empty
if isempty(cond)
    ind = true(length(dataCell),1);
    return;
end

%check if prevTrial
if strcmp(cond(1:min(length(cond),10)),'prevTrial;') %if starts with prevTrial
    prevTrial = true;
    %strip it out
    cond(1:10) = [];
    
    %search for currTrial 
    if strfind(cond,';currTrial;')
        currCond = cond(strfind(cond,';currTrial;'):end);
        cond = cond(1:strfind(cond,';currTrial;')-1);
        currCond = currCond(12:end);
        
        %find trials which match curr conditions
        currInd = findTrials(dataCell,currCond);
    else
        currInd = true(length(dataCell),1);
    end
else
    prevTrial = false;
end

%check if pattern
if isnumeric(cond) || strcmp(cond(1),'[')
    
    if strcmp(cond(1),'[')
        %strip out part of cond used for pattern
        startInd = strfind(cond,'[');
        stopInd = strfind(cond,']');
        pattStr = cond(startInd:stopInd);
        pattCond = eval(pattStr);
    end
    ind = false(length(dataCell),1);
    for pattern = 1:size(pattCond,1)
        addInd = findPatternTrials(dataCell,pattCond(pattern,:));
        ind(addInd) = true;
    end
    if length(cond) > stopInd+1 %if longer than stopInd+1
        cond = cond(stopInd+2:end);
        pattInd = ind;
    else
        return;
    end
end

%check if net evidence is part and if it is, strip it out
if strfind(cond,'netEv') %if matches netEv
    
    %check that it matches format of netEv==x,x
    if isempty(regexpi(cond,'netEv==\d,(\d|-\d|+\d)')) %if doesn't match format
        error('Incorrect format for net evidence. Must be in the format ''netEv==seg,netEv''');
    end
    
    %get indices
    [startInd,endInd] = regexpi(cond,'netEv==\d,(\d|-\d|+\d)');
    evStr = cond(startInd:endInd);
    if length(cond) > endInd
        cond = cond(endInd+1:end);
        if strcmp(cond(1),';')
            cond = cond(2:end);
        end
    else
        cond = [];
    end
end

if ~isempty(cond)
    %parse the condition
    parsedCond = parseCondAM(cond);
    
    if isempty(parsedCond)
        ind = ones(size(dataCell));
        return;
    end
    
    %loop through each parsed cond, and if function present, evaluate and
    %convert
    for i = 1:length(parsedCond) %for each parsed cond
        %search for !
        bangInd = regexp(parsedCond{i},'!','once');
        if isempty(bangInd) %skip if not present
            continue;
        end
        
        %extract section after bang
        bangPhrase = parsedCond{i}(bangInd+1:end-2);
        
        %evaluate bangPhrase
        bangVal = eval(bangPhrase);
        
        %replace parsedCond
        parsedCond{i} = [parsedCond{i}(1:bangInd-1),num2str(bangVal),' )'];
        
    end
    
    %combine parsed conditions
    %This section takes individual cell elements and converts them into
    %testable conditions
    if ischar(parsedCond)
        logicals = {parsedCond};
    elseif iscell(parsedCond) %multiple conditions to test
        logicals = cell(1,size(parsedCond,2));
        for i=1:size(parsedCond,2) %for each @ condition
            logicals{i} = [];
            for j=1:size(parsedCond,1) %for each subcondition
                if j==size(parsedCond,1) %if last condition
                    logicals{i} = [logicals{i},parsedCond{j,i}];
                else
                    logicals{i} = [logicals{i},parsedCond{j,i},' && '];
                end
            end
        end
    end
    
    %extract indices which meet conditions
    ind = zeros(length(dataCell),length(logicals)); %initialize ind to have as many rows as cells in data and as many columns as @ conditions
    
    %loop through each logical condition
    for i=1:size(logicals,2)
        %create condFun
        eval(['condFun = @(x) ',logicals{i},';']);
        
        if ~isempty(dataCell)
            %run cellfun
            ind(:,i) = cellfun(condFun,dataCell);
        else
            ind(:,i) = [];
        end
    end
    ind = logical(ind); %convert to a logical
else
    ind = true(length(dataCell),1);
end

if exist('evStr','var') %if evStr exists
    
    %get net evidence
    netEv = getNetEvidence(dataCell);
    
    %process string
    evStrProc = regexp(evStr,'netEv==(\d),((\d|-\d|+\d))$','tokens');
    segNum = str2double(evStrProc{1}{1});
    selNetEv = str2double(evStrProc{1}{2});
    
    %extract segment
    netEv = netEv(:,segNum);
    
    %find trials which match netEv
    netEvMatch = netEv == selNetEv;
    
    ind = ind & netEvMatch;
    
end

if exist('pattStr','var') %if pattStr exists
    ind = ind & pattInd;
end

%if prevTrial, add 1 to every index
if prevTrial
    
    %shift all inds by 1 
    ind(end) = [];
    ind = cat(1,false,ind);
    
    %remove inds that don't have an immediate previous trial
    if isfield(dataCell{1}.maze,'originalTrialInd')
        trialInds = getCellVals(dataCell,'maze.originalTrialInd');
        origTrialInd = trialInds(find(ind)-1);
        newTrialInd = trialInds(ind);
        diffInd = newTrialInd - origTrialInd;
        removeInd = diffInd > 1;
        ind(ismember(trialInds,newTrialInd(removeInd))) = false;        
    end
    
    %take currInd as well
    ind = ind & currInd;
end





