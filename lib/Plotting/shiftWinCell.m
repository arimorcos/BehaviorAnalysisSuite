function [winData] = shiftWinCell(winData)
%shiftWinCell.m Shift window data
%
%This function shifts all fields in winData by the window size, creating an
%empty space the size of the window at the beginning of the arrays 
%
%ASM 9/19/12

fields = fieldnames(winData); %get all the fieldnames 
fields = fields(cellfun(@(x) ~strcmp(x,'totTime'),fields)); %remove totTime
fields = fields(cellfun(@(x) ~strcmp(x,'names'),fields)); %remove names
fields = fields(cellfun(@(x) ~strcmp(x,'legNames'),fields)); %remove names

%get shiftSize
shiftSize = winData.totTime - length(winData.(fields{1}));

for i=1:length(fields) %for each field
    winData.(fields{i})(end+1:end+shiftSize) = NaN; %add NaN
    winData.(fields{i}) = circshift(winData.(fields{i}),[0 shiftSize]); %perform circle shift
end