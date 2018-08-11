
markNumbers = zeros(length(FileStruct.mrkTime), 1);
for i_elements = 1:length(markNumbers)
    if strcmp(FileStruct.mrkTime(i_elements), 'solo_1')
        markNumbers(i_elements) = 1;
    elseif strcmp(FileStruct.mrkTime(i_elements), 'duo_1')
        markNumbers(i_elements) = 2;
    elseif strcmp(FileStruct.mrkTime(i_elements), 'solo_2')
        markNumbers(i_elements) = 3;
    elseif strcmp(FileStruct.mrkTime(i_elements), 'duo_2')
        markNumbers(i_elements) = 4; 
    end
end

markNumbers = markNumbers*250;

Values = FileStruct.data(:,2,:);
Values = squeeze(Values); % e.g. 430x8

TimeCentiSec = (1:length(Values))/10;
TimeSec = TimeCentiSec(1:10:end);
TimeMin = TimeSec./60;

figure('units', 'normalized', 'position', [0 0 .9 .7]);
hold on
%set(gca,'ylim',[10 25]) % change y-axis

xAxis = TimeCentiSec/60;
%xAxis = floor(xAxis);
tickStep = 599;
xTickLabels = zeros(1,numel(xAxis));  % Empty cell array the same length as xAxis
xTickLabels(1:tickStep:numel(xAxis)) = xAxis(1:tickStep:numel(xAxis));
                                     % Fills in only the values you want
set(gca,'XTickLabel',xTickLabels);   % Update the tick labels

%set(gca,'XTick',TimeSec)
%xticklabel = get(gca,'xticklabel'); % I get the variable xticklabel
%TimeMin

%xticklabel = xticklabel/.60;
%set(gca,'XTickLabel',sprintf('%2.1f|',xticklabel))
%set(gca,'xticklabel',xticklabel)

h1 = plot(TimeCentiSec, Values(:,1), 'Color', [0 1 0]);
hold on
h2 = plot(TimeCentiSec, Values(:,2), 'Color', [1 0 1]);
hold on
h3 = plot(TimeCentiSec, Values(:,3), 'Color', [0 1 1]);
hold on
h4 = plot(TimeCentiSec, Values(:,4), 'Color', [1 0 0]);
hold on
h5 = plot(TimeCentiSec, Values(:,5), 'Color', [.2 0.6 1]);
hold on
h6 = plot(TimeCentiSec, Values(:,6), 'Color', [1 .2 .6]);
hold on
plot(TimeCentiSec, markNumbers, 'Color', [0 0 0]);
