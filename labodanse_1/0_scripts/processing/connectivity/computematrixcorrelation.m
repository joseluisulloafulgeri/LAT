
% computematrixcorrelation.m
% USE: compute the matrix correlation
% INPUT: structures(with markers)
% OUPUT: matrix
% ROOTS: folder containing the structures

% so far, to run in 2_data_analysis/bioharness/bioharness_2

% created: JLUF 10/02/2015
% last update: 11/02/2015

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

%% Fixed parameters

% dance of interest
markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
markersOfInterestNames = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};
% data of interest
dataType = {'HR' 'BR'};
%dataType = {'x' 'y'};

% correlation type
correlationType = {'1' '2'}; % corrcoef == 1; partialcorr == 2

%% Variable parameters

% set plot
plotType = 2; % 1 = corrmatrix; 2 = network;

% set stats
statsOption = 2; % 0 = no, 1 = stats type 1; 2 = stats type 2;
% corrmatrix: 1 only statitiscal values remain, 2 binarized matrix (1 or 0)
% network: 1 only statitiscal values remain, 2 only statistical and greater than 4 values remain

statsThreshold = 0.05;
statsThresholdName = '05';

%% Get the names of the structures

files = dir('HRBR*.mat');
%files = dir('Engagement*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    session = i_struct;
    % load structures
    load(filesNames{i_struct});
        
    for i_DanceType = 1:length(markersOfInterest)
        
        % set the values of interest according to the dance type
        indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{i_DanceType});
        
        for i_DataType = 1:length(dataType)
            
            % get data
            dataTypeNumber = i_DataType;
            data = FileStruct.data(indexMarkersLogic,dataTypeNumber,:);
            data = squeeze(data);
            
            for i_correlationType = 1:length(correlationType)
                
                
                %% correlation on whole window
                
                % compute correlation matrix
                if i_correlationType == 1;
                    [correlationMatrix, pValueMatrix] = corrcoef(data);
                elseif i_correlationType == 2;
                    [correlationMatrix, pValueMatrix] = partialcorr(data);
                else
                    % nothing
                end
                
                % plotting
                % setting variable to plot
                subjectList = FileStruct.subjectList;
                
                if i_correlationType == 1;
                    corrMethod = 'corrcoef';
                elseif i_correlationType == 2;
                    corrMethod = 'partialcorr';
                else
                    % nothing
                end
                
                TOI = 'wholeW';
                inputFolder = sourcePath;
                outputFolder = sprintf('../%s', destinyFolder);
                
                if plotType == 1
                    % plot
                    plotcorrmatrix( ...
                        correlationMatrix, ...
                        statsOption, pValueMatrix, statsThreshold, statsThresholdName, ...
                        corrMethod, dataType(i_DataType), ...
                        markersOfInterest{i_DanceType}, markersOfInterestNames{i_DanceType}, TOI, ...
                        subjectList, session, inputFolder, outputFolder);
                    
                elseif plotType == 2
                    % plot
                    plotnetwork( ...
                        correlationMatrix, size(data, 2), ...
                        statsOption, pValueMatrix, statsThreshold, statsThresholdName, ...
                        corrMethod, dataType(i_DataType), ...
                        markersOfInterest{i_DanceType}, markersOfInterestNames{i_DanceType}, TOI, ...
                        subjectList, session, inputFolder, outputFolder);
                end
                
                %% correlation on selected windows
                
                % setting variables
                lengthWindow = 60; % in seconds, e.g. 60 sec for 1 Hz data / or in centiseconds, e.g. 600 csec for 10 Hz data
                lengthStep = 10; % in seconds, e.g. 60 sec for 1 Hz data / or in centiseconds, e.g. 600 csec for 10 Hz data
                lengthOverlap = lengthWindow - lengthStep; % degree of overlap given the lengthStep
                
                if lengthWindow == lengthStep % no overlap
                    nFullWindows = floor( length(data)/(lengthWindow - lengthOverlap) ); % e.g. 430/(60 - 0) = ~7 [each min & no overlap]
                else
                    nFullWindows = floor( (length(data) - lengthWindow) / (lengthWindow - lengthOverlap) );
                end
                
                % compute correlation
                [correlationMatrixb, pValueMatrixb] = variableoverlapcorrelation (data, i_correlationType, lengthWindow, lengthStep);
                
                % plotting
                % setting variables to plot
                subjectList = FileStruct.subjectList;
                
                if i_correlationType == 1;
                    corrMethod = 'corrcoef';
                elseif i_correlationType == 2;
                    corrMethod = 'partialcorr';
                else
                    % nothing
                end
                
                inputFolder = sourcePath;
                outputFolder = sprintf('../%s', destinyFolder);
                
                for i_Window = 1:nFullWindows
                    
                    TOI = sprintf('interval%0.3d', i_Window);
                    
                    if plotType == 1
                        % plot
                        plotcorrmatrix( ...
                            correlationMatrixb{i_Window}, ...
                            statsOption, pValueMatrixb{i_Window}, statsThreshold, statsThresholdName, ...
                            corrMethod, dataType(i_DataType), ...
                            markersOfInterest{i_DanceType}, markersOfInterestNames{i_DanceType}, TOI, ...
                            subjectList, session, inputFolder, outputFolder);
                        
                    elseif plotType == 2
                        % plot
                        plotnetwork( ...
                            correlationMatrixb{i_Window}, size(correlationMatrixb{i_Window}, 2), ...
                            statsOption, pValueMatrixb{i_Window}, statsThreshold, statsThresholdName, ...
                            corrMethod, dataType(i_DataType), ...
                            markersOfInterest{i_DanceType}, markersOfInterestNames{i_DanceType}, TOI, ...
                            subjectList, session, inputFolder, outputFolder);
                    end
                end
            end
        end
    end
end
% END