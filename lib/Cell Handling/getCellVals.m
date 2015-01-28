function [vals] = getCellVals(dataCell,condition,double)
%getCellVals.m Returns specified cell field values from cell of structures
%
%This function returns specific fields from cell of structures as
%determined by condition. The cell to work on is dataCell.
%
%This function can also cull data from multiple data sets provided they're
%in the format such that each cell contains an individual data set
%
%ASM 9/12 modified from tget.m ART

if nargin<3; double = true; end %return data as double by default

if isempty(dataCell)
    if double 
        vals = [];
    else
        vals = {};
    end
    return;
end

if iscell(dataCell{1}) %determine whether or not there are multiple data sets
    multiData = true;
    nSets = length(dataCell);
    vals = cell(1,nSets);
else
    multiData = false;
end

%create cellCondFun
eval(['cellCondFun = @(x) x.',condition,';']);

if multiData %if multiple data sets
    for i=1:nSets
        vals{i} = cellfun(cellCondFun,dataCell{i},'UniformOutput',false);
        if double
            vals{i} = cell2mat(vals{i});
        end
    end
else %single data set
    vals = cellfun(cellCondFun,dataCell,'UniformOutput',false);
    if double
        vals = cell2mat(vals);
    end
end


end




