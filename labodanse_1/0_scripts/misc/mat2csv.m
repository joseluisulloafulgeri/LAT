
%% Get the names of the structures

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
    [pathstr,fileNameClean,ext] = fileparts(filesNames{i_struct});
    csvwrite(fileNameClean, allCentrality)
    % next time use 'who'
end