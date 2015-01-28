function [procString] = parseCondAM(str)
%parseCondAM.m Function to parse strings
%
%This function takes in a string of conditions and parses it to create a
%format readable by Matlab. The output can then be read and processed to
%filter the dataCell array. There are several ways to do this.
%
%To specify a single condition, simply input a string designating the
%subfields of dataCell, ignoring dataCell itself and the operator. For
%example, to extract all correct trials, input 'result.correct==1'. 
%
%One can also specify multiple values for a given condition. For example,
%the string 'result.correct==0,1' will be parsed to mean 'result.correct==0
%|| result.correct==1'. The operator in between the two values can be an
%and or an or and depends on the operator used to designate the condition.
%'==' makes use of the or operator (||), while '~=' makes use of the '&&'
%operator. So the string 'maze.condition~=1,2' would read as
%'maze.condition ~= 1 && maze.condition ~= 2'. Note that only one value can
%be designated for the greater than and less than operators. 
%
%The user can also specify mutliple operators for the same parameter
%separated by & or | (single). For example, 'maze.condition == 1 | > 2'
%will return 'maze.condition ==1 || maze.condition > 2'. Note that the same
%operator cannot be reused. This will return an error otherwise. 
%
%The user can also specify ranges as a single condition with less than. For
%example, '4 < maze.condition <= 6' will return 'maze.condition > 4 &&
%maze.condition <= 6'. This can only be used less than and multiple values
%cannot be used. 
%
%To specify multiple conditions, input several strings as above separated
%by a semicolon. The conditions will then be combined with an && in between
%them. Note that a semicolon is only necessary between conditions, and not
%at the end of the last condition. 
%
%
%ASM 9/12

%if isempty return
if isempty(str)
    procString = str;
    return;
end

%remove spaces
str = str(~isspace(str));

%look for semicolon
semicolons = strfind(str,';');
nConds = length(semicolons)+1;
condInd = 1;

%check for @
if str(1)=='@';atCond = true; else atCond = false; end

%initialize
if atCond; procString = cell(nConds,2);else procString = cell(nConds,1); end

for i=1:nConds
    clear operator
    %Break string into components
    if i < nConds
        currStr = str(condInd:semicolons(i)-1); %partition string into single condition if one
    elseif i == nConds && nConds > 1 %if this is the last condition and there are more than one
        currStr = str(condInd:end);
    else
        currStr = str;
    end
    
    
    %check for digit first (10 < x < 20 format)
    if isstrprop(currStr(1),'digit') || currStr(1)=='.' || (currStr(1)=='@'&&(isstrprop(currStr(2),'digit')||currStr(2)=='.'));
        digCond = true; else digCond = false; end
        %check for two or more conditions not separated by semicolon
    if find(isstrprop(str,'alpha'),1,'last') > find(isstrprop(str,'digit'),1,'first') && nConds == 1 && ~digCond
        error('Mutliple conditions not separated by semicolon');
    end
    if digCond
        opInd(1)=find(~isstrprop(currStr,'alphanum')&~isstrprop(currStr,'punct'),1,'first'); %find the first character that is not alphabetical or punctuation - must be operator
        val{1} = currStr(1:opInd(1)-1);
        param = currStr(find(isstrprop(currStr,'alpha'),1,'first'):find(isstrprop(currStr,'alpha'),1,'last'));
        operator{1} = currStr(opInd(1):find(isstrprop(currStr,'alpha'),1,'first')-1);
        currStrSub = currStr(find(isstrprop(currStr,'alpha'),1,'last')+1:end);
        operator{2} = currStrSub(1:find(isstrprop(currStrSub,'digit')|isstrprop(currStrSub,'punct'),1,'first')-1);
        val{2} = currStrSub(find(isstrprop(currStrSub,'digit')|isstrprop(currStrSub,'punct'),1,'first'):...
            find(isstrprop(currStrSub,'digit'),1,'last'));
        if find(isstrprop(currStr,'alpha'),1,'last') > find(isstrprop(currStr,'digit'),1,'last')
            error('Starting with digit must contain format of 10 < x < 20');
        elseif ~isempty(strfind(currStr,','))
            error('Cannot have multiple values in format 10 < x < 20');
        elseif sum(strcmp(operator,'>'))>0 || sum(strcmp(operator,'>='))>0
            error('Cannot have > or >= in the format 10 < x < 20');
        elseif (currStr(1)=='@'&&isstrprop(currStr(2),'digit'))
            error('Cannot use @ with format 10 < x < 20');
        end
    else
        opInd = find(~isstrprop(currStr,'alpha')&~isstrprop(currStr,'punct'),1,'first'); %find the first character that is not alphabetical or punctuation - must be operator
        param = currStr(1:opInd-1); %get parameter string (first index to last index before operator)
        valInd = opInd-1+find(isstrprop(currStr(opInd:end),'digit')|isstrprop(currStr(opInd:end),'punct'),1,'first'); %find first digit input
        operator{1} = currStr(opInd:valInd-1); %get operator string (first operator index to last index before values
        
        %search for other operators and store
        otherOps = sort(cat(2,strfind(currStr,'&'),strfind(currStr,'|'))); %get indices of other operators
        for j=1:length(otherOps)
            operator{j+1} = currStr(otherOps(j)+1:...
                find(isstrprop(currStr(otherOps(j):end),'digit'),1,'first')+otherOps(j)-2); %#ok<AGROW> %search for operator from index to first digit in string from operator
        end
        
        %get all values (separated by a comma)
        vals = cell(length(operator),1);
        for j=1:length(operator)
            if j<length(operator)
                opValStr = currStr(strfind(currStr,operator{j})+length(operator{j}):...
                    strfind(currStr,operator{j+1})-2); %create string of just the values following the operator of interest
            else
                opValStr = currStr(strfind(currStr,operator{j})+length(operator{j}):end); %if last operator, set string to end
            end
            commas = strfind(opValStr,','); %find indices of commas
            vals{j} = cell(length(commas)+1,1); %initialize cell the size of values
            if ~isempty(commas)
                vals{j,1} = opValStr(1:commas(1)-1); %set first value (before comma)
            else
                vals{j,1} = opValStr;
            end
            for k=1:length(commas) %for each comma get the value following it
                if k==length(commas) %if this is the last comma, go to end rather than next comma
                    vals{j,k+1} = opValStr(commas(k)+1:end);
                else
                    vals{j,k+1} = opValStr(commas(k)+1:commas(k+1)-1); %get the value in between the commas
                end
            end
        end
    end
    
    %check for !
    if strcmp(vals{1}(1),'!') %if starts with bang
        %find property to test
        [testProp,testPropInd] = regexp(vals{1},'(?<=\()[^"]+(?=\))', 'match');
        
        %get beginning of section
        funcStr = vals{1}(1:testPropInd-2);
        
        %create string
        vals{1} = sprintf('%s(getCellVals(dataCell,''%s''))',funcStr,testProp{1});
        
    end
    
    %check for @
    if atCond && i==1
        atCount = 0;
        for j=1:length(operator) %for each of the operators
            for k=1:sum(cellfun(@(x) ~isempty(x),vals(j,:))) %for each of the corresponding values
                %construct string for each
                atCount = atCount + 1;
                procString{1,atCount} = ['( x.',param(2:end),operator{j},vals{j,k},' )'];
                if ~ismember(operator{j},{'==','~=','>','<','>=','<='})
                    error(['Operator not recognized: ',operator{j}]);
                end
            end
            if sum(strcmp(operator,operator{j}))>1 %if operator is reused
                error(['Cannot reuse operators. The following operator was reused: ',operator{j}]);
            end
        end
    elseif length(operator) > 1 && ~digCond  % if there are multiple operators
        procString{i,1} = '(';
        for j=1:length(operator) %for each operator
            procString{i,1} = [procString{i,1},' x.',param,operator{j},vals{j,1}]; %initialize first part of string which will be something like x.y == 5
            switch operator{j}
                case '=='
                    for k=2:sum(cellfun(@(x) ~isempty(x),vals(j,:))) %for each value
                        procString{i,1} = [procString{i,1},' || x.',param,operator{j},vals{j,k}]; %add or and other parameters
                    end
                case '~='
                    for k=2:sum(cellfun(@(x) ~isempty(x),vals(j,:))) %for each value
                        procString{i,1} = [procString{i,1},' && x.',param,operator{j},vals{j,k}]; %add && and other parameters
                    end
                case {'<=','>=','<','>'}
                    if sum(cellfun(@(x) ~isempty(x),vals(j,:))) > 1
                        error('Can only have one input value for greater/less than operators');
                    end
                otherwise
                    error(['Operator not recognized: ',operator{j}]);
            end
            if j~=length(operator)
                procString{i,1} = [procString{i,1},' ) ',currStr(otherOps(j)),...
                    currStr(otherOps(j)),' ('];
            else
                procString{i,1} = [procString{i,1},' )'];
            end
            if sum(strcmp(operator,operator{j}))>1 %if operator is reused
                error(['Cannot reuse operators. The following operator was reused: ',operator{j}]);
            end
        end
    elseif digCond
        if strcmp(operator{1},'<=') 
            operator{1} = '>=';
        elseif strcmp(operator{1},'<')
            operator{1} = '>';
        end
        procString{i,1} = ['( x.',param,operator{1},val{1},' && x.',param,operator{2},val{2},' )'];
    else
        procString{i,1} = ['( x.',param,operator{1},vals{1,1}]; %initialize first part of string which will be something like x.y == 5
        switch operator{1}
            case '=='
                for k=2:sum(cellfun(@(x) ~isempty(x),vals(1,:))) %for each value
                    procString{i,1} = [procString{i,1},' || x.',param,operator{1},vals{k}]; %add or and other parameters
                end
            case '~='
                for k=2:sum(cellfun(@(x) ~isempty(x),vals(1,:))) %for each value
                    procString{i,1} = [procString{i,1},' && x.',param,operator{1},vals{k}]; %add && and other parameters
                end
            case {'<=','>=','<','>'}
                if length(vals) > 1
                    error('Can only have one input value for greater/less than operators');
                end
            otherwise
                error(['Operator not recognized: ',operator{1}]);
        end
        procString{i,1} =[procString{i,1},' )'];
    end
    
    %copy to other cell columns if atCond
    if atCond && i>1
        for j=1:atCount
            procString{i,j} = procString{i,1};
        end
    end
    
    %update condInd
    if i<nConds
        condInd = semicolons(i)+1;
    end
end