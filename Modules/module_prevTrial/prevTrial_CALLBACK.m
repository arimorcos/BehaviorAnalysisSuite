function prevTrial_CALLBACK(src,evnt,dataCell)
%prevTrial_CALLBACK Callback for the previous trial effect module
%
%Opens up GUI to calculate and plot probability of turns toward left or
%white given previous x trials

%create gui
[prevGUI] = prevEffectGUI();

updatePrevEffectPlot(src,evnt,prevGUI,dataCell);

%set callbacks
set(prevGUI.winSize,'Callback',{@updatePrevEffectPlot,prevGUI,dataCell});
set(prevGUI.reward,'Callback',{@updatePrevEffectPlot,prevGUI,dataCell});