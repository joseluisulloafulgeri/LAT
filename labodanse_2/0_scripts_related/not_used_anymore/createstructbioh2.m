
% createstructurebioh.m
% USE: extract bioharness data, synchronize across subjects, and create structure
% INPUT: bioharness csv files (in 1_data_organized/)
% OUPUT: structures (in a folder within 2_data_analysis)
% ROOTS: folder containing bioharness data (data is embedded in a hierarchy of folders)

% so far, to run in 1_data_organized/

% remember the data is organized as follows:
% 1_data_organized/2014_10_20_AM/2_bioh_capteurs/A01_846/2014_10_20-09_41_07/2014_10_20-09_41_07_Summary.csv

% created: YF 06/10/2014
% last update: JLUF 26/01/2015

%% Checking time
tStart = tic;

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_1

%% Getting the directory file names

% get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM' '2014_10_20_PM1'...

%% Selecting data type

% 6_subj_online is the engagement data
directoryNames2 = '2_bioh_capteurs';

for i_session = 1:length(directoryNames) % loop for each session
    
    %% Getting the names of each subject-folder
    
    path3 = fullfile(directoryNames{i_session}, directoryNames2); % generate the path, e.g. 2014_10_20_PM1/6_subj_online/
    files3 = dir(path3);
    directoryNames3 = {files3([files3.isdir]).name};
    directoryNames3 = directoryNames3(~ismember(directoryNames3,{'.','..'})); % e.g. 'A01_846' 'A02_749' ...

    % initialization of some variables
    dataTimeSecondsMat = cell(1, length(directoryNames3));
    timelineMin = zeros(1, length(directoryNames3));
    timelineMax = zeros(1, length(directoryNames3));
    dataFirstStep = cell(1, length(directoryNames3));
    sourcePaths = cell(1, length(directoryNames3));
    structureComments = {};

    for i_subject = 1:length(directoryNames3) % loop for each subject
        
        %% Getting the date of each subject-folder
        
        path4 = fullfile(path3, directoryNames3{i_subject}); %
        files4 = dir (path4);
        directoryNames4 = {files4([files4.isdir]).name};
        directoryNames4 = directoryNames4(~ismember(directoryNames4,{'.','..'}));
        
        %% Getting the names of each data file of interest
        
        path5 = fullfile(path4, directoryNames4);
        files5 = dir (char(path5));
        directoryNames5 = {files5.name};
        folderSelectionLogic5 = ~cellfun(@isempty,regexp(directoryNames5, 'Summary.csv')); % keep .csv files
        directorySelection = directoryNames5(folderSelectionLogic5);
        
        path6 = fullfile(path5, directorySelection);
        sourcePaths{i_subject} = char(path6);
        
        %% Importing data
        
        % import dataset
        importedData = importdata(char(path6));
        
        % the 'importdata' function generates a structure with 2 fields:
        % one associated with numerical data, and another with text,
        % imported_data.textdata give us the labels, for us 1st column is time
        % imported_data.data give us the numerical data,
        % attention! in our case all data is shifted one colum to the left
        % because the timeline is not included here, see below
        
        %% Gathering time info and setting timeline
        
        timeData = importedData.textdata(2:end,1); % from 2 to exclude the label / 1 because first column is time,
        
        % splitting the values of date and time
        fullDate = cellfun(@strsplit, timeData, 'UniformOutput', false);
        fullDate = fullDate';
        
        % segmenting the time section in hours, minutes and seconds
        segmentedDate = cellfun (@(x) strsplit (x{1,2}, ':'), fullDate, 'UniformOutput', false);
        
        % generating the definitive timeline
        hoursData = cellfun (@(x) str2double(x{1}), segmentedDate, 'UniformOutput', false);
        hoursData = (cell2mat(hoursData))*60*60;

        minutesData = cellfun (@(x) str2double(x{2}), segmentedDate, 'UniformOutput', false);
        minutesData = (cell2mat(minutesData))*60;

        secondsData = cellfun (@(x) str2double(x{3}), segmentedDate, 'UniformOutput', false);
        secondsData = cell2mat(secondsData);
        secondsData = floor(secondsData);
        
        % concatenation
        completeDataTimeSet = [hoursData; minutesData; secondsData];
        
        % summing, to generate compilated seconds,
        dataTimeSeconds = sum(completeDataTimeSet);
        
        % we save the timelines of each subject
        dataTimeSecondsMat{i_subject} = dataTimeSeconds;
        
        % we save the minimal timepoint of the timeline for each subject
        timelineMin(i_subject) = dataTimeSecondsMat{i_subject}(1);
        % we save the maximal timepoint of the timeline for each subject
        timelineMax(i_subject) = dataTimeSecondsMat{i_subject}(end);
        
        %% Gathering data
        
        dataOfInterest = {'HR','BR'}; % 'HR','BR','HRConfidence','HRV','CoreTemp'
        
        % we create a logic vector which indicate the index of the data we want to retrieve,
        indexSelection = ismember(importedData.textdata(1,:), dataOfInterest);
        indexSelection(1) = []; % textdata has no time column
        
        % get save the data in a cell array
        dataFirstStep{i_subject} = importedData.data(:, indexSelection);
        
    end % i_subject
    
    % across all subjects we find the minimal and maximal common timepoints,
    [commonMinTime, minTimeSubjectIndex] = max(timelineMin);
    [commonMaxTime, maxTimeSubjectIndex] = min(timelineMax);
    
    % for the data of each subject we select the dataset that lay between the common minimal and maximal datapoints
    minTimeIndex = zeros(1, length(directoryNames3));
    maxTimeIndex = minTimeIndex;
    commonTimepoints = minTimeIndex;
    
    for i_subjects = 1:length(directoryNames3)
        minTimeIndex(i_subjects) = find(dataTimeSecondsMat{i_subjects} >= commonMinTime, 1, 'first');
        maxTimeIndex(i_subjects) = find(dataTimeSecondsMat{i_subjects} <= commonMaxTime, 1, 'last');
        commonTimepoints(i_subjects) = maxTimeIndex(i_subjects) - minTimeIndex(i_subjects); % common timepoints should be equal,
    end
    
    % to check when launching the script 
    disp('Common time points across subjects');
    disp(commonTimepoints);   
    
    %% Include the limiting files in the field comments
    
    structureComments{1} = ['timeline minimum defined by ', directoryNames3{minTimeSubjectIndex}];
    structureComments{2} = ['timeline maximum defined by ', directoryNames3{maxTimeSubjectIndex}];

    minutesCommon1 = (commonMaxTime - commonMinTime)/60; % get the minutes,
    minutesCommon2 = floor(minutesCommon1); % get the minutes,
    secondsCommon = (minutesCommon1 -minutesCommon2)*60; % get the seconds,
    
    structureComments{3} = horzcat('length of the common session: ', num2str(minutesCommon2), 'min ', num2str(secondsCommon), 'sec');
    
    %% Selection of data with common datapoints
    
    lenghtData = min(commonTimepoints) - 1; % e.g. 11575 datapoints
    
    % here, a new dataset is created by looking at the original dataset but taking only those datapoints where we find a shared timeline,
    % e.g between the index 1 of the timeline that start the later, and the index 11577 of the timeline that finish earlier
    % i.e. 11576 common timepoints across all subjects
    
    selectedDataset = zeros(commonTimepoints(1), length(dataOfInterest), length(directoryNames3));
    for n_subject = 1:length(directoryNames3)
        selectedDataset(:,:,n_subject) = dataFirstStep{n_subject}(minTimeIndex(n_subject):minTimeIndex(n_subject) + lenghtData, :);
    end
    
    % -> data_second_step is a 3 (time, data_of_interest, subject) matrix
    
    %% Data start epoch

    newCompiledSecondsStart = dataTimeSecondsMat{1}(minTimeIndex(1));
    
    newEpochs = cell(1, length(selectedDataset)); counter = 0;
    for jNewDate = 1:length(selectedDataset)
        timeEpoch = newCompiledSecondsStart + counter;
        
        epochHours1 = timeEpoch/(60*60); % get the hours,
        epochHours2 = floor(epochHours1); % get the hours,
        
        epochMinutes1 = (epochHours1 - epochHours2)*60; % get the minutes,
        epochMinutes2 = floor(epochMinutes1); % get the minutes,
        
        epochSeconds1 = (epochMinutes1 - epochMinutes2)*60; % get the seconds,
        epochSeconds1 = round(epochSeconds1);
        
        newEpochs{jNewDate} = [num2str(epochHours2),':',num2str(epochMinutes2),':',num2str(epochSeconds1)];
        counter = counter + 1;
    end
    commonTimeline = newEpochs';
    
    compilatedSeconds = 0:(length(selectedDataset))-1;
    commonCompilatedSeconds = (bsxfun(@plus, compilatedSeconds, newCompiledSecondsStart))';
    
    %% Saving data
    
    % variables to save,
    samplingFrequency = 1;
    structureDataList =  dataOfInterest';
    structureSubjectList = directoryNames3';
    structureSources = sourcePaths';
    structureComments = structureComments';
    dataTypeName = directoryNames2(3:end);
    processingSteps = cellstr(['structure created on ', date, ' with createstructbioh.m']);   
    
    % name of the data-file
    fileName = sprintf('HRBR_%s', directoryNames{i_session}); % 'Bioharness_%s'
    
    % structure of the data
    FileStruct = struct( ...
        'name', fileName, ...
        'data', selectedDataset, ...
        'dataType', dataTypeName, ...
        'dataList', {structureDataList}, ...
        'subjectList', {structureSubjectList}, ...
        'source', {structureSources}, ...
        'samplingFrequency', samplingFrequency, ...  
        'commonSeconds', commonCompilatedSeconds, ...
        'humanReadableTimeline', {commonTimeline}, ...
        'processingSteps', {processingSteps}, ...          
        'comments', {structureComments});
    
    % change directory
    ouputFolder = sprintf('../2_data_analysis/bioharness/%s', destinyFolder);
    cd (ouputFolder)
    
    % save the data
    save (fileName, 'FileStruct')
    
    % change directory
    inputFolder = '../../../1_data_organized';
    cd (inputFolder)
    
end % i_Dir

% checking time
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));

% END