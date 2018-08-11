
% createstructeng.m
% USE: extract engagement data, synchronize across subjects, and create structure
% INPUT: engagement csv files (in 1_data_organized/)
% OUPUT: structures (in a folder within 2_data_analysis)
% ROOTS: folder containing engagement data (data is embedded in a hierarchy of folders)

% so far, to run in 1_data_organized/

% remember the data is organized as follows:
% 1_data_organized/2014_10_20_AM/2_bioh_capteurs/A01_846/2014_10_20-09_41_07/2014_10_20-09_41_07_Summary.csv

% created: YF 06/10/2014; modified: JLUF 12/10/2014 modified_2: JLUF 13/10/2014
% last update: JLUF 15/01/2015

%% Checking timing 

tStart = tic;

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > engagementNew_1

%% Getting the directory file names

% get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM' '2014_10_20_PM1'...

% select the PM folders
folderSelectionLogic = ~cellfun(@isempty,regexp(directoryNames, 'PM'));
directoryNames = directoryNames(folderSelectionLogic); % e.g. '2014_10_20_PM1'...

%% Selecting data type

% 6_subj_online is the engagement data
directoryNames2 = '6_subj_online';

for i_session = 1:length(directoryNames) % loop for each session
    
    %% Getting the names of each subject-folder
    
    path3 = fullfile(directoryNames{i_session}, directoryNames2); % generate the path, e.g. 2014_10_20_PM1/6_subj_online/
    files3 = dir(path3);
    directoryNames3 = {files3.name};
    folderSelectionLogic3 = ~cellfun(@isempty,regexp(directoryNames3, '.csv')); % keep .csv files
    directoryNames3 = directoryNames3(folderSelectionLogic3); % e.g. 'A01_804_PM1_ENG.csv' 'A02_476_PM1_ENG.csv' ...
    
    % initialization of some variables
    dataTimeSecondsMat = cell(1, length(directoryNames3));
    timelineMin = zeros(1, length(directoryNames3));
    timelineMax = zeros(1, length(directoryNames3));
    dataFirstStep = cell(1, length(directoryNames3));
    sourcePaths = cell(1, length(directoryNames3));
    structureComments = {};
    
    for i_subject = 1:length(directoryNames3) % loop for each subject
        
        %% Getting the names of each data file
        
        path4 = fullfile(path3, directoryNames3{i_subject}); % generate the path, e.g. 2014_10_20_PM1/6_subj_online/A01_804_PM1_ENG.csv
        sourcePaths{i_subject} = path4;
        
        %% Importing data
        
        % import dataset
        importedData = importdata(path4);
        
        % importdata generates a structure with 2 fields: numerical data, and text,
        % importedData.textData give us the labels, and in our case the first column with the dates
        % importedData.data give us the numerical data, 
        % attention! relative to bioharness data, here the timeline is not included in importedData.data
        
        %% Getting time information and replacing data values in an uniform timeline

        dataOfInterest = {'x','y'}; % defining data of interest
                
        correction = 7200000; % time correction => x + 7200000
        correctedDataTimeline = bsxfun(@plus, importedData.data(:,1), correction); % timeline corrected
        
        % creation of an extended timeline with the First and Last index
        uniformTimeline = correctedDataTimeline(1):correctedDataTimeline(end); % e.g. 1413824400000:1413826800000;
        
        % due to irregularities of the timeline we create an uniform timeline
        % in the timepoints of this new timeline we put the data

        % pre-filling with NaN values
        valueEng = NaN(2, length(uniformTimeline));
        
        % testing if timepoint data exist
        [testMember, indexInRounded] = ismember(uniformTimeline, correctedDataTimeline);
        
        % creating the dataset
        for iTimePoint = 1:length(uniformTimeline)
            if testMember(iTimePoint);
                valueEng(1, iTimePoint) = importedData.data(indexInRounded(iTimePoint), 2); % (1x1901199)
                valueEng(2, iTimePoint) = importedData.data(indexInRounded(iTimePoint), 3); % (1x1901199)
            else
                % nothing
            end
        end
        
        %% Taking the maximal value each 100 points
        
        count = 1;
        valueEng2 = NaN(2, floor(length(uniformTimeline)/100)); % 1901 points
        for iNewData = 1:100:floor(length(uniformTimeline)/100)*100 % 1901199
            valueEng2(1, count) = max(valueEng(1, iNewData:iNewData + 99));
            valueEng2(2, count) = max(valueEng(2, iNewData:iNewData + 99));
            count = count + 1;
        end
        
        % definitive data is here!
        dataFirstStep{1, i_subject} = valueEng2';
        
        %% Changing the timeline accordingly
        
        timelineStep1 = 0:100:floor(length(uniformTimeline)/100)*100-1; % creates a resampled version of values
        newFirstTimepoint1 = mat2str(correctedDataTimeline(1)); % round first time point
        newFirstTimepoint2 = round( str2double(newFirstTimepoint1)/100 ) *100; % e.g. 1413824999102 --> 1413824999100
        
        % generate a good timeline (sum the first time point value)
        newTimeline = bsxfun(@plus, timelineStep1, newFirstTimepoint2);
        
        %% Transforming the timeline 

        convertedTime = timestamps2humandate(newTimeline, 1); % tranform time stamps to human date
        
        % re-format the date from 20-Oct-2014 15:09:59 to 20/10/2014 15:09:59
        convertedTime2  = convertedTime;
        for y_string = 1:length(convertedTime)
            convertedTime2{y_string} = strrep(convertedTime{y_string}, '-Oct-', '/10/');
        end
        convertedTime2 = convertedTime2';
                       
        %% Recreating importedData.textdata
        
        % the data
        newTextData = cell(length(convertedTime2) + 1, length(importedData.textdata));
        for i_textData = 1:length(newTextData) - 1
            newTextData{i_textData+1, 1} = convertedTime2{i_textData};
        end
        
        newTextData{1,1} = 'Time'; % the header ("Time")
        newTextData{1,2} = importedData.textdata(1,2); % the header ("x")
        newTextData{1,3} = importedData.textdata(1,3); % the header ("y")
        importedData.textdata = newTextData; % replacing now for the new text data
        
        %% Recreating importedData.data
        
        % for the numeric data we eliminate one column,
        importedData.data(:,1) = []; % eliminate the first column (time),
        
        %% Recovering the miliseconds data
        
        milisecondsRecovering = cell(1, length(newTimeline)); 
        milisecondsRecovering2 = cell(1, length(newTimeline));
        milisecondsRecovering3 = zeros(1, length(newTimeline));
        for i_timeline = 1:length(newTimeline)
            milisecondsRecovering{i_timeline} = num2str(newTimeline(i_timeline));
            milisecondsRecovering2{i_timeline} = milisecondsRecovering{i_timeline}(:, 11:13);
            milisecondsRecovering3(i_timeline) = str2num(milisecondsRecovering2{i_timeline});
        end

        milisecondsRecovering3 = milisecondsRecovering3/1000;
        
        %% Setting timeline
        
        % at this stage I use previous commands for similar data
        
        % from 2 to exclude the label and 1 because first column is time,
        timeData = importedData.textdata(2:end,1);
        
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

        milisecondsData = milisecondsRecovering3;
        
        % concatenation
        completeDataTimeSet = [hoursData; minutesData; secondsData; milisecondsData];
        
        % summing, to generate compilated seconds,
        dataTimeSeconds = sum(completeDataTimeSet);
        
        % we save the timelines of each subject
        dataTimeSecondsMat{i_subject} = dataTimeSeconds;
        
        % we save the minimal timepoint of the timeline for each subject
        timelineMin(i_subject) = dataTimeSecondsMat{i_subject}(1);
        
        % we save the maximal timepoint of the timeline for each subject
        timelineMax(i_subject) = dataTimeSecondsMat{i_subject}(end);
        
    end % i_subject
    
    % across all subjects we find the minimal and maximal common timepoints,
    [commonMinTime, minTimeSubjectIndex] = max(timelineMin);
    [commonMaxTime, maxTimeSubjectIndex] = min(timelineMax);
    
    % for the data of each subject we select the dataset that lay between the common minimal and maximal datapoints
    minTimeIndex = zeros(1, length(directoryNames3));
    maxTimeIndex = minTimeIndex;
    commonTimepoints = minTimeIndex;
    for i_subject = 1:length(directoryNames3)
        minTimeIndex(i_subject) = find(dataTimeSecondsMat{i_subject} >= commonMinTime, 1, 'first');
        maxTimeIndex(i_subject) = find(dataTimeSecondsMat{i_subject} <= commonMaxTime, 1, 'last');
        commonTimepoints(i_subject) = maxTimeIndex(i_subject) - minTimeIndex(i_subject); % common timepoints should be equal,
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
    
    lenghtData = min(commonTimepoints(i_subject)) - 1; % e.g. 11575 datapoints
    
    % here, a new dataset is created by looking at the original dataset but taking only those datapoints where we find a shared timeline,
    % e.g between the index 1 of the timeline that start the later, and the index 11577 of the timeline that finish earlier
    % i.e. 11576 common timepoints across all subjects
    
    selectedDataset = zeros(commonTimepoints(1), length(dataOfInterest), length(directoryNames3));
    for jSubject = 1:length(directoryNames3)
        selectedDataset(:,:,jSubject) = dataFirstStep{1, jSubject}(minTimeIndex(jSubject):minTimeIndex(jSubject) + lenghtData,:);
    end
    
    % -> selectedDataset is a 3 (time, dataOfInterest, subject) matrix
    
    %% Data start epoch

    newCompiledSecondsStart = dataTimeSecondsMat{1}(minTimeIndex(1));
    
    % correction relative the time markers, added 01/12/2014
    newCompiledSecondsStart = newCompiledSecondsStart - 60;
    
    newEpochs = cell(1, length(selectedDataset)); counter = 0;
    for jNewDate = 1:length(selectedDataset)
        timeEpoch = newCompiledSecondsStart + counter;
        
        epochHours1 = timeEpoch/(60*60); % get the hours,
        epochHours2 = floor(epochHours1); % get the hours,
        
        epochMinutes1 = (epochHours1 - epochHours2)*60; % get the minutes,
        epochMinutes2 = floor(epochMinutes1); % get the minutes,
        
        epochSeconds1 = (epochMinutes1 - epochMinutes2)*60; % get the seconds,
        
        newEpochs{jNewDate} = [num2str(epochHours2),':',num2str(epochMinutes2),':',num2str(epochSeconds1)];
        counter = counter + 0.1;
    end
    commonTimeline = newEpochs';
    
    compilatedSeconds = 0:0.1:(length(selectedDataset)/10)-0.1;
    commonCompilatedSeconds = (bsxfun(@plus, compilatedSeconds, newCompiledSecondsStart))';
       
    %% Saving data
          
    % variables to save,
    samplingFrequency = 10;
    structureDataList =  dataOfInterest';
    structureSubjectList = directoryNames3';
    structureSources = sourcePaths';
    structureComments = structureComments';
    dataTypeName = directoryNames2(3:end);
    processingSteps = cellstr(['structure created on ', date, ' with createstructeng.m']);
    
    % name of the data-file
    fileName = sprintf('Engagement_%s', directoryNames{i_session});
    
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
    ouputFolder = sprintf('../2_data_analysis/engagement/%s', destinyFolder);
    cd (ouputFolder)
    
    % save the data
    save (fileName, 'FileStruct')
    
    % change directory
    inputFolder = '../../../1_data_organized';
    cd (inputFolder)
    
end % i_Dir

% checking time end
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));

% END