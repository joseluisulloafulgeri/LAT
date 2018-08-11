
% checkdatefromengagementfiles.m
% EX sortdata.m
% get the timing
% look into the server, there the engagement files have the information from both the server and the tablet file
% apply in
%/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Server

% created by JLUF 04/10/2014
% last update: 08/01/2015

%% variables
folders = {'LD_expMay2015_Day1','LD_expMay2015_Day2','LD_expMay2015_Day3'};

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
        
        % timestamp server
        startRecord = dataFile.data(1,1);
        roundDataStart1Serv = mat2str(startRecord);
        roundDataStart2Serv = round( str2double(roundDataStart1Serv)/100 ) *100;
        startRecordC = timestamps2humandate2(roundDataStart2Serv, 1);
        %startRecordB = timestamps2humandate2(startRecord, 1);
        
        milisecondsRecoveringStartServ = num2str(roundDataStart2Serv);
        milisecondsRecoveringStartServ2 = milisecondsRecoveringStartServ(:, 11:13);
        milisecondsRecoveringStartServ3 = str2num(milisecondsRecoveringStartServ2); %#ok<ST2NM>
        milisecondsRecoveringStartServ3 = milisecondsRecoveringStartServ3/1000;
        
        milisecondsRecoveringStartServOrigi = roundDataStart1Serv(:, 11:13);
        
        endRecord = dataFile.data(end, 1);
        roundDataEnd1Serv = mat2str(endRecord);
        roundDataEnd2Serv = round( str2double(roundDataEnd1Serv)/100 ) *100;
        endRecordC = timestamps2humandate2(roundDataEnd2Serv, 1);
        %endRecordB = timestamps2humandate2(endRecord, 1);
        
        milisecondsRecoveringEndServ = num2str(roundDataEnd2Serv);
        milisecondsRecoveringEndServ2 = milisecondsRecoveringEndServ(:, 11:13);
        milisecondsRecoveringEndServ3 = str2num(milisecondsRecoveringEndServ2); %#ok<ST2NM>
        milisecondsRecoveringEndServ3 = milisecondsRecoveringEndServ3/1000;
        
        milisecondsRecoveringEndServOrigi = roundDataEnd1Serv(:, 11:13);
        
        lengthData = length(dataFile.data);
        
        timingDecompStart = datevec(startRecordC);
        timingDecompEnd = datevec(endRecordC);
        diffTime = timingDecompEnd - timingDecompStart;
        diffHour = diffTime(4); diffHour_Min = diffHour*60;
        diffMin = diffTime(5);
        diffSec =  diffTime(6); diffSec_Min = diffSec/60;
        diffMSec = milisecondsRecoveringEndServ3 - milisecondsRecoveringStartServ3; diffMSec_Min = diffMSec/60;
        sumTime = diffHour_Min + diffMin + diffSec_Min + diffMSec_Min;
        
        % timestamp tablet
        startRecordTablet = dataFile.data(1,2);
        roundDataStart1Tablet = mat2str(startRecordTablet);
        roundDataStart2Tablet = round( str2double(roundDataStart1Tablet)/100 ) *100;
        startRecordCTablet = timestamps2humandate2(roundDataStart2Tablet, 1);
        %startRecordBTablet = timestamps2humandate2(startRecordTablet, 1);
        
        milisecondsRecoveringStartTablet = num2str(roundDataStart2Tablet);
        milisecondsRecoveringStartTablet2 = milisecondsRecoveringStartTablet(:, 11:13);
        milisecondsRecoveringStartTablet3 = str2num(milisecondsRecoveringStartTablet2); %#ok<ST2NM>
        milisecondsRecoveringStartTablet3 = milisecondsRecoveringStartTablet3/1000;
        
        milisecondsRecoveringStartTabletOrigi = roundDataStart1Tablet(:, 11:13);
        
        endRecordTablet = dataFile.data(end, 2);
        roundDataEnd1Tablet = mat2str(endRecordTablet);
        roundDataEnd2Tablet = round( str2double(roundDataEnd1Tablet)/100 ) *100;
        endRecordCTablet = timestamps2humandate2(roundDataEnd2Tablet, 1);        
        %endRecordBTablet = timestamps2humandate2(endRecordTablet, 1);
        
        milisecondsRecoveringEndTablet = num2str(roundDataEnd2Tablet);
        milisecondsRecoveringEndTablet2 = milisecondsRecoveringEndTablet(:, 11:13);
        milisecondsRecoveringEndTablet3 = str2num(milisecondsRecoveringEndTablet2); %#ok<ST2NM>
        milisecondsRecoveringEndTablet3 = milisecondsRecoveringEndTablet3/1000;
        
        milisecondsRecoveringEndTabletOrigi = roundDataEnd1Tablet(:, 11:13);        
        
        timingDecompStartTablet = datevec(startRecordCTablet);
        timingDecompEndTablet = datevec(endRecordCTablet);
        diffTimeTablet = timingDecompEndTablet - timingDecompStartTablet;
        diffHourTablet = diffTimeTablet(4); diffHour_MinTablet = diffHourTablet*60;
        diffMinTablet = diffTimeTablet(5);
        diffSecTablet =  diffTimeTablet(6); diffSec_MinTablet = diffSecTablet/60;
        diffMSecTablet = milisecondsRecoveringEndTablet3 - milisecondsRecoveringStartTablet3; diffMSec_MinTablet = diffMSecTablet/60;
        sumTimeTablet = diffHour_MinTablet + diffMinTablet + diffSec_MinTablet + diffMSec_MinTablet;
        
        varText = [varText sprintf('\nfile\t%s\ntime start(serv)\t%s\t%s\t%s\ntime end(serv)\t%s\t%s\t%s\ntime(min)\t%.1f\ntime start(tabl)\t%s\t%s\t%s\ntime end(tabl)\t%s\t%s\t%s\ntime(min)\t%.1f\nlines\t%d\n', ...
            namesFile, char(startRecordC), milisecondsRecoveringStartServ2, milisecondsRecoveringStartServOrigi, char(endRecordC), milisecondsRecoveringEndServ2, milisecondsRecoveringEndServOrigi, sumTimeTablet, ...
            char(startRecordCTablet), milisecondsRecoveringStartTablet2, milisecondsRecoveringStartTabletOrigi, char(endRecordCTablet), milisecondsRecoveringEndTablet2, milisecondsRecoveringEndTabletOrigi, sumTimeTablet, lengthData)];
        
    end
    cd ../..
    
    varText = [varText sprintf('\n\n')];
    
end

fileTiming = fopen('fileTiming', 'w+' );
fwrite(fileTiming, varText );
fclose(fileTiming);

%% END