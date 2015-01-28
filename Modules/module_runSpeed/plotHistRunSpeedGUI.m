%plotHistRunSpeedGUI.m

%function to plot histograms for run and turn speed calculations

function plotHistRunSpeedGUI(runData,turnData)    
    
    subplot('Position',[0.13 0.6225 0.3347 0.3225]);
    hist(runData.secs,50);
    xlim([0 20]);
    title('Run Speed 25% to 75%')
    ylabel('Number');
    xlabel('Time (s)');
    
    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(runData.secs,50);
    
    subplot('Position',[0.5703 0.6225 0.3347 0.3225]);
    hist(turnData.secs,50);
    xlim([0 20]);
    title('Turn Speed Overall')
    ylabel('Number');
    xlabel('Time (s)');
    
    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(turnData.secs,50);
    
    subplot('Position',[0.13 0.17 0.3347 0.3225]);
    hist(turnData.secsLeft,50);
    xlim([0 20]);
    title('Turn Speed Left')
    ylabel('Number');
    xlabel('Time (s)');
    
    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(turnData.secsLeft,50);
    
    subplot('Position',[0.5703 0.17 0.3347 0.3225]);
    hist(turnData.secsRight,50);
    xlim([0 20]);
    title('Turn Speed Right')
    ylabel('Number');
    xlabel('Time (s)');

    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(turnData.secsRight,50);
    
end