
% this is a template, not a script or function
% created: JLUF 03/01/2015
% last udpate: 08/01/2015

% template header below

% scriptName.m
% script to XXXX
% use:
% should be launched in XXXX
% input: double
% ouput: double

% created: XXXX YY/YY/YYYY
% last udpate: YY/YY/YYYY

close all
clear all

%----------------------files in the current folder-------------------------

% 1. get names of current directory
files = dir('*.csv');
filesNames = {files.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...

for iFiles = 1:length(fileNames)
    % do something   
end

%-------------------------------------------------------------------------

%-------------------------files in 1 sub-folder level----------------------


% 1. get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...

for iDir = 1:length(directoryNames)
    
    cd (directoryNames{iDir})
    files2 = dir('*.csv');
    fileNames2 = {files2.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...
    
    for iFiles2 = 1:length(fileNames2)
        % do something
    end
    cd ..
end

%-------------------------------------------------------------------------

%-------------------------files in 2 sub-folder levels---------------------

% 1. get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...

for iDir = 1:length(directoryNames)
    
    cd (directoryNames{iDir})
    files2 = dir;
    directoryNames2 = {files2([files2.isdir]).name};
    directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
    
    for iDir2 = 1:length(directoryNames2)
        
        cd (directoryNames2{iDir2})
        files3 = dir('*.csv');
        filesNames3 = {files3.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...
        
        for iFile3 = 1:length(filesNames3)
            % do something
        end
        cd ..
    end
    cd ..
end

%-------------------------------------------------------------------------

%-------------------------files in 3 sub-folder levels---------------------

% 1. get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...

for iDir = 1:length(directoryNames)
    
    cd (directoryNames{iDir})
    files2 = dir;
    directoryNames2 = {files2([files2.isdir]).name};
    directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
    
    for iDir2 = 1:length(directoryNames2)
        
        cd (directoryNames2{iDir2})
        files3 = dir;
        directoryNames3 = {files3([files3.isdir]).name};
        directoryNames3 = directoryNames3(~ismember(directoryNames3,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
        
        for iDir3 = 1:length(directoryNames3)
            
            cd (directoryNames3{iDir3})
            files4 = dir('*.csv');
            fileNames4 = {files4.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...
            
            for iFile4 = 1:length(fileNames4)
                % do something
            end
            cd ..
        end
        cd ..
    end
    cd ..
end

%-------------------------------------------------------------------------

%-------------------------files in 4 sub-folder levels---------------------

% 1. get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...

for iDir = 1:length(directoryNames)
    
    cd (directoryNames{iDir})
    files2 = dir;
    directoryNames2 = {files2([files2.isdir]).name};
    directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
    
    for iDir2 = 1:length(directoryNames2)
        
        cd (directoryNames2{iDir2})
        files3 = dir;
        directoryNames3 = {files3([files3.isdir]).name};
        directoryNames3 = directoryNames3(~ismember(directoryNames3,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
        
        for iDir3 = 1:length(directoryNames3)
            
            cd (directoryNames3{iDir3})
            files4 = dir;
            directoryNames4 = {files4([files4.isdir]).name};
            directoryNames4 = directoryNames4(~ismember(directoryNames4,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
            
            for iDir4 = 1:length(directoryNames4)
                
                cd (directoryNames4{iDir4})
                files5 = dir('*.csv');
                fileNames5 = {files5.name}; % e.g. '2014_10_20-09_41_07_Accel.csv' '2014_10_20-09_41_07_BB.csv' ...
                
                for iFile5 = 1:length(fileNames5)
                    % do something
                end
                cd ..
            end
            cd ..
        end
        cd ..
    end
    cd ..
end

%-------------------------------------------------------------------------