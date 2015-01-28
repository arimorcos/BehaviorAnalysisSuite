function createStrucTree(struc, showVals, ind)
%createStrucTree.m This function plots a pretty structure tree allowing one
%to visualize the format of the data

if nargin < 3; ind = 1; end 
if nargin < 2; showVals = false; end

if ~isstruct(struc)
    error('Not a structure');
end

nodes = 0;

fields = fieldnames(struc);
nodes = [nodes ones(1,length(fields))];
for i=1:length(fields) %get number of subfields in each field of struc
    if isstruct(struc.(fields{i}))
        subfields{i} = fieldnames(struc.(fields{i}));
        if showVals
            for j=1:length(subfields{i})
                subfieldVals{i}{j} = [subfields{i}{j},' = '];
                value = struc.(fields{i}).(subfields{i}{j});
                if ~isstr(value) %convert to str if not string
                    if iscell(value) || isstruct(value) 
                        value = 'Cannot Parse';
                    else
                        value = num2str(value);
                    end
                end
                if length(value) > 40 %if more than 40 characters 
                    value = 'Value too long';
                end
                if size(value,1) > 1 && size(value,2) > 1 
                    value = 'Cannot parse multidimensional array';
                elseif size(value,1) > 1 
                    value = value';
                end
                subfieldVals{i}{j} = [subfieldVals{i}{j},value];
            end
        end
    else
        subfields{i} = [];
    end
    nodes = [nodes 1+i*ones(1,length(subfields{i}))];
    for j=1:length(subfields{i})
        if isstruct(struc.(fields{i}).(subfields{i}{j}))
            warning('Fourth Level and Beyond Not Shown');
        end
    end
end

labels = [['data{',num2str(ind),'}'], fields'];
if showVals
    for i=1:length(subfieldVals)
        labels = cat(2,labels,subfieldVals{i});
    end
else
    for i=1:length(subfields)
        labels = cat(2,labels,subfields{i}');
    end
end

myTreePlot(nodes,labels);

function myTreePlot(p,labels)
%TREEPLOT Plot picture of tree.
%   TREEPLOT(p) plots a picture of a tree given a row vector of
%   parent pointers, with p(i) == 0 for a root and labels on each node.
%
%   Example:
%      myTreeplot([2 4 2 0 6 4 6],{'i' 'like' 'labels' 'on' 'pretty' 'trees' '.'})
%   returns a binary tree with labels.
%
%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 5.12.4.2 $  $Date: 2004/06/25 18:52:28 $
%   Modified by Richard @ Socher . org to display text labels

[y,x,h]=treelayout(p,1:length(p)); % RS: The second argument (1:length(p)) ensures that the leaf nodes are printed in their original order in the parent vector
f = find(p~=0);
pp = p(f);
x = 1 - x;
y = 1 - y;
x(2:end) = x(2:end)+.1;
x = x + .5;
x(p>1) = x(p>1);
X = [x(f); x(pp); NaN(size(f))];
Y = [y(f); y(pp); NaN(size(f))];
X = X(:);
Y = Y(:);

subplot('Position',[0.05 0.025 0.9 0.95]);
plot (x, y, 'bo', X, Y, 'b-','LineWidth',2);
ylim([0 1]);

x(p>1) = x(p>1)+.015;
x(p<=1) = x(p<=1) - .03;
y(p<=1) = y(p<=1) + .03;
for l=1:length(labels)
    text(x(l),y(l),labels{l},'Interpreter','none')
end
% set(gca,'XTickLabel','','YTickLabel','')
set(gca,'Visible','off');