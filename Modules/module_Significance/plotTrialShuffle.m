function [arrow] = plotTrialShuffle(percCorr,dist,alphaThresh,nBins)
%PLOTTRIALSHUFFLE plots histogram of shuffled trial data, with actual
%result marked and alpha marked 
%
%percCorr - actual percent correct
%dist - distribution of shuffled percent corrects
%alpha - p value of significance 
%nBins for histogram

if nargin < 4; nBins = size(dist,2)/500; end
if nargin < 3; alphaThresh = 0.05; end

%plot histogram
[counts,xCounts] = hist(dist,nBins); %compute histogram
h = bar(xCounts,counts); %draw histogram
xlabel('Percent Correct');
ylabel('Count');
title('Shuffled Behavioral Data');

%calc and draw alphaThresh
sortDist = sort(dist);
alphaVal = sortDist(round(size(dist,2)*(1-alphaThresh))); %find value in dist that corresponds to alpha
line([alphaVal alphaVal],[0 0.95*max(counts)],'LineStyle','--','Color','k'); %draw alpha thresh line
text(alphaVal,0.96*max(counts),['alphaThresh = ',num2str(alphaThresh)],...
    'HorizontalAlignment','Left','VerticalAlignment','Bottom'); %label alpha thresh line
set(gca,'YLim',[0 1.05*max(counts)]); %set ylim
xlim([0 1]);

%calc alpha and draw actual percCorr
pVal = sum(dist >= percCorr)/size(dist,2);
if pVal == 0 
    pVal = 1/size(dist,2);
end
xarrow = [0.8 percCorr];
yarrow = [0.5 0.3];
arrow = annotation('textarrow',xarrow,yarrow,'String',['p < ',num2str(pVal)]);
if pVal < alphaThresh
    set(arrow,'Color',[0 .3922 0]);
elseif pVal < 2*alphaThresh && pVal >= alphaThresh
    set(arrow,'Color',[1 .5 0]);
else
    set(arrow,'Color','r');
end

end

