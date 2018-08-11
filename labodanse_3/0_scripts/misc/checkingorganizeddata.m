
% script for re-organize files in a folder
% JLUF 04/10/2014
% to launch in /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/1_data_organized

% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

%tabletNames = {'476' '573' '719' '749' '804' '810' '812' '819' '825' '828' '846'};
varText = sprintf( '\ntiming checking\n' );

% get into each main folder
for i_folder = 1:length(directoryNames)
    
    cd (directoryNames{i_folder})
    cd ('2_bioh_capteurs')
    
    directory2 = dir('*ECG.mat');
    directoryNames2 = {directory2.name};
    
    for i_folder2 = 1:length(directoryNames2)
        
        load (directoryNames2{i_folder2}) % as ECGfullData
        nameFile = (directoryNames2{i_folder2});
        %
        lengthData = length(ECGfullData);
        lengthDataSec = length(ECGfullData)/250;
        
        timeSecStart = ECGfullData(1,1);
        timeSecEnd = ECGfullData(end,1);
        
        timeStart = compiledsec2humantime(timeSecStart);
        timeEnd = compiledsec2humantime(timeSecEnd);

        diffTimeSeconds = timeSecEnd - timeSecStart;
        epochHours1 = diffTimeSeconds/(60*60); % get the hours,
        epochHours2 = floor(epochHours1); % get the hours,
        epochMinutes1 = (epochHours1 - epochHours2)*60; % get the minutes,
        epochMinutes2 = floor(epochMinutes1); % get the minutes,
        epochSeconds1 = (epochMinutes1 - epochMinutes2)*60; % get the seconds,
        epochSeconds1 = round(epochSeconds1);
        totalDifference = [num2str(epochHours2),':',num2str(epochMinutes2),':',num2str(epochSeconds1)];
        
        varText = [varText sprintf('\nName\t%s\nStartRecording\t%s\nEndRecording\t%s\nStartSecRecording\t%.3f\nEndSecRecording\t%.3f\nLinesNumber\t%d\nSeconds\t%d\nTimeInterval\t%s\n', ...
            nameFile, char(timeStart), char(timeEnd), timeSecStart, timeSecEnd, lengthData, lengthDataSec, char(totalDifference))];
    
    end
    
    cd ../..
    varText = [varText sprintf('\n\n')];
    
end

fileTiming = fopen('fileTiming', 'w+' );
fwrite(fileTiming, varText );
fclose(fileTiming);

% END