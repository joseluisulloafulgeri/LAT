
% createstructurebioh2ecg_1.m
% adapted from createstructurebioh2ecg_3.m
% version for October 2014 data
% USE: extract bioharness data, synchronize across subjects, and create structure
% INPUT: bioharness .mat files (in 1_data_organized/)
% OUPUT: structures (in a folder within 2_data_analysis)
% ROOTS: folder containing bioharness data (data is embedded in a hierarchy of folders)

% so far, to run in /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/1_data_organized

% modfied from the original: JLUF 26/06/2015
% updates: JLUF 30/06/2015
% updates: JLUF 05/08/2015

%% Checking time
tStart = tic;

%% Defining the destiny folder 

inputFolder = pwd;
destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_1

%% Getting the directory file names

% get names of current directory
%files = dir('*05_14_B');
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2015_05_12_A'...

%% Selecting data type

% 6_subj_online is the engagement data
directoryNames2 = '2_bioh_capteurs';

for i_session = 1:length(directoryNames) % loop for each session
%for i_session = 4:4 % loop for each session

    pathFolder = fullfile(directoryNames(i_session), directoryNames2);
    cd (char(pathFolder))
    
    directory3 = dir('*ECG.mat');
    directoryNames3 = {directory3.name};
    
    % initialization of some variables
    dataTimeSecondsMat = cell(1, length(directoryNames3));
    timelineMin = zeros(1, length(directoryNames3));
    timelineMax = zeros(1, length(directoryNames3));
    dataFirstStep = cell(1, length(directoryNames3));
    sourcePaths = cell(1, length(directoryNames3));
    structureComments = {};

    for i_subject = 1:length(directoryNames3) % loop for each subject
        
        sourcePaths{i_subject} = char(pwd);
        %% Importing data
        load(directoryNames3{i_subject}) % as ECGfullData
        % there is always Breathing and ECG data (as separated .mat files)
        
        %% Gathering time info
        % we save the timelines of each subject
        dataTimeSecondsMat{i_subject} = ECGfullData(:,1);
        
        % we save the minimal timepoint of the timeline for each subject
        timelineMin(i_subject) = dataTimeSecondsMat{i_subject}(1);
        % we save the maximal timepoint of the timeline for each subject
        timelineMax(i_subject) = dataTimeSecondsMat{i_subject}(end);
        
        %% Gathering data
        dataOfInterest = {'ECG'};
        % get save the data in a cell array
        dataFirstStep{i_subject} = ECGfullData(:, 2);
        
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
    
    timeCommon1 = commonMaxTime - commonMinTime;
    %timeCommon1 = timeCommon1/25;
    hoursCommon1 = timeCommon1/3600; % get the hours   
    hoursCommon2 = floor(hoursCommon1); % get the hours,
    minutesCommon1 = (hoursCommon1 - hoursCommon2)*60; % get the minutes,
    minutesCommon2 = floor(minutesCommon1); % get the minutes,
    secondsCommon = (minutesCommon1 - minutesCommon2)*60; % get the seconds,

    structureComments{3} = horzcat('length of the common session: ', num2str(hoursCommon2), ' hours ',num2str(minutesCommon2), ' minutes ', num2str(secondsCommon), ' seconds');

    %% Selection of data with common datapoints
    
    lenghtData = min(commonTimepoints) - 1; % e.g. 11575 datapoints
    
    % here, a new dataset is created by looking at the original dataset but taking only those datapoints where we find a shared timeline,
    % e.g between the index 1 of the timeline that start the later, and the index 11577 of the timeline that finish earlier
    % i.e. 11576 common timepoints across all subjects
    
    selectedDataset = zeros(min(commonTimepoints), length(dataOfInterest), length(directoryNames3));
    for n_subject = 1:length(directoryNames3)
        selectedDataset(:,:,n_subject) = dataFirstStep{n_subject}(minTimeIndex(n_subject):minTimeIndex(n_subject) + lenghtData, :);
    end
    selectedDataset = squeeze(selectedDataset);
    
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
        epochSeconds2 = floor(epochSeconds1);
        
        epochMiliseconds1 = round((epochSeconds1 - epochSeconds2)*1000); % get the miliseconds,
        
        newEpochs{jNewDate} = [num2str(epochHours2),':',num2str(epochMinutes2),':',num2str(epochSeconds2),':', num2str(epochMiliseconds1)];
        
        counter = counter + 1/250;
    end
    commonTimeline = newEpochs';
    
    compilatedSeconds = 0:1/250:(length(selectedDataset)/250)-1/250;
    commonCompilatedSeconds = (bsxfun(@plus, compilatedSeconds, newCompiledSecondsStart))';
    
    %% Saving data
    
    % variables to save,
    samplingFrequency = 250;
    structureDataList =  dataOfInterest';
    structureSubjectList = directoryNames3';
    structureSources = sourcePaths';
    structureComments = structureComments';
    dataTypeName = directoryNames2(3:end);
    processingSteps = cellstr(['structure created on ', date, ' with createstructbioh2ecg_1.m']);   
    
    % name of the data-file
    fileName = sprintf('ECG_%s', directoryNames{i_session}); % regular version
    % fileName = sprintf('ECG_%s_alt', directoryNames{i_session}); % for alternative versions
    
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
    ouputFolder = sprintf('../../../2_data_analysis/bioharness_new/%s', destinyFolder);
    cd (ouputFolder)
    
    % save the data
    save (fileName, 'FileStruct')
    
    % change directory
    cd (inputFolder)
    
end % i_Dir

% checking time
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));

% END