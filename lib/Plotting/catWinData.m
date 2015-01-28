function [catWinData] = catWinData(winData)
%catWinData.m Function to concatenate each element of the winData cell
%together
%
%ASM 9/27/12

fields = fieldnames(winData{1}); %get all the fieldnames 
fields = fields(cellfun(@(x) ~strcmp(x,'totTime'),fields)); %remove totTime
fields = fields(cellfun(@(x) ~strcmp(x,'names'),fields)); %remove names
fields = fields(cellfun(@(x) ~strcmp(x,'legNames'),fields)); %remove names

catWinData = winData{1};

for i=2:length(winData)
    for j=1:length(fields)
        catWinData.(fields{j}) = cat(2,catWinData.(fields{j}),winData{i}.(fields{j}));
    end
end

end