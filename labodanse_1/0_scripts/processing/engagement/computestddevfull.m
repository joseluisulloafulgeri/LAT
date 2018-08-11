function computestddevfull()
% compute_std_dev_full.m
% compute a metric to study similarity (based in mean and 2nd-SD of the SD) across subjects,
% the metric is based on the full experiment,
% plot figures for each dance type and session,
% should be launched in folder with structures (with markers and processed)

% created: by JLUF 07/01/2015
% last update: 15/01/2015

% variables of interest
markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
dataType = {'x' 'y'};

% find the names of the structures
files = dir('*.mat');
filesNames = {files.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...

% computing the metric
% getting the data
engValuesByType = cell(1, length(dataType));
for iDataType = 1:length(dataType)
    engValuesAll = [];
    for iFiles = 1:length(filesNames)
        load(filesNames{iFiles});
        engValuesData = squeeze(FileStruct.data(:,iDataType,:));
        engValuesData = reshape(engValuesData, 1, []);
        engValuesData(isnan(engValuesData)) = [];
        engValuesAll = [engValuesAll engValuesData];
    end
    engValuesByType{iDataType} = engValuesAll;
end

% computing the values of mean and SD
thresholdValueNoType = ones(1, length(dataType));
for iDataType = 1:length(dataType)
    secondStdDevNo = std(engValuesByType{iDataType});
    meanStdDevNo = mean(engValuesByType{iDataType});
    thresholdValueNoType(1, iDataType) =  meanStdDevNo - 0.5*secondStdDevNo;      
end

for iFiles = 1:length(filesNames)
    
    % load structures
    load(filesNames{iFiles});
    
    for iDanceType = 1:length(markersOfInterest)
        
        % set the values of interest according to the dance type
        indexMarkersLogic = ismember(FileStruct.marker_tab, markersOfInterest{iDanceType});
        
        for iDataType = 1:length(dataType)
    
            % set the type of value and get the engagement data
            engValues = FileStruct.data(indexMarkersLogic,iDataType,:);
            engValues = squeeze(engValues);
            
            % calculate the standard deviation and mean timecourses
            stdDevTimeCourse = std(engValues, 0, 2); % std dev along the second dimension
            meanTimeCourse = mean(engValues, 2); % mean along the second dimension
            thresholdValueNo = thresholdValueNoType(1, iDataType);
            
            % plot
            session = iFiles;
            outputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/engagement_std_dev_full';
            inputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/engagement/engagement_v3';
            plot_std_dev(markersOfInterest{iDanceType}, dataType{iDataType}, engValues, meanTimeCourse, stdDevTimeCourse, thresholdValueNo, ...
                session, inputFolder, outputFolder)
            
        end
    end
end

% END