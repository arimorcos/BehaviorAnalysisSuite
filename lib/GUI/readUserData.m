function [userData] = readUserData(filePath)
%readUserData.m Function to read userdata file
%
%This function reads the userData.txt file and outputs the results as a
%structure to be used by the behavioral analysis suite.

fid = fopen(filePath);

%read section 1-5
cellInfo = textscan(fid,'%s',7,'CommentStyle','%','delimiter','\n');
% cellInfo{1} = cellInfo{1}(~cellfun(@isempty,cellInfo{1}));

userData.path = cellInfo{1}{1};
userData.initials = cellInfo{1}{2};
userData.tempName = cellInfo{1}{3};
userData.tempDir = cellInfo{1}{4};
userData.folders = {cellInfo{1}{5},cellInfo{1}{6}};

if sum(cell2mat(cellfun(@(x) strcmp(x,'END'),cellInfo{1}(1:6),'UniformOutput',false))) ~= 0 
    error('Missing an argument in sections 1-5 of the userData.txt file');
elseif sum(cell2mat(cellfun(@(x) strcmp(x,'END'),cellInfo,'UniformOutput',false))) == 0
    error('Too many arguments in sections 1-5 of the userData.txt file');    
end

%read section 6: sliding window flags
endFlag = false;
userData.flags = {};
while ~endFlag
    cellInfo = textscan(fid,'%s',1,'CommentStyle','%','delimiter','\n');
    if strcmp(cellInfo{1}{1},'END')
        endFlag = true;
    else
        userData.flags = cat(2,userData.flags,cellInfo{1}{1});
    end
end

%read section 7: sliding window variables
endFlag = false;
ind = 1;
while ~endFlag
    cellInfo = textscan(fid,'%s',1,'CommentStyle','%','delimiter','\n');
    if strcmp(cellInfo{1}{1},'END')
        endFlag = true;
    else
        userData.winVars{ind} = {};
        sepParam = textscan(cellInfo{1}{1},'%s',12,'delimiter','|','CollectOutput',true);
        if length(sepParam{1}) < 3
            error(['Input ',num2str(ind),' in section 7 of the user data file has too few arguments. Must have at least 3.']);
        end
        for i=1:length(sepParam{1})
            userData.winVars{ind} = cat(2,userData.winVars{ind},sepParam{1}{i});
        end
        userData.winVars{ind}{2} = str2double(userData.winVars{ind}{2});
    end
    ind = ind + 1;
end

%read section 8: sliding window percentages
endFlag = false;
ind = 1;
userData.percVarNames = {};
while ~endFlag
    cellInfo = textscan(fid,'%s',1,'CommentStyle','%','delimiter','\n');
    if strcmp(cellInfo{1}{1},'END')
        endFlag = true;
    else
        userData.percVars{ind} = {};
        sepParam = textscan(cellInfo{1}{1},'%s',12,'delimiter','|','CollectOutput',true);
        if length(sepParam{1}) < 5
            error(['Input ',num2str(ind),' in section 8 of the user data file has too few arguments. Must have 5.']);
        elseif length(sepParam{1}) > 5
            error(['Input ',num2str(ind),' in section 8 of the user data file has too many arguments. Must have 5.']);
        end
        for i=2:length(sepParam{1})
            userData.percVars{ind} = cat(2,userData.percVars{ind},sepParam{1}{i});
        end
        userData.percVars{ind}{1} = str2double(userData.percVars{ind}{1});
        userData.percVarNames = [userData.percVarNames,sepParam{1}{1}];
    end
    ind = ind + 1;
end

fclose(fid);
end