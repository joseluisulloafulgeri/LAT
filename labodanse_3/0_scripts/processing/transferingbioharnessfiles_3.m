% transferingbioharnessfiles.m
% transfer files
% run in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Bioharness

% created by JLUF 22/06/2015
% updates: JLUF 23/06/2015

%% Checking time
tStart = tic;

%% variables
homePath = pwd;
counterExceptionECG = 1;
counterExceptionBreathing = 1;

% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

%tabletNames = {'476' '573' '719' '749' '804' '810' '812' '819' '825' '828' '846'};

%tabletNames = {'476' '573' '719' '749' '804' '810'};
%tabletNames = {'812' '819' '825' '828' '846'};
tabletNames = {'810'}; % -- TEST

%% get into each main folder
for i_folder = 1:length(directoryNames)
    %for i_folder = 2:length(directoryNames) %  -- TEST
    
    cd (directoryNames{i_folder})
    
    for i_tablet = 1:length(tabletNames)
        
        cd (tabletNames{i_tablet})
        nameTablet = tabletNames{i_tablet};
        
        files2 = dir;
        directoryNames2 = {files2([files2.isdir]).name};
        directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..','File_1' 'No Team Assigned'}));
        
        for i_folder2 = 1:length(directoryNames2)
            
            %% get data
            cd (directoryNames2{i_folder2})
            nameFile = (directoryNames2{i_folder2}); % file folder
            nameFileFetaures = strsplit(nameFile, {'-', '_'}, 'CollapseDelimiters', true);
            
            % listing the content of csv files
            bioharnessFiles = dir('*.csv');
            bioharnessFileNames = {bioharnessFiles.name};
            
            %% import data
            display(sprintf('\n----------\n'))
            display(sprintf(' --- importing data from tablet: %s, file: %s ---', nameTablet, nameFile))
            breathingData = importBreathingbioharness(bioharnessFileNames{3});
            ECGdata = importECGbioharness(bioharnessFileNames{4});
            
            % datetimeECG = datevec(cell2mat(ECGdata(2:end,1))); HORRIBLY SLOW
            % datetimeBreathing = datevec(cell2mat(breathingData(2:end,1))); ; HORRIBLY SLOW
            
            % generate the timelines ECG
            firstTimePointECG = datevec(cell2mat(ECGdata(2,1)));
            firstDateChar = sprintf('%d:%d:%.3f', firstTimePointECG(4), firstTimePointECG(5), firstTimePointECG(6));
            dataTimeSecondsECGfirst = humantime2compiledsec(firstDateChar);
            timelineBackbone = 0:1/250:(length(ECGdata)-2)/250; % the backbone of the timeline
            regeneratedTimelineECG = bsxfun(@plus, timelineBackbone, dataTimeSecondsECGfirst);
            regeneratedTimelineECG = regeneratedTimelineECG';
            % get ECG data
            ECGdataSection = ECGdata(2:end,2);
            ECGdataSection2 = sscanf(sprintf('%s\v',ECGdataSection{:}),'%f\v'); % instead of ECGdataSection2 = str2double(ECGdataSection);
            % put all together
            ECGfullData = [regeneratedTimelineECG ECGdataSection2];
            
            % generate the timelines Breathing
            firstTimePointBreathing = datevec(cell2mat(breathingData(2,1)));
            firstDateCharBreathing = sprintf('%d:%d:%.3f', firstTimePointBreathing(4), firstTimePointBreathing(5), firstTimePointBreathing(6));
            dataTimeSecondsBreathingfirst = humantime2compiledsec(firstDateCharBreathing);
            timelineBackboneBreathing = 0:1/25:(length(breathingData)-2)/25; % the backbone of the timeline
            regeneratedTimelineBreathing = bsxfun(@plus, timelineBackboneBreathing, dataTimeSecondsBreathingfirst);
            regeneratedTimelineBreathing = regeneratedTimelineBreathing';
            % get Breathing data
            BreathingdataSection = breathingData(2:end,2);
            BreathingdataSection2 = sscanf(sprintf('%s\v',BreathingdataSection{:}),'%f\v'); % instead of BreathingdataSection2 = str2double(BreathingdataSection);
            % put all together
            BreathingfullData = [regeneratedTimelineBreathing BreathingdataSection2];
            
            %% first filter for yoga data
            if strcmp(nameFileFetaures{4}, '09') || strcmp(nameFileFetaures{4}, '10')
                destinyName = 'Yoga';
                
            else
                
                %% searching the equivalent server file
                locatefile = sprintf('[systemoutput1, systemoutput2] = system(''find /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Server/ -name %s*BH.csv'');', nameTablet);
                eval(locatefile)
                
                fileNameSet = strsplit(systemoutput2); % get the set of server files associated with that tablet number
                fileNameSet = fileNameSet';
                fileNameSet(strcmp('',fileNameSet)) = []; % eliminate zero-content cell
                
                fileNameSet2 = cellfun (@(x) strrep (x, '//', '/'), fileNameSet, 'UniformOutput', false); % replace in each cell '//' by '/'
                %serverFilePath = serverFilePath(1:end-1); % sometimes a blank space leaks --> not needed here
                
                [pathstrServerFiles, nameServerFiles, extServerFiles] = ...
                    cellfun (@(x) fileparts (x), fileNameSet2, 'UniformOutput', false); % get part of the server file path
                
                dayNameServerFiles = cellfun (@(x) x(13:14), nameServerFiles, 'UniformOutput', false); % get the date in the server file name
                
                % defining the experiment day of the current file
                if strcmp(directoryNames{i_folder}, 'Day1')
                    dayNumber = '12';
                elseif strcmp(directoryNames{i_folder}, 'Day2')
                    dayNumber = '14';
                elseif strcmp(directoryNames{i_folder}, 'Day3')
                    dayNumber = '15';
                end
                
                % compare the date of the current file and the server file name
                checkingServerFile = cellfun (@(x) strcmp (x, dayNumber), dayNameServerFiles, 'UniformOutput', false); % compare the dates
                
                % create a logical vector to select the good server file
                logicalSelector = logical(cell2mat(checkingServerFile));
                selectionServerFile = fileNameSet2(logicalSelector);
                
                % next, we look at the hour of the server files
                [pathstrServerFiles2, nameServerFiles2, extServerFiles2] = ...
                    cellfun (@(x) fileparts (x), selectionServerFile, 'UniformOutput', false); % get part of the file path
                dayNameServerFiles2 = cellfun (@(x) x(16:17), nameServerFiles2, 'UniformOutput', false); % get the date
                
                groupA = {'13' '14' '15' '16'}; % group A is around 14h
                groupB = {'17' '18' '19' '20'}; % group B is around 16h
                
                if length(selectionServerFile) == 1;
                    
                    % define group CURRENT file
                    if ismember(nameFileFetaures{4}, groupA); % if is this hour ...
                        groupCurrentFile = 'A';
                    elseif ismember(nameFileFetaures{4}, groupB); % if is this hour ...
                        groupCurrentFile = 'B';
                    end
                    
                    % define group SERVER file
                    if ismember(dayNameServerFiles2, groupA); % if is this hour ...
                        groupServerFile = 'A';
                    elseif ismember(dayNameServerFiles2, groupB); % if is this hour ...
                        groupServerFile = 'B';
                    end
                    
                    % check if they are of the same group
                    if strcmp(groupCurrentFile, groupServerFile)
                        logicalSelector2 = logicalSelector;
                    else
                        logicalSelector2 = false(length(logicalSelector), 1);
                    end
                    
                    % it might be the case that two files are good (the one of the early and of the late sessions)
                elseif length(selectionServerFile) > 1;
                    
                    if ismember(nameFileFetaures{4}, groupA); % if is this hour ...
                        modifyLogic = find(logicalSelector==1, 1, 'last'); % delete the last '1' of the logical filter
                        logicalSelector2 = logicalSelector;
                        logicalSelector2(modifyLogic) = 0;
                    elseif ismember(nameFileFetaures{4}, groupB); % if is this hour ...
                        modifyLogic = find(logicalSelector==1, 1, 'first'); % otherwise eliminate the first '1' of the logical filter
                        logicalSelector2 = logicalSelector;
                        logicalSelector2(modifyLogic) = 0;
                    end
                else
                    logicalSelector2 = false;
                end
                
                selectionServerFile = fileNameSet2(logicalSelector2);
                
                if ~isempty(selectionServerFile) % if there is a SERVER file
                    
                    display(sprintf(' --- this file has a server file, the %s ---', char(selectionServerFile)))
                    
                    %% importing the equivalent server file
                    bioharnessServerFile = importbioharnessfile(cell2mat(selectionServerFile)); % *****SERVER FILE IS HERE********
                    
                    % computing the difference server-tablet
                    differenceTiming = cell2mat(bioharnessServerFile(:,1)) - cell2mat(bioharnessServerFile(:,3));
                    modeValue = mode(differenceTiming, 1); % computing the mode
                    correctingFactorSec = modeValue/1000;
                    
                    %% fixing other problems related to some specific files
                    if strcmp(nameFile, '2015_05_14-14_31_53') && strcmp(nameTablet, '810')
                        correctingFactorSec = correctingFactorSec - 3600;
                    elseif strcmp(nameFile, '2015_05_15-14_25_07') && strcmp(nameTablet, '810')
                        correctingFactorSec = correctingFactorSec - 3600;
                    elseif strcmp(nameFile, '2015_05_15-17_43_27') && strcmp(nameTablet, '810')
                        correctingFactorSec = correctingFactorSec - 3600;                        
                    else
                        % nothing
                    end                    
                    
                    correcregeneratedTimelineECG = bsxfun(@plus, regeneratedTimelineECG, correctingFactorSec);
                    correcregeneratedTimelineBreathing = bsxfun(@plus, regeneratedTimelineBreathing, correctingFactorSec);
                    
                    % reinjecting in the data field
                    ECGfullData(:,1) = correcregeneratedTimelineECG;
                    BreathingfullData(:,1) = correcregeneratedTimelineBreathing;
                    
                else 
                    % we keep the original timestamps
                    display(sprintf(' --- this file has no server file ---'))
                    
                end
            end
            
            %% defining parameters to change name
            tabletNumber = nameTablet;
            
            yearNumber = nameFileFetaures{1};
            monthNumber = nameFileFetaures{2};
            dayNumber = nameFileFetaures{3};
            
            % group
            if str2double(nameFileFetaures{4}) < 11;
                group = 'Yoga';
            elseif str2double(nameFileFetaures{4}) > 10 && str2double(nameFileFetaures{4}) < 17;
                group = 'A';
            else
                group = 'B';
            end
            display(sprintf(' --- this data is from group %s ---', group))
            
            % corresponding day in the table
            if str2double(dayNumber) == 12 && strcmp(group, 'A') || str2double(dayNumber) == 12 && strcmp(group, 'Yoga')
                columnDayCorrespondance = 1;
            elseif str2double(dayNumber) == 12 && strcmp(group, 'B')
                columnDayCorrespondance = 2;
            elseif str2double(dayNumber) == 14 && strcmp(group, 'A') || str2double(dayNumber) == 14 && strcmp(group, 'Yoga')
                columnDayCorrespondance = 3;
            elseif str2double(dayNumber) == 14 && strcmp(group, 'B')
                columnDayCorrespondance = 4;
            elseif str2double(dayNumber) == 15 && strcmp(group, 'A') || str2double(dayNumber) == 15 && strcmp(group, 'Yoga')
                columnDayCorrespondance = 5;
            elseif str2double(dayNumber) == 15 && strcmp(group, 'B')
                columnDayCorrespondance = 6;
            end
            
            tabletNumberAll = {'104','106','107','108','476','573','719','749','804','810','812','819','825','828','846'};
            
            % NoA = Not Assigned,
            tableCorrespondances = {...
                '---','---','---','---','---','---'; ...
                '---','---','---','---','---','---'; ...
                '---','---','---','---','---','---'; ...
                '---','---','---','---','---','---'; ...
                'A22','B18','A30','B33','A49','B51'; ...
                'A11','---','A26','B35','A52','B44'; ...
                'A21','B17','A28','B32','A47','B52'; ...
                'A13','B21','A60','B30','A48','B46'; ...
                'A18','Danc','EXC','EXC','A41','B50'; ...
                'A12','B13','A35','B37','A43','B47'; ...
                'A20','B16','A37','B31','Danc','Danc'; ...
                'A15','B19','A36','B36','A42','B48'; ...
                'A19','B11','A32','B26','A46','B53'; ...
                'A14','B12','A33','B29','A44','B49'; ...
                'A23','---','A29','B27','A45','B43'};
            
            % defining row index according to the name of the tablet
            [testMember, indexTablet] = ismember(tabletNumberAll, tabletNumber);
            indexTablet2 = find(indexTablet == 1);
            
            % defining destiny folder
            destinyPath = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/1_data_organized';
            destinyFolder = sprintf('%s_%s_%s_%s', yearNumber, monthNumber, dayNumber, group);
            sectionFolder = '2_bioh_capteurs';
            
            % defining name ECG
            newFileNameECG = sprintf('%s_%s_ECG.mat', tableCorrespondances{indexTablet2, columnDayCorrespondance}, tabletNumber);
            % exceptions
            if  ~isempty(regexp(newFileNameECG,'EXC','once'))
                if counterExceptionECG == 1 || counterExceptionECG == 2
                    newFileNameECG = sprintf('A40_804_ECG.mat');
                    counterExceptionECG = counterExceptionECG + 1;
                elseif counterExceptionECG == 3;
                    newFileNameECG = sprintf('Danc_804_ECG.mat');
                    counterExceptionECG = counterExceptionECG + 1;
                elseif counterExceptionECG == 4;
                    newFileNameECG = sprintf('B34_804_ECG.mat');
                    counterExceptionECG = counterExceptionECG + 1;                    
                elseif counterExceptionECG == 5;
                    newFileNameECG = sprintf('Danc_804_ECG.mat');
                    counterExceptionECG = counterExceptionECG + 1;                    
                end
            end
            % defining all ECG
            fullPathECG = fullfile(destinyPath, destinyFolder, sectionFolder, newFileNameECG);
            
            % defining name Breathing
            newFileNameBreathing = sprintf('%s_%s_Breathing.mat', tableCorrespondances{indexTablet2, columnDayCorrespondance}, tabletNumber);
            % exceptions
            if  ~isempty(regexp(newFileNameBreathing,'EXC','once'))
                if counterExceptionBreathing == 1 || counterExceptionBreathing == 2
                    newFileNameBreathing = sprintf('A40_804_Breathing.mat');
                    counterExceptionBreathing = counterExceptionBreathing + 1;
                elseif counterExceptionBreathing == 3;
                    newFileNameBreathing = sprintf('Danc_804_Breathing.mat');
                    counterExceptionBreathing = counterExceptionBreathing + 1;
                elseif counterExceptionBreathing == 4;
                    newFileNameBreathing = sprintf('B34_804_Breathing.mat');
                    counterExceptionBreathing = counterExceptionBreathing + 1;                    
                elseif counterExceptionBreathing == 5;
                    newFileNameBreathing = sprintf('Danc_804_Breathing.mat');
                    counterExceptionBreathing = counterExceptionBreathing + 1;                    
                end
            end
            
            display(sprintf(' --- the %s file will be saved in %s ---', newFileNameECG, destinyFolder))
            display(sprintf(' --- the %s file will be saved in %s ---', newFileNameBreathing, destinyFolder))
            
            % defining all ECG
            fullPathBreathing = fullfile(destinyPath, destinyFolder, sectionFolder, newFileNameBreathing);            
            
            % for checking
            %display(actualFileName);
            %display(destinyFolder);
            %display(newFileName);
            
            % copy file & rename it
            save(fullPathECG, 'ECGfullData');
            save(fullPathBreathing, 'BreathingfullData');
            
            pause(0.01) %in seconds 
            
            cd ..
        end
        
        cd ..
    end
    
    cd ..
end

% checking time
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));

% END