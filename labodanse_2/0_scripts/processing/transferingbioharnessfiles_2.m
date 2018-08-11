
% transferingbioharnessfiles_2.m
% adaptation from transferingbioharnessfiles_1.m
% transfer files
% run in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_2/2014_12_11_12/Bioharness

% created by JLUF 22/06/2015
% updates: JLUF 05/08/2015

%% Checking time
tStart = tic;

%% variables
homePath = pwd;
counterExceptionECG = 1;
counterExceptionBreathing = 1;

tabletNames = {'476' '573' '719' '749' '804' '810' '812' '819' '825' '828' '846'};
%tabletNames = {'719' '810'};

%% get into each main folder

for i_tablet = 1:length(tabletNames)
    
    cd (tabletNames{i_tablet})
    nameTablet = tabletNames{i_tablet};
    
    files2 = dir;
    directoryNames2 = {files2([files2.isdir]).name};
    directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..','File_1' 'No Team Assigned' 'extra_file'}));
    
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
        
        %% defining parameters to change name
        tabletNumber = nameTablet;
        
        yearNumber = nameFileFetaures{1};
        monthNumber = nameFileFetaures{2};
        dayNumber = nameFileFetaures{3};
        
        % group
        if str2double(nameFileFetaures{4}) < 11;
            group = 'Yoga';
        elseif str2double(nameFileFetaures{4}) > 10 && str2double(nameFileFetaures{4}) < 18;
            group = 'PM1';
        else
            group = 'PM2';
        end
        display(sprintf(' --- this data is from group %s ---', group))
        
        % corresponding day in the table
        
        if str2double(dayNumber) == 11 && strcmp(group, 'Yoga')
            columnDayCorrespondance = 1;        
        elseif str2double(dayNumber) == 11 && strcmp(group, 'PM1')
            columnDayCorrespondance = 2;
        elseif str2double(dayNumber) == 11 && strcmp(group, 'PM2')
            columnDayCorrespondance = 3;
        elseif str2double(dayNumber) == 12 && strcmp(group, 'Yoga')
            columnDayCorrespondance = 4;        
        elseif str2double(dayNumber) == 12 && strcmp(group, 'PM1')
            columnDayCorrespondance = 5;
        elseif str2double(dayNumber) == 12 && strcmp(group, 'PM2')
            columnDayCorrespondance = 6;            
        end
        
        tabletNumberAll = {'104','106','107','108','476','573','719','749','804','810','812','819','825','828','846'};
        
        % NoA = Not Assigned,
        tableCorrespondances = {...
            '---','---','---','---','---','---'; ...
            '---','---','---','---','---','---'; ...
            '---','---','---','---','---','---'; ...
            '---','---','---','---','---','---'; ...
            '---','C02','---','---','B20','---'; ...
            '---','---','---','A26','C01','C01'; ...
            '---','---','---','A18','C02','C02'; ...
            '---','---','---','---','B28','B26'; ...
            'A05','C01','---','A29','B22','A29'; ...
            '---','B01','---','A23','A23','---'; ...
            'A04','A04','---','A28','A26','A28'; ...
            'A07','A07','---','---','B29','B25'; ...
            'A08','A08','---','A30','A30','---'; ...
            '---','B05','---','A24','A24','B19'; ...
            'A02','A02','---','A27','A18','---'};
        
        % defining row index according to the name of the tablet
        [testMember, indexTablet] = ismember(tabletNumberAll, tabletNumber);
        indexTablet2 = find(indexTablet == 1);
        
        % defining destiny folder
        destinyPath = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_2/1_data_organized';
        destinyFolder = sprintf('%s_%s_%s_%s', yearNumber, monthNumber, dayNumber, group);
        sectionFolder = '2_bioh_capteurs';
        
        % defining name ECG
        newFileNameECG = sprintf('%s_%s_ECG.mat', tableCorrespondances{indexTablet2, columnDayCorrespondance}, tabletNumber);
        % defining all ECG
        fullPathECG = fullfile(destinyPath, destinyFolder, sectionFolder, newFileNameECG);
        
        % defining name Breathing
        newFileNameBreathing = sprintf('%s_%s_Breathing.mat', tableCorrespondances{indexTablet2, columnDayCorrespondance}, tabletNumber);
        % defining all Breathing
        fullPathBreathing = fullfile(destinyPath, destinyFolder, sectionFolder, newFileNameBreathing);
        
        
        display(sprintf(' --- the %s file will be saved in %s ---', newFileNameECG, destinyFolder))
        display(sprintf(' --- the %s file will be saved in %s ---', newFileNameBreathing, destinyFolder))
        
        % copy file & rename it
        save(fullPathECG, 'ECGfullData');
        save(fullPathBreathing, 'BreathingfullData');
        
        pause(0.01) %in seconds
        
        cd ..
    end
    
    cd ..
end

% checking time
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));

% END