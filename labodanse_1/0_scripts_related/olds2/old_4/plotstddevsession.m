function plotstddevsession(dataType, engValues, meanTimeCourse, stdDevTimeCourse, thresholdValueNo, session, inputFolder, outputFolder)
% plotstddev.m
% script to plot the results of standard deviation and mean across subjects
% use: use in the function computestddev.m
% ouput: plot

% created: by JLUF 08/01/2015
% last update: 08/01/2015

% figure settings
set(gcf,'Visible','off');
figure('Units', 'pixels', 'Position', [200 200 1300 600], 'Name', 'all dances');

% plotting of individual Mean curves
plot(1:length(engValues), engValues, 'color',[0.8,0.8,0.8], 'lineWidth', 2);
hold on

% plotting of the grand Mean curve
h2 = plot(1:length(meanTimeCourse), meanTimeCourse, 'g', 'lineWidth', 3);
hold on

% plotting of the grand Standard Deviation curve
h3 = plot(1:length(stdDevTimeCourse), stdDevTimeCourse, 'r','lineWidth', 3);
hold on

% adding lines
plot(get(gca,'xlim'),[0 0],'k') % horizontal line at 0
h4 = plot(get(gca,'xlim'),[thresholdValueNo thresholdValueNo],'--r'); % horizontal line at the thresholdValueNo value

% plot settings
legend([h2 h3 h4],{'mean','standard deviation' 'threshold'}, 'FontSize', 10);
set(gca,'xlim',[1 length(engValues)], 'FontSize', 20) % change x-axis
%set(gca,'xlim',[-300 1000])  % change x-axis
xlabel('Time (compilated seconds)'), ylabel('Engagement level (z-score)', 'FontSize', 20)
title('Engagement timecourse', 'FontSize', 20)

% save
cd (outputFolder)
f = getframe(gcf); % capture the current window
nameFigure = sprintf('figureEng_session%d_%sdata.png', session, dataType);
imwrite(f.cdata, nameFigure);  % save the frame data
cd (inputFolder)

% END