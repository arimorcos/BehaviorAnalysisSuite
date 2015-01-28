function strucTree_CALLBACK(src,evnt,dataCell)
%strucTree_CALLBACK.m Creates figure with structure tree displayed 
%
%function to create figure and display structure of data contained within
%dataCell
%
%ASM 9/19/12

%generate figure
strucFig = figure('Name','Maze Key','NumberTitle','Off','MenuBar','none','Color',[1 1 1]);
screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(2,:);
else
    scrn = screens(1,:);
end
set(strucFig,'OuterPosition',[scrn(1)+0.5*(scrn(3)-scrn(1)) 0.2*(scrn(4)-scrn(2))...
    0.3*(scrn(3)-scrn(1)) 0.6*(scrn(4)-scrn(2))]); %set position

%create strucuture tree
createStrucTree(dataCell{1});

end