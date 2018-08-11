
% transformdata.m
% USE: interpole NaN values, smooth and normalize the data
% INPUT: structures(with markers)
% OUPUT: structures
% ROOTS: folder containing the structures

% so far, to run in 2_data_analysis/

% created: JLUF 03/12/2014
% last update: 28/01/2015

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

%% Define variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};

%% Get the names of the structures

files = dir('Engagement*.mat'); % 'HRBR*.mat'
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
                
                %% Interpolation
                
                if ~all(isnan(dataStep0)) % if not all are NaN values ...
                    
                    dataStep1 = dataStep0;
                    t = linspace(0.1, 10, numel(dataStep0));
                    % indices to NaN values in x (assumes there are no NaNs in t)
                    nans = isnan(dataStep0);
                    % replace all NaNs in x with linearly interpolated values
                    dataStep1(nans) = interp1(t(~nans), dataStep0(~nans), t(nans));
                    
                    % checking for NaN values
                    dataStep1b = dataStep1;
                    NaNvalues = isnan(dataStep1);
                    
                    if sum(isnan(dataStep1)) > 0; % check for extreme NaN values
                        
                        firstNaN = round(find(NaNvalues == 1, 1,'first')); % first NaN value
                        lastNaN = round(find(NaNvalues == 1, 1,'last')); % last NaN value
                        
                        lengthData = length(dataStep1);
                        if firstNaN == 1 && lastNaN == lengthData % NaN values at both extremes,
                            
                            % fixing the first NaN values
                            halfData = round(length(dataStep1)/2);
                            if ~all(isnan(dataStep1b(1:halfData))) % if not all are NaN values ...
                                dataStep1b(NaNvalues(1:halfData)) = dataStep1(find(isnan(dataStep1(1:halfData)) == 1, 1,'last') +1); % replace by first good value after the last NaN value
                            end
                            
                            % fixing the last NaN values
                            if ~all(isnan(dataStep1b(halfData:end))) % if not all are NaN values ...
                                NaNvalues2 = isnan(dataStep1b);
                                firstNaNb = find(NaNvalues2 == 1, 1,'first');
                                dataStep1b(NaNvalues2) = dataStep1(firstNaNb -1); % replace by last good value after the first NaN value
                            end
                        else
                            if firstNaN == 1; % NaN at the beginning
                                dataStep1b(NaNvalues) = dataStep1(find(NaNvalues == 1, 1,'last') +1); % replace by first good value after the last NaN value
                            else % NaN at the end
                                dataStep1b(NaNvalues) = dataStep1(firstNaN -1); % replace by last good value after the first NaN value
                            end
                        end
                    else
                        % no NaN values
                    end
                else
                    dataStep1b = dataStep0;
                end
                
                %% Smoothing
                if ~all(isnan(dataStep1b))
                    dataStep2 = fastsmooth(dataStep1b,length(dataStep1b)/100,3,1);
                else
                    dataStep2 = dataStep1b;
                end
                %% Normalization
                if ~all(isnan(dataStep2))
                    dataStep3 = dataStep2 - mean(dataStep2(:));
                    dataStep3b = dataStep3/std(dataStep2(:));
                else
                    dataStep3b = dataStep2;
                end
                dataByTypeAndSubj = [dataByTypeAndSubj dataStep3b];
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
    
    FileStruct.processingSteps{size(FileStruct.processingSteps,1)+1} = ['data has been interpolated, smoothed and normalized on ', date, ' with transformdata.m'];
    
    %% Save to the structure
    
    % change directory
    ouputFolder = sprintf('../%s', destinyFolder);
    cd (ouputFolder)
    
    name = sprintf('%s_3', FileStruct.name);
    save(name,'FileStruct');
    
    % change directory
    cd (sourcePath)
    
end

% END