
% extractcentrality.m
% USE: extract centrality values of each subject in a network
% INPUT: structures(with markers)
% OUPUT: a txt file
% ROOTS: folder containing the structures

% so far, to run in 2_data_analysis/bioharness/bioharness_2

% created: JLUF 31/03/2015
% last update: 31/03/2015

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
                end
                
                %% extraction - step 1
                
                % setting variables
                if i_correlationType == 1;
                    corrMethod = 'corrcoef';
                elseif i_correlationType == 2;
                    corrMethod = 'partialcorr';
                end
                TOI = 'wholeW';
                inputFolder = sourcePath;
                outputFolder = sprintf('../%s', destinyFolder);
                subjectNo = size(data, 2);
                danceType = markersOfInterest{i_DanceType};
                 
                %% extraction - step 2
                
                % transform data if is engagement
                if strcmp(dataType(i_DataType), 'HR') || strcmp(dataType(i_DataType), 'BR')
                    % nothing
                elseif strcmp(dataType(i_DataType), 'x') || strcmp(dataType(i_DataType), 'y')
                    correlationMatrix = padarray(correlationMatrix, [2 2], NaN, 'post'); % add more vectors -- the absent dancers
                    subjectNo = subjectNo + 2;
                end

                %% extraction - step 3
                % S1 and S2 == spectators, S3 == dancers,
                
                centralityValues = (nansum(abs(correlationMatrix), 2));

                %% save
                
                % change directory
                cd (outputFolder)

                % set name
                if strcmp(corrMethod, 'corrcoef')
                    nameData = sprintf('centr_MC1_ses%d_%s_%s_%sdata', session, danceType, TOI, char(dataType(i_DataType)));
                elseif strcmp(corrMethod, 'partialcorr')
                    nameData = sprintf('centr_MC2_ses%d_%s_%s_%sdata', session, danceType, TOI, char(dataType(i_DataType)));
                end

                save(nameData, 'centralityValues');
                
                % change directory
                cd (inputFolder)
                    
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
                
                % setting variables
                if i_correlationType == 1;
                    corrMethod = 'corrcoef';
                elseif i_correlationType == 2;
                    corrMethod = 'partialcorr';
                end
                inputFolder = sourcePath;
                outputFolder = sprintf('../%s', destinyFolder);
                danceType = markersOfInterest{i_DanceType};
                
                
                for i_Window = 1:nFullWindows
                    
                    TOI = sprintf('lag%0.3d', i_Window);
                    subjectNo = size(correlationMatrixb{i_Window}, 2);
                    
                    %% extraction - step 2
                
                    % transform data if is engagement
                    if strcmp(dataType(i_DataType), 'HR') || strcmp(dataType(i_DataType), 'BR')
                        % nothing
                    elseif strcmp(dataType(i_DataType), 'x') || strcmp(dataType(i_DataType), 'y')
                        correlationMatrixb{i_Window} = padarray(correlationMatrixb{i_Window}, [2 2], NaN, 'post'); % add more vectors -- the absent dancers
                        subjectNo = subjectNo + 2;
                    end

                    %% extraction - step 3
                    
                    centralityValues = (nansum(abs(correlationMatrixb{i_Window}), 2));

                    %% save

                    % change directory
                    cd (outputFolder)

                    % set name
                    if strcmp(corrMethod, 'corrcoef')
                        nameData = sprintf('centr_MC1_ses%d_%s_%s_%sdata', session, danceType, TOI, char(dataType(i_DataType)));
                    elseif strcmp(corrMethod, 'partialcorr')
                        nameData = sprintf('centr_MC2_ses%d_%s_%s_%sdata', session, danceType, TOI, char(dataType(i_DataType)));
                    end

                    save(nameData, 'centralityValues');

                    % change directory
                    cd (inputFolder)

                end
                
                
            end
        end
    end
end

% concatenate.m
 
% variables
correlationsMeasures = {'MC1' 'MC2'};
sessions = 1:4;
dataType = {'HR' 'BR'};
%dataType = {'x' 'y'};
markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};

% moving files
cd (outputFolder)
mkdir Lags
movefile('*lag*.mat', 'Lags')

for i_measures = 1:length(correlationsMeasures)
    for i_dataType = 1:length(dataType)
        for i_sessions = 1:length(sessions)
            
            %allCentrality = zeros(length(FileStruct.subjectList), length(markersOfInterest));
            allCentrality = [];
            counter = 1;
            for i_dance = 1:length(markersOfInterest)
            
                file = sprintf('centr_%s_ses%d_%s_wholeW_%sdata.mat', ...
                    correlationsMeasures{i_measures}, i_sessions, markersOfInterest{i_dance}, dataType{i_dataType});
                % open file
                load(file);
                
                allCentrality(:, counter) = centralityValues;
                counter = counter + 1;
                
            end
        
            %save
            nameData = sprintf('allC_%s_ses%d_wholeW_%sdata', ...
            correlationsMeasures{i_measures}, i_sessions, dataType{i_dataType});
            save(nameData, 'allCentrality');
        
        end
    end
end

mkdir All_C
movefile('allC_*.mat', 'All_C')

mkdir WholeW
movefile('*wholeW*.mat', 'WholeW')

% END