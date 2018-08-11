% 
% clear all
% load('Engagement_2014_10_20_PM2_3.mat')

% markNumbers = zeros(length(FileStruct.mrkTime), 1);
% for i_elements = 1:length(markNumbers)
%     if strcmp(FileStruct.mrkTime(i_elements), 'solo_1')
%         markNumbers(i_elements) = 1;
%     elseif strcmp(FileStruct.mrkTime(i_elements), 'duo_1')
%         markNumbers(i_elements) = 1;
%     elseif strcmp(FileStruct.mrkTime(i_elements), 'solo_2')
%         markNumbers(i_elements) = 1;
%     elseif strcmp(FileStruct.mrkTime(i_elements), 'duo_2')
%         markNumbers(i_elements) = 1; 
%     end
% end

% markNumbers = markNumbers*.2;

% Values = FileStruct.data(:,2,:);
% Values = squeeze(Values); % e.g. 430x8

% TimeCentiSec = (1:length(Values));
% TimeSec = TimeCentiSec./10;
% TimeMin = TimeSec./60;
TimeMin = TimeMin + 9;

figure('units', 'normalized', 'position', [0 0 .9 .7]);
hold on
h1 = plot(TimeMin, Values(:,1), 'Color', [0 1 0]);
hold on
h2 = plot(TimeMin, Values(:,2), 'Color', [1 0 1]);
hold on
h3 = plot(TimeMin, Values(:,3), 'Color', [0 1 1]);
hold on
h4 = plot(TimeMin, Values(:,4), 'Color', [1 0 0]);
hold on
h5 = plot(TimeMin, Values(:,5), 'Color', [.2 0.6 1]);
hold on
h6 = plot(TimeMin, Values(:,6), 'Color', [1 .2 .6]);
hold on
h7 = plot(TimeMin, markNumbers);

% Y axis
%set(gca,'ylim',[10 25]) % change y-axis

% X axis
% put the xticks every 1 min
% 
% part1 = 0:600:length(TimeCentiSec);
% 
xAxis = floor(TimeMin(1:600:end));

set(gca,'XTick',xAxis)

%xAxis = num2cell(xAxis);
%tickStep = 599;
%xTickLabels = cell(1,numel(xAxis));  % Empty cell array the same length as xAxis
%xTickLabels(1:tickStep:numel(xAxis)) = xAxis(1:tickStep:numel(xAxis)); % Fills in only the values you want
%set(gca,'xticklabel',xTickLabels);   % Update the tick labels
%set(gca,'XTick',TimeSec)
%xticklabel = get(gca,'xticklabel'); % I get the variable xticklabel
%TimeMin
%xticklabel = xticklabel/.60;
%set(gca,'XTickLabel',sprintf('%2.1f|',xticklabel))
%set(gca,'xticklabel',xticklabel)

% code to change the x-axis label
xticklabel=cellstr(get(gca,'xticklabel')); % I get the variable xticklabel

%xticklabel{str2double(xticklabel)==200}= char'stim'; % I look for a number of interest and change the name


%set(gca,'xticklabel',xticklabel) % I put it back as xticklabel

