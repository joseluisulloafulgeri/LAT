
function sortdata2()
% sortdata.m
% put light files in a folder apart
% apply in
%/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Tablets/labodanse_tablettes_sorted

% created by JLUF 04/10/2014
% last update: 08/01/2015

%% variables
folders = {'104','106','107','108','476','573','719','749','804','810','812','819','825','828','846'};

%% get into each data-type folder

for i_folder = 1:length(folders)
    
    cd (folders{i_folder})
    cd ('ENG')
    files2 = dir('*.csv');
    fileNames2 = {files2.name}; % get the name of each file
    bytesValue = {files2.bytes}; % get the weight of each file
    
    %% 4. check the weight of the data and define bad weight file to put apart
    
    badWeight = cell2mat(bytesValue) <100000;
    
    %% 5. create the folder with low bytes files
    
    if exist('low_bytes_files', 'dir') == 0;
        mkdir low_bytes_files
    else
        % nothing
    end
    
    %% 6. move the files there
    
    if all(badWeight) % test whether the logic variable all true values
        % nothing
    else
        for iExport = 1:length(fileNames2)
            if badWeight(iExport)
                movefile(fileNames2{iExport},'low_bytes_files')
            end
        end
    end
    cd ../..
end

%% END