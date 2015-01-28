%updatePrevEffectPlot.m

%function to update previous effect plot

function updatePrevEffectPlot(src,evnt,prevGUI,dataCell)
    
    subplot('Position',[0.05 0.2 0.9 0.7]);
    cla reset;

    win = str2double(get(prevGUI.winSize,'String'));
    reward = get(prevGUI.reward,'Value');
    
    [meanLeft,meanWhite,stdLeft,stdWhite] = calcPrevTrial(dataCell,win,reward);
    
    %plot
    errorbar(0:0.2:0.8,meanLeft,stdLeft,'b-o','MarkerSize',10,'MarkerFaceColor','b');
    hold on;
    errorbar(0:0.2:0.8,meanWhite,stdWhite,'r-x','MarkerSize',10,'MarkerFaceColor','r');
    legend('Left','White');
    title(['Effect of Previous Trials on Turning: Window Size - ',num2str(win)]);
    if reward
        xlabel(['Probability of Previous ', num2str(win),' Rewarded Trials Being Left/White']);
    else
        xlabel(['Probability of Previous ', num2str(win),' Trials Being Left/White']);
    end
    ylabel('Proability of Turn on Test Trial Toward Left/White');
    xlim([0 1]);
    ylim([0 1]);
    
    axis square;
    
end