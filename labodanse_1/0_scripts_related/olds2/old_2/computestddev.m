function computestddev()
% computestddev.m
% script to compute the mean and 2nd standard deviation of the standard deviation across subjects
% should be launched in folder with structures (with markers and processed)

% created: by JLUF 07/01/2015
% last update: 08/01/2015

close all
clear all

%% 0. variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};

%% 1. find the names of the structures

% 1. get names of current directory
files = dir('*.mat');
filesNames = {files.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...

for iFiles = 1:length(filesNames)
    
    %% 2. load structures
    
    load(filesNames{iFiles});
    
    %% 3. get the engagement data according to the markers
    
    engAllValues = cell(1, length(markersOfInterest)); % initialize
    for iDanceType = 1:length(markersOfInterest)
        indexMarkersLogic = ismember(fileStruct.marker_tab, markersOfInterest{iDanceType});
        engAllValues{iDanceType} = fileStruct.data(indexMarkersLogic,:,:);
    end
    
    for iDanceType = 1:length(engAllValues)
        
        %% 4. calculate the standard deviation and mean timecourses
        
        engValuesByDance = engAllValues{iDanceType};
        engValuesByDance = squeeze(engValuesByDance(:,2,:));
        stdDevTimeCourse = std(engValuesByDance, 0, 2); % std dev along the second dimension
        meanTimeCourse = mean(engValuesByDance, 2); % mean along the second dimension
        
        secondStdDevNo = std(stdDevTimeCourse);
        meanStdDevNo = mean(stdDevTimeCourse);
        thresholdValueNo =  meanStdDevNo - 0.5*secondStdDevNo;
        
        %% 5. plot
        
        session = iFiles;
        outputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/engagement_std_dev';
        inputFolder = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/engagement/engagement_v3';
        plotstddev(markersOfInterest{iDanceType}, engValuesByDance, meanTimeCourse, stdDevTimeCourse, thresholdValueNo, session, inputFolder, outputFolder)
        
    end
end

% END