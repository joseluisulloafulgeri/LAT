
% script for re-organize files in a folder
% JLUF 04/10/2014
% to launch in /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Bioharness

% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

tabletNames = {'476' '573' '719' '749' '804' '810' '812' '819' '825' '828' '846'};
varText = sprintf( '\ntiming checking\n' );

% get into each main folder
for i_folder = 1:length(directoryNames)
    
    cd (directoryNames{i_folder})
    
    for i_tablet = 1:length(tabletNames)
        
        cd (tabletNames{i_tablet})
        nameTablet = tabletNames{i_tablet};
        
        files2 = dir;
        directoryNames2 = {files2([files2.isdir]).name};
        directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..','File_1' 'No Team Assigned'}));
        
        for i_folder2 = 1:length(directoryNames2)
            
            cd (directoryNames2{i_folder2})
            nameFile = (directoryNames2{i_folder2});
            fileTarget = dir('*Summary.csv');
            fileTargetName = fileTarget.name;
            dataFile = importdata(fileTargetName);
            
            timingData = dataFile.textdata(2:end,1);
            lengthData = length(timingData);
            startRecord = cell2mat(timingData(1,1)); % 12/05/2015 09:44:41.439
            startRecord2 = datevec(startRecord); % [2015,12,5,9,44,41.4390029907227]
            %
            endRecord = cell2mat(timingData(end,1));
            endRecord2 = datevec(endRecord);
            
            diffTime = endRecord2 - startRecord2;
            diffHour = diffTime(4); diffHour_Seconds = diffHour*60*60;
            diffMin = diffTime(5); diffMin_Seconds = diffMin*60;
            diffSec =  diffTime(6);
            sumTimeSeconds = diffHour_Seconds + diffMin_Seconds + diffSec;
            
            epochHours1 = sumTimeSeconds/(60*60); % get the hours,
            epochHours2 = floor(epochHours1); % get the hours,
            epochMinutes1 = (epochHours1 - epochHours2)*60; % get the minutes,
            epochMinutes2 = floor(epochMinutes1); % get the minutes,
            epochSeconds1 = (epochMinutes1 - epochMinutes2)*60; % get the seconds,
            epochSeconds1 = round(epochSeconds1);
            totalDifference = [num2str(epochHours2),':',num2str(epochMinutes2),':',num2str(epochSeconds1)];
            
            varText = [varText sprintf('\nTabletName\t%s\nFileName\t%s\nStartRecording\t%s\nEndRecording\t%s\nTotalDuration\t%s\nLinesNumber\t%d\n', ...
                nameTablet, nameFile, char(startRecord), char(endRecord), totalDifference, lengthData)];
        
            cd ..
        end
        
        cd ..
    end
    
    cd ..
    varText = [varText sprintf('\n\n')];
    
end

fileTiming = fopen('fileTiming', 'w+' );
fwrite(fileTiming, varText );
fclose(fileTiming);

% END