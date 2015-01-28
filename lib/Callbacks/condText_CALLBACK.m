function condText_CALLBACK(src,evnt,dataCell,data,guiObjects,online)
%condText_CALLBACK.m Callback for the condition entries
%
%This function is called anytime a conditional text window is modified and
%the check is activated. It culls trials according to the condition entered
%and analyzes that small subset.
%
%ASM 9/19/12

%get most up to date guiObjects
guiObjects = get(guiObjects.figHandle,'UserData');

%set check 
callbackOrigin = find([guiObjects.condText,guiObjects.condRange] == src);
if callbackOrigin > 4; callbackOrigin = callbackOrigin - 4; end
if ~isempty(callbackOrigin)
    set(guiObjects.condCheck(callbackOrigin),'Value',1);
end

%get conditional text
condStrings = {};
ind = 1;
vals = [];
for i = 1:4
    if get(guiObjects.condCheck(i),'Value') %if box is checked
        condStrings{ind} = get(guiObjects.condText(i),'String');  %#ok<*AGROW>
        if strcmp(condStrings{ind},'Enter Condition Text Here') %if root text
            if strcmp(get(guiObjects.condRange(i),'String'),':')
                condStrings{ind} = []; %set to empty
            else
                condStrings{ind} = 'result.correct==0,1';
            end
        end
        vals(ind) = i; %#ok<*NASGU> %store which textbox it came from
        ind = ind+1;
    end
end

%process whole data
lastX = str2double(get(guiObjects.lastX,'String'));
[procData] = processDataCell(data,dataCell);
table{1} = convertToTableCell(procData);
table{1}.vals = vals;

%save whole data to modObject
modDataStore.datasets.all = dataCell;
modDataStore.datasetInd.all = ones(size(dataCell));
modDataStore.proc.all = procData;

%process last x if online
if online && length(dataCell)>=lastX
    [procDataLastX] = processDataCell(data,dataCell(end+1-lastX:end),true);
    table{2} = convertToTableCell(procDataLastX);
    table{2}.vals = vals;
    table{1}.lastX = true;
    table{1}.lastXNum = lastX;
    set(guiObjects.modData,'String',...
        {'All Data',['Last ',num2str(lastX),' Trials']});
    modDataStore.datasets.lastX = dataCell(end+1-lastX:end);
    modDataStore.datasetInd.lastX = [zeros(1,length(dataCell)-lastX) ones(1,lastX)];
    modDataStore.proc.lastX = procDataLastX;
else
    table{1}.lastX = false;
    table{1}.lastXNum = lastX;
    set(guiObjects.modData,'String',{'All Data'});
end

if all(cellfun(@(x) isempty(x),condStrings)) %if all of the text boxes are empty
    updateTableCell(table,guiObjects);
    set(guiObjects.modData,'UserData',modDataStore,'Value',1);
    set(guiObjects.figHandle,'UserData',guiObjects);
    return; %return out of the function
end

%process data subsets
nConds = length(condStrings); %get number of conditions
noTrials = zeros(1,nConds);
for i=1:nConds
    if online && length(dataCell)>=lastX
        offset = 2;
    else
        offset = 1;
    end
    
    try %test if condition can be parsed
        parsedCond = parseCondAM(condStrings{i}); %try parsing the condition
    catch err
        if ~get(guiObjects.suppressWarn,'Value')
            errordlg(['Condition ',num2str(vals(i)),' String Parse Error: ',err.message]);
        end
        set(guiObjects.condCheck(vals(i)),'Value',0);
        noTrials(i) = 1;
        continue;
    end
    
    try %test if parsed condition contains a parameter present
        findTrials(dataCell,condStrings{i});
    catch err
        if ~get(guiObjects.suppressWarn,'Value')
            errordlg(['Condition ',num2str(vals(i)),' Parameter Error: ',err.message]);
        end
        set(guiObjects.condCheck(vals(i)),'Value',0);
        noTrials(i) = 1;
        continue;
    end
    
    %get trial range
    trialRange = get(guiObjects.condRange(vals(i)),'String');
    if isempty(trialRange) %if empty
        trialRange = '1:end';
        set(guiObjects.condRange(vals(i)),'String',':');
    end
    if strcmp(trialRange,':') %if colon
        trialRange = '1:end';
    end
    if trialRange(end) == '=' %if last value of trial range is equal sign
        matchFlag = true;
        trialRange = trialRange(1:end-1);
    else
        matchFlag = false;
    end
    if strcmp(trialRange(1),'-') %if first value is negative
        if ~isempty(regexp(trialRange,':end','ONCE')) %if end is present
            trialRange = ['end',trialRange]; %add end to beginning (convert -10:end to end-10 to end)
        else
            val = str2double(trialRange(2:end))-1;
            trialRange = ['end-',num2str(val),':end'];
        end
    end
    if isstrprop(trialRange(1),'digit') && isempty(strfind(trialRange,':'))...
            && isstrprop(trialRange(end),'digit')%if first value is a digit and no colon present
        trialRange = [trialRange,':end'];
    end
    
    
    %filter trials
    if isempty(condStrings{i}) && ~matchFlag
        eval(['dataCellSub{i} = dataCell(',trialRange,');']);
        eval(['dataCellSubInd{i} = dataCell(',trialRange,');']);
    elseif isempty(condStrings{i}) && matchFlag
        if ~get(guiObjects.suppressWarn,'Value')
            errordlg(['Condition ',num2str(vals(i)),' Cannot Use Equal Sign with empty condition text Error: ',err.message]);
        end
        set(guiObjects.condCheck(vals(i)),'Value',0);
        noTrials(i) = 1;
        continue;
    elseif ~isempty(condStrings{i}) && matchFlag 
        try
            tempDataSub = getTrials(dataCell,condStrings{i});
            tempInd = findTrials(dataCell,condStrings{i});
            eval(['dataCellSub{i} = tempDataSub(',trialRange,');']);
            dataCellSubInd{i} = find(tempInd == 1,val,'last');
        catch err
            if ~get(guiObjects.suppressWarn,'Value')
            	errordlg(['Condition ',num2str(vals(i)),' Range Error: ',err.message]);
            end
            set(guiObjects.condCheck(vals(i)),'Value',0);
            noTrials(i) = 1;
            continue;
        end
    elseif ~isempty(condStrings{i}) && ~matchFlag
        try
            eval(['dataCellSub{i} = getTrials(dataCell(',trialRange,'),condStrings{i});']);
            eval(['dataCellSubInd{i} = findTrials(dataCell(',trialRange,'),condStrings{i});']);
        catch err
            if ~get(guiObjects.suppressWarn,'Value')
            	errordlg(['Condition ',num2str(vals(i)),' Range Error: ',err.message]);
            end
            set(guiObjects.condCheck(vals(i)),'Value',0);
            noTrials(i) = 1;
            continue;
        end
    end
    
    %check if any trials meet condition
    if isempty(dataCellSub{i})
        if ~get(guiObjects.suppressWarn,'Value')
            warndlg(['No Trials Meet Condition ',num2str(vals(i))]);
            set(guiObjects.condCheck(vals(i)),'Value',0);
        end
        noTrials(i) = 1;
        continue;
    end
    
    %process subset of data
    procDataSub(i) = processDataCell(data,dataCellSub{i},true);
    
    %convert to table
    table{i+offset} = convertToTableCell(procDataSub(i));
    table{i+offset}.vals = vals;
    
    %update modData
    set(guiObjects.modData,'String',...
        [get(guiObjects.modData,'String');['Condition ',num2str(vals(i))]]);
    
end

if all(noTrials) %in case none of the trials meet the conditions
    updateTableCell(table,guiObjects);
    set(guiObjects.modData,'UserData',modDataStore,'Value',1);
    set(guiObjects.figHandle,'UserData',guiObjects);
    return; %return out of the function
end

%update condition data to mod and save
modDataStore.datasetInd.condition = dataCellSubInd;
modDataStore.datasets.condition = dataCellSub;
modDataStore.proc.condition = procDataSub;
set(guiObjects.modData,'UserData',modDataStore);

%update table
updateTableCell(table,guiObjects);

%save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);

end