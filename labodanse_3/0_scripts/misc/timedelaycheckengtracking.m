
% timedelaycheckengtracking.m
% apply in
%/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Server

% created by JLUF 11/06/2015
% updates:
% JLUF 11/06/2015
% JLUF 23/06/2015

%% variables
folders = {'LD_expMay2015_Day1','LD_expMay2015_Day2','LD_expMay2015_Day3'};
homeFolder = pwd;

%% get into each data-type folder

for i_folder = 1:length(folders)
    
    cd (folders{i_folder})
    cd ('ENG')
    files2 = dir('*.csv');
    fileNames2 = {files2.name}; % get the name of each file
    
    for i_dataFile = 1:length(files2)
        
        localFolder = pwd;
        nameFile = fileNames2{i_dataFile};
        dataFile = importdata(fileNames2{i_dataFile});
        
        % difference time server/tablet
        differenceTiming = dataFile.data(:,2) - dataFile.data(:,1);
        
        destinyPath = '/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/4_workingmatfiles';
        [pathstrFile,nameFile2,extFile] = fileparts(nameFile);
        fullPath = fullfile(destinyPath, nameFile2);

        save(fullPath, 'differenceTiming');
    end
    
    cd ../..
end

%% END