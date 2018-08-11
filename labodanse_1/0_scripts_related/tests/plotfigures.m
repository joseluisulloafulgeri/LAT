

%% Variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
namesMarkers = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};

%% Get the names of the structures

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
    
    dataType = FileStruct.dataList;
    
    for iDanceType = 1:length(markersOfInterest)
        
        % set the values of interest according to the dance type
        indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{iDanceType});
        
        for y_dataType = 1:length(dataType)
            
            Values = FileStruct.data(indexMarkersLogic,y_dataType,:);
            Values = squeeze(Values); % e.g. 430x8
            TimeMin = (1:length(Values))/60;
            
            figure('units', 'normalized', 'position', [0 0 .9 .7]);
            set(gcf,'Name', char(markersOfInterest(iDanceType)),'Number','off') % set name on the figure
            
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
            h7 = plot(TimeMin, Values(:,7), 'Color', [1 .6 .2]);
            hold on
            h8 = plot(TimeMin, Values(:,8), 'Color',[0 0 1]);
            hold on
            plot(get(gca,'xlim'),[0 0], 'Color', [0.5 0.5 0.5]) % horizontal line
            hold on
            axis([ 0 max(TimeMin) -5 5 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
            
            % plot settings
            legend([h1 h2 h3 h4 h5 h6 h7 h8],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8'}, 'FontSize', 12);
            set(legend,'color','none', 'location', 'best'); % make legend background transparent
            xlabel('Time (minutes)', 'FontSize', 20), ylabel([dataType{y_dataType} ' (z-score)'], 'FontSize', 20)
            title(horzcat(dataType{y_dataType}, ' responses during ', namesMarkers{iDanceType}), 'FontSize', 20)
            
        end
    end
end

% END
