function computestddev()
% compute_std_dev.m
% compute a metric to study similarity (based in mean and 2nd-SD of the SD) across subjects,
% the metric is based on each dance type and session,
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

for iFiles = 1:length(filesNames)
    
    % load structures
    load(filesNames{iFiles});
    
    for iDanceType = 1:length(markersOfInterest)
        
        % set the values of interest according to the dance type
        indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{iDanceType});
        
        %for iDataType = 1:length(dataType)
        for iDataType = 2
    
            % set the type of value and get the engagement data
            engValues = FileStruct.data(indexMarkersLogic,iDataType,:);
            engValues = squeeze(engValues);
            
            % calculate the standard deviation and mean timecourses
            stdDevTimeCourse = nanstd(engValues, 0, 2); % std dev along the second dimension
            meanTimeCourse = nanmean(engValues, 2); % mean along the second dimension
            secondStdDevNo = nanstd(stdDevTimeCourse);
            meanStdDevNo = mean(stdDevTimeCourse);
            thresholdValueNo =  meanStdDevNo - 0.5*secondStdDevNo;
            
            % plot
            session = iFiles;
            outputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/engagement_std_dev_derivraw';
            inputFolder = pwd;
            plotstddev(1, markersOfInterest{iDanceType}, dataType{iDataType}, engValues, meanTimeCourse, stdDevTimeCourse, thresholdValueNo, ...
                session, inputFolder, outputFolder)
            
        end
    end
end

% END