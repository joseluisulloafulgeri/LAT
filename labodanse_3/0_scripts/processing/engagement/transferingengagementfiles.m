% transferingengagementfiles.m
% transfer files
% run in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Tablets/labodanse_tablettes_sorted

% created by JLUF 09/06/2015
% updates:
% JLUF 11/06/2015
% JLUF 22/06/2015
% data from subject B29_828 was subsequently corrected cause full data was
% in the server folder

%% variables

homePath = pwd;
%folders =
%{'LD_expMay2015_Day1','LD_expMay2015_Day2','LD_expMay2015_Day3'}; taking data from the server
folders = {'104','106','107','108','476','573','719','749','804','810','812','819','825','828','846'}; % taking data from the tablets

%% get into each data-type folder

for i_folder = 1:length(folders)
    
    cd (folders{i_folder})
    cd ('ENG')
    files2 = dir('*.csv');
    namesfiles = {files2.name};
    namesfiles = namesfiles';
    
    for i_file = 1:length(namesfiles)
        
        % tablet file name
        actualFileName = namesfiles{i_file};
        splitedFileName = strsplit(actualFileName, {'-', '_'}, 'CollapseDelimiters', true);
        % importing the tablet file
        tabletFile = importdata(actualFileName);
        
        % searching the equivalent server file
        locatefile = sprintf('[systemoutput1, systemoutput2] = system(''find /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Server/ -name %s'');', actualFileName);
        eval(locatefile)
        serverFilePath = strrep(systemoutput2, '//', '/');
        serverFilePath = serverFilePath(1:end-1);
        
        if ~isempty(serverFilePath) % if I find the other file
            
            % importing the equivalent server file
            serverFile = importdata(serverFilePath);
            
            % checking that both timelines are identical
            goodTimes4data = isequal(tabletFile.data(:,1), serverFile.data(:,2));
            if goodTimes4data
                display('files have the same timelines')
            else
                display('attention, files have not the same timelines')
            end
            
            % get the timing
            tabletTimeline = tabletFile.data(:,1);
            serverTimeline = serverFile.data(:,1:2);
            
            % computing the difference server-tablet
            differenceTiming = serverTimeline(:,2) - serverTimeline(:,1);
            subsection = differenceTiming(1:70,:); % selecting a chunk of data
            modeValue = mode(subsection, 1); % computing the mode
            
            % EXCEPTIONS!!! problematic files
            if strcmp(actualFileName, '104-2015_05_12_14_56_43_ENG.csv')
                modeValue = 500;
            elseif strcmp(actualFileName, '104-2015_05_14_18_11_01_ENG.csv')
                modeValue = 104;
            elseif strcmp(actualFileName, '719-2015_05_12_15_56_34_ENG.csv')
                modeValue = 110;
            elseif strcmp(actualFileName, '825-2015_05_15_19_14_15_ENG.csv')
                modeValue = -243;
            else
                % nothing
            end
            
            % correcting the tablet timeline
            correctedTabletTimeline = bsxfun(@plus, tabletTimeline, modeValue);
            
            % reinjecting in the data field
            tabletFile2 = tabletFile;
            tabletFile2.data(:,1) = correctedTabletTimeline;
            
        else % we keep the original timestamps
            tabletFile2 = tabletFile;
            
        end
        
        %% defining parameters to change name
        tabletNumber = splitedFileName{1};
        yearNumber = splitedFileName{2};
        monthNumber = splitedFileName{3};
        dayNumber = splitedFileName{4};
        % group
        if str2double(splitedFileName{5}) < 17;
            group = 'A';
        else
            group = 'B';
        end
        % corresponding day in the table
        if str2double(dayNumber) == 12 && strcmp(group, 'A')
            columnDayCorrespondance = 1;
        elseif str2double(dayNumber) == 12 && strcmp(group, 'B')
            columnDayCorrespondance = 2;
        elseif str2double(dayNumber) == 14 && strcmp(group, 'A')
            columnDayCorrespondance = 3;
        elseif str2double(dayNumber) == 14 && strcmp(group, 'B')
            columnDayCorrespondance = 4;
        elseif str2double(dayNumber) == 15 && strcmp(group, 'A')
            columnDayCorrespondance = 5;
        elseif str2double(dayNumber) == 15 && strcmp(group, 'B')
            columnDayCorrespondance = 6;
        end
        
        tabletNumberAll = {'104','106','107','108','476','573','719','749','804','810','812','819','825','828','846'};
        
        % NoA = Not Assigned,
        tableCorrespondances = {...
            'NoA','NoA','NoA','Notat','NoA','NoA'; ...
            'NoA','NoA','Notat','NoA','NoA','NoA'; ...
            'NoA','NoA','NoA','B34','NoA','NoA'; ...
            'NoA','NoA','NoA','NoA','NoA','NoA'; ...
            'A22','B18','A30','B33','A49','B51'; ...
            'A11','NoA','A26','B35','A52','B44'; ...
            'A21','B17','A28','B32','A47','B41'; ...
            'A13','B21','A60','B30','A48','B46'; ...
            'A18','NoA','A40','NoA','A41','B50'; ...
            'A12','B13','A35','B37','A43','B47'; ...
            'A20','B16','A37','B31','NoA','B52'; ...
            'A15','B19','A36','B36','A42','B48'; ...
            'A19','B11','A32','B26','A46','B53'; ...
            'A14','B12','A33','B29','A44','B49'; ...
            'A23','NoA','A29','B27','A45','B43'};
        
        % defining row index according to the name of the tablet
        [testMember, indexTablet] = ismember(tabletNumberAll, tabletNumber);
        indexTablet2 = find(indexTablet == 1);
        
        % defining name
        newFileName = sprintf('%s_%s.mat', tableCorrespondances{indexTablet2, columnDayCorrespondance}, tabletNumber);
        
        % defining destiny folder
        destinyPath = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/1_data_organized';
        destinyFolder = sprintf('%s_%s_%s_%s', yearNumber, monthNumber, dayNumber, group);
        sectionFolder = '6_subj_online';
        fullPath = fullfile(destinyPath, destinyFolder, sectionFolder, newFileName);
        
        % for checking
        %display(actualFileName);
        %display(destinyFolder);
        %display(newFileName);
        
        % copy file & rename it
        save(fullPath, 'tabletFile2');
        
    end
    cd ../../
end

% END