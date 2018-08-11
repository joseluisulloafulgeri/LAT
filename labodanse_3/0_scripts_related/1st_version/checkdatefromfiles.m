
% checkdatefromfiles.m
% EX sortdata.m
% get the timing
% apply in
%/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Tablets/labodanse_tablettes_sorted

% created by JLUF 04/10/2014
% last update: 08/01/2015

%% variables
folders = {'104','106','107','108','476','573','719','749','804','810','812','819','825','828','846'};

%% get into each data-type folder

varText = sprintf( '\ntiming checking\n' );

for i_folder = 1:length(folders)
    
    cd (folders{i_folder})
    cd ('ENG')
    files2 = dir('*.csv');
    fileNames2 = {files2.name}; % get the name of each file
    bytesValue = {files2.bytes}; % get the weight of each file
    
    for i_dataFile = 1:length(files2)
        
        namesFile = fileNames2{i_dataFile};
        
        dataFile = importdata(fileNames2{i_dataFile});
        
        startRecord = dataFile.data(1,1);
        startRecordB = timestamps2humandate2(startRecord, 1);
        
        endRecord = dataFile.data(end, 1);
        endRecordB = timestamps2humandate2(endRecord, 1);
        
        lengthData = length(dataFile.data);
        
        timingDecompStart = datevec(startRecordB);
        timingDecompEnd = datevec(endRecordB);
        diffTime = timingDecompEnd - timingDecompStart;
        diffHour = diffTime(4); diffHour_Min = diffHour*60;
        diffMin = diffTime(5);
        diffSec =  diffTime(6); diffSec_Min = diffSec/60;
        sumTime = diffHour_Min + diffMin + diffSec_Min;
        
        timeDataMinutes =  lengthData/600;
        
        varText = [varText sprintf('\nfile\t%s\ntime start\t%s\ntime end\t%s\ntime(min)\t%.1f\nlines\t%d\n', ...
            namesFile, char(startRecordB), char(endRecordB), sumTime, lengthData)];
        
    end
    cd ../..
    
    varText = [varText sprintf('\n\n')];
    
end

fileTiming = fopen('fileTiming', 'w+' );
fwrite(fileTiming, varText );
fclose(fileTiming);

%% END