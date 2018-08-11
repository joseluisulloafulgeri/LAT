% calculatederivative.m

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

%% Variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
namesMarkers = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};

%% Get the names of the structures

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
    
    
    %% Get data according to the markers
    
    indexMarkers = []; dataAll = cell(1, length(markersOfInterest));
    for i_dance = 1:length(markersOfInterest)
        indexMarkers = find(ismember(FileStruct.mrkTime, markersOfInterest{i_dance}));
        dataAll{i_dance} = FileStruct.data(indexMarkers,:,:); % 1x4 cell
    end
    
    dataByDance = cell(1, length(dataAll));
    for i_dance = 1:length(dataAll)
        
        dataByTypeAndSubj = []; NaNvalues = [];
        for x_subject = 1:size(dataAll{1}, 3) % from one cell of the dataAll variable I get the number of subjects   
            for y_dataType = 1:size(dataAll{1}, 2)% from one cell of the dataAll variable I get the number of dataTypes
                
                dataStep0 = dataAll{i_dance}(:, y_dataType, x_subject); % take the data across all time for a given dataType and subject

                %% Derivative

                dataStep1 = diff(dataStep0);
                dataStep1 = [0; dataStep1];
                
                dataByTypeAndSubj = [dataByTypeAndSubj dataStep1];
            end
        end
        
        %% Reshape
        % dataByTypeAndSubj is e.g. 4230 x 12 [for each subject (6) there are 2 side-by-side columns of data]
        reshapeStep1 = reshape(dataByTypeAndSubj, size(dataByTypeAndSubj, 1)*2, size(dataByTypeAndSubj, 2)/2); % --> 8460 x 6
        
        nlay = 2; % two types of data
        reshapeStep2 = reshape(reshapeStep1', [size(reshapeStep1, 2),size(reshapeStep1, 1)/nlay,nlay]); % -->  6 x 4230 x 2
        reshapeStep3 = permute(reshapeStep2,[2,1,3]); % --> 4230 6 2
        reshapeStep4 = permute(reshapeStep3,[1,3,2]); % --> 4230 2 6
        
        dataByDance{i_dance} = reshapeStep4;
    end
    
    %% Replacing the data file
    
    newData = NaN(size(FileStruct.data, 1), size(FileStruct.data, 2), size(FileStruct.data, 3));
    
    for i_dance2 = 1:length(markersOfInterest)
        %        alter_index_markers = indexMarkers(1)-1 + (1:length(dataByDance{i_dance2}));
        indexMarkers = find(ismember(FileStruct.mrkTime, markersOfInterest{i_dance2}));
        newData(indexMarkers,:,:) = dataByDance{i_dance2}(:,:,:);
    end
    
    FileStruct.data = newData;
    
        %% Comment
    
    FileStruct.processingSteps{size(FileStruct.processingSteps,1)+1} = ['data has been derived on ', date, ' with calculatederivative.m'];
    
    %% Save to the structure
    
    % change directory
    ouputFolder = sprintf('../%s', destinyFolder);
    cd (ouputFolder)
    
    name = sprintf('%s_4', FileStruct.name);
    save(name,'FileStruct');
    
    % change directory
    cd (sourcePath)
            
end

% END
