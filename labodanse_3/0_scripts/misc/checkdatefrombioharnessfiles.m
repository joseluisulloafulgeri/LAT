
% checkdatefrombioharnessfiles.m
% get the timing from bioharness files
% apply in
%/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Server

% created by JLUF 15/06/2015
% updates: 15/06/2015

%% variables
folders = {'LD_expMay2015_Day1','LD_expMay2015_Day2','LD_expMay2015_Day3'};

%% get into each data-type folder

varText = sprintf( '\ntiming checking\n' );

for i_folder = 1:length(folders)
    
    cd (folders{i_folder})
    cd ('BH')
    files2 = dir('*.csv');
    fileNames2 = {files2.name}; % get the name of each file
    bytesValue = {files2.bytes}; % get the weight of each file
    
    for i_dataFile = 1:length(files2)
        
        namesFile = fileNames2{i_dataFile};
        
        dataFile = importbioharnessfile(fileNames2{i_dataFile});
        %dataFile = importdata(fileNames2{i_dataFile});
        
        % timestamp server
        %startRecord = dataFile.data(2,1);
        startRecord = cell2mat(dataFile(2,1));
        roundDataStart1Serv = mat2str(startRecord);
        roundDataStart2Serv = round( str2double(roundDataStart1Serv)/100 ) *100;
        startRecordC = timestamps2humandate2(roundDataStart2Serv, 1);
        %startRecordB = timestamps2humandate2(startRecord, 1);
        
        milisecondsRecoveringStartServ = num2str(roundDataStart2Serv);
        milisecondsRecoveringStartServ2 = milisecondsRecoveringStartServ(:, 11:13);
        milisecondsRecoveringStartServ3 = str2num(milisecondsRecoveringStartServ2); %#ok<ST2NM>
        milisecondsRecoveringStartServ3 = milisecondsRecoveringStartServ3/1000;
        
        milisecondsRecoveringStartServOrigi = roundDataStart1Serv(:, 11:13);
        
        %endRecord = dataFile.data(end, 1);
        endRecord = cell2mat(dataFile(end,1));
        roundDataEnd1Serv = mat2str(endRecord);
        roundDataEnd2Serv = round( str2double(roundDataEnd1Serv)/100 ) *100;
        endRecordC = timestamps2humandate2(roundDataEnd2Serv, 1);
        %endRecordB = timestamps2humandate2(endRecord, 1);
        
        milisecondsRecoveringEndServ = num2str(roundDataEnd2Serv);
        milisecondsRecoveringEndServ2 = milisecondsRecoveringEndServ(:, 11:13);
        milisecondsRecoveringEndServ3 = str2num(milisecondsRecoveringEndServ2); %#ok<ST2NM>
        milisecondsRecoveringEndServ3 = milisecondsRecoveringEndServ3/1000;
        
        milisecondsRecoveringEndServOrigi = roundDataEnd1Serv(:, 11:13);
        
        %lengthData = length(dataFile.data);
        lengthData = length(dataFile);
        
        timingDecompStart = datevec(startRecordC);
        timingDecompEnd = datevec(endRecordC);
        diffTime = timingDecompEnd - timingDecompStart;
        diffHour = diffTime(4); diffHour_Min = diffHour*60;
        diffMin = diffTime(5);
        diffSec =  diffTime(6); diffSec_Min = diffSec/60;
        diffMSec = milisecondsRecoveringEndServ3 - milisecondsRecoveringStartServ3; diffMSec_Min = diffMSec/60;
        sumTime = diffHour_Min + diffMin + diffSec_Min + diffMSec_Min;
        
        % timestamp bioharness
        %startRecordBioharness = dataFile.data(2,3);
        startRecordBioharness = cell2mat(dataFile(2,3));
        roundDataStart1Bioharness = mat2str(startRecordBioharness);
        roundDataStart2Bioharness = round( str2double(roundDataStart1Bioharness)/100 ) *100;
        startRecordCBioharness = timestamps2humandate2(roundDataStart2Bioharness, 1);
        %startRecordBBioharness = timestamps2humandate2(startRecordBioharness, 1);
        
        milisecondsRecoveringStartBioharness = num2str(roundDataStart2Bioharness);
        milisecondsRecoveringStartBioharness2 = milisecondsRecoveringStartBioharness(:, 11:13);
        milisecondsRecoveringStartBioharness3 = str2num(milisecondsRecoveringStartBioharness2); %#ok<ST2NM>
        milisecondsRecoveringStartBioharness3 = milisecondsRecoveringStartBioharness3/1000;
        
        milisecondsRecoveringStartBioharnessOrigi = roundDataStart1Bioharness(:, 11:13);
        
        %endRecordBioharness = dataFile.data(end, 3);
        endRecordBioharness = cell2mat(dataFile(end,3));
        roundDataEnd1Bioharness = mat2str(endRecordBioharness);
        roundDataEnd2Bioharness = round( str2double(roundDataEnd1Bioharness)/100 ) *100;
        endRecordCBioharness = timestamps2humandate2(roundDataEnd2Bioharness, 1);        
        %endRecordBBioharness = timestamps2humandate2(endRecordBioharness, 1);
        
        milisecondsRecoveringEndBioharness = num2str(roundDataEnd2Bioharness);
        milisecondsRecoveringEndBioharness2 = milisecondsRecoveringEndBioharness(:, 11:13);
        milisecondsRecoveringEndBioharness3 = str2num(milisecondsRecoveringEndBioharness2); %#ok<ST2NM>
        milisecondsRecoveringEndBioharness3 = milisecondsRecoveringEndBioharness3/1000;
        
        milisecondsRecoveringEndBioharnessOrigi = roundDataEnd1Bioharness(:, 11:13);        
        
        timingDecompStartBioharness = datevec(startRecordCBioharness);
        timingDecompEndBioharness = datevec(endRecordCBioharness);
        diffTimeBioharness = timingDecompEndBioharness - timingDecompStartBioharness;
        diffHourBioharness = diffTimeBioharness(4); diffHour_MinBioharness = diffHourBioharness*60;
        diffMinBioharness = diffTimeBioharness(5);
        diffSecBioharness =  diffTimeBioharness(6); diffSec_MinBioharness = diffSecBioharness/60;
        diffMSecBioharness = milisecondsRecoveringEndBioharness3 - milisecondsRecoveringStartBioharness3; diffMSec_MinBioharness = diffMSecBioharness/60;
        sumTimeBioharness = diffHour_MinBioharness + diffMinBioharness + diffSec_MinBioharness + diffMSec_MinBioharness;
        
        varText = [varText sprintf('\nfile\t%s\ntime start(serv)\t%s\t%s\t%s\ntime end(serv)\t%s\t%s\t%s\ntime(min)\t%.1f\ntime start(tabl)\t%s\t%s\t%s\ntime end(tabl)\t%s\t%s\t%s\ntime(min)\t%.1f\nlines\t%d\n', ...
            namesFile, char(startRecordC), milisecondsRecoveringStartServ2, milisecondsRecoveringStartServOrigi, char(endRecordC), milisecondsRecoveringEndServ2, milisecondsRecoveringEndServOrigi, sumTimeBioharness, ...
            char(startRecordCBioharness), milisecondsRecoveringStartBioharness2, milisecondsRecoveringStartBioharnessOrigi, char(endRecordCBioharness), milisecondsRecoveringEndBioharness2, milisecondsRecoveringEndBioharnessOrigi, sumTimeBioharness, lengthData)];
        
    end
    cd ../..
    
    varText = [varText sprintf('\n\n')];
    
end

fileTiming = fopen('fileTiming', 'w+' );
fwrite(fileTiming, varText );
fclose(fileTiming);

%% END