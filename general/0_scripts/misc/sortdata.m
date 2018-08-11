
function sortdata()
% sortdata.m
% put light files in a folder apart
% apply to the folder containing the folder with the distinct types of data named bh, eng, etc ...

% created by JLUF 04/10/2014
% last update: 08/01/2015

%% 1. get the content of the current folder

files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...

%% 2. get into each data-type folder

for iDir = 1:length(directoryNames)
    
    cd (directoryNames{iDir})
    
    files2 = dir('*.csv');
    directoryNames = {files([files.isdir]).name};
    files2 = files2(3:end);
    fileNames2 = {files2.name}; % get the name of each file
    bytesValue = {files2.bytes}; % get the weight of each file
    
    %% 3. check the type of data and set the threshold accordingly
    
    if regexp(directoryNames{iDir},'bh') > 0;
        % BH files 124 bytes (one line labels)
        threshold = 124;
        
    elseif regexp(directoryNames{iDir},'eng') > 0;
        % ENG files 1400 bytes
        threshold = 1400;
        
    elseif regexp(directoryNames{iDir},'mp') > 0;
        % MP files 200000 bytes        
        threshold = 200000;
        
    elseif regexp(directoryNames{iDir},'ppt') > 0;
        threshold = 500;
        
    elseif regexp(directoryNames{iDir},'tap') > 0;
        threshold = 500;
        
    end
    
    %% 4. check the weight of the data and define bad weight file to put apart
    
    badWeight = cell2mat(bytesValue) <threshold;
        
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
            movefile(fileNames2{badWeight}, 'low_bytes_files')
        end
    end
    cd ..
end

%% END