% sumderivative.m

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

%% Variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
namesMarkers = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};
dataType = {'x' 'y'};

%% Get the names of the structures

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
   
    data = FileStruct.data;
    
    for i_dataType = 1:length(dataType)
    
        data2 = squeeze(data(:,i_dataType,:));
        avgData = nanmean(data2,2);
    
        fieldName = sprintf('summedDerivative%s', dataType{i_dataType});
        FileStruct = setfield(FileStruct, fieldName, avgData);
    end
    
    %% Comment

    FileStruct.processingSteps{size(FileStruct.processingSteps,1)+1} = ['derived data has been summed on ', date, ' with sumderivative.m'];  

    %% Save to the structure

    % change directory
    ouputFolder = sprintf('../%s', destinyFolder);
    cd (ouputFolder)

    name = sprintf('%s_9', FileStruct.name);
    save(name,'FileStruct');

    % change directory
    cd (sourcePath)
         
end

% END