
% cleanofmatfile.m
% remove mat files

% created: JLUF 07/08/2015

%% Getting the directory file names

% get names of current directory
%files = dir('*05_14_B');
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2015_05_12_A'...


for i_dir = 1:length(directoryNames)
   
    cd (directoryNames{i_dir})
    
    delete('HRVdata*.mat')
    delete('HRVstruct*.mat')
    
    cd ..
end