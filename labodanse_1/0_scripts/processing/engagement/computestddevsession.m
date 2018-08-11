function computestddevsession()
% compute_std_dev_session.m
% compute a metric to study similarity (based in mean and 2nd-SD of the SD) across subjects,
% the metric is based on each session,
% plot figures for each session,
% should be launched in folder with structures (with markers and processed)

% created: by JLUF 08/01/2015
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
    
    % for iDataType = 1:length(dataType)
    for iDataType = 2
        
        % set the type of value and get the engagement data
        engValues = FileStruct.data(:,iDataType,:);
        engValues = squeeze(engValues);
        
        % calculate the standard deviation and mean timecourses
        stdDevTimeCourse = std(engValues, 0, 2); % std dev along the second dimension
        %meanTimeCourse = mean(engValues, 2); % mean along the second dimension
        
        % get ride of NaN values
        stdDevTimeCourseCleaned = stdDevTimeCourse;
        stdDevTimeCourseCleaned(isnan(stdDevTimeCourseCleaned)) = [];
        
        secondStdDevNo = std(stdDevTimeCourseCleaned);
        meanStdDevNo = mean(stdDevTimeCourseCleaned);
        thresholdValueNo =  meanStdDevNo - 0.5*secondStdDevNo;
        
%         % plot
%         session = iFiles;
%         outputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/test_std2';
%         inputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/engagement/engagement_3';
%         plotstddev(2, [], dataType{iDataType}, engValues, meanTimeCourse, stdDevTimeCourse, thresholdValueNo, ...
%             session, inputFolder, outputFolder)
        
        for iDanceType = 1:length(markersOfInterest)
            
            % set the values of interest according to the dance type
            indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{iDanceType});
            
            % set the type of value and get the engagement data
            engValues = FileStruct.data(indexMarkersLogic,iDataType,:);
            engValues = squeeze(engValues);
            
            % calculate the standard deviation and mean timecourses
            stdDevTimeCourse = std(engValues, 0, 2); % std dev along the second dimension
            meanTimeCourse = mean(engValues, 2); % mean along the second dimension
            
            % plot
            session = iFiles;
            outputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/test_session';
            inputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/engagement/engagement_3';
            plotstddev(1, markersOfInterest{iDanceType}, dataType{iDataType}, engValues, meanTimeCourse, stdDevTimeCourse, thresholdValueNo, ...
                session, inputFolder, outputFolder)
        end
        
        
    end
end

% END