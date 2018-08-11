
% compute_angle_clustering.m
% USE: compute angle clustering in time
% INPUT: structures (angle data)
% OUPUT: structures (phase clustering values, i.e., connectivity matrices)
% ROOTS: folder containing the structures

% so far, to run in C:\Users\jose\Documents\OtherProjects\Labodanse\transfering_files_labodanse_2\2_data_analysis\bioharness_2016\bioharness_2
% created: JLUF 12/12/2016, inspired from compute_angle.m

%%
destinyFolder = input('Folder name to save the data? > ', 's'); % defining the destiny folder
sourcePath = pwd;
markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'}; % define variables of interest
files = dir('Breathing*.mat'); % get the names of the structures
filesNames = {files.name}; %
FOI = linspace(0.15,0.3,5);
halfCyclePerFreq = 1.5;

%% loop

for i_struct = 1:length(filesNames)
    
    load(filesNames{i_struct}); % load structures
    indexMarkers = [ ]; dataAll = cell(1, length(markersOfInterest));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i_dance = 1:length(markersOfInterest)
        indexMarkers = find(ismember(FileStruct.mrkTime, markersOfInterest{i_dance})); % 17475 1
        dataAll{i_dance} = FileStruct.data(indexMarkers,:,:); % 1x4 cell - get data according to the markers
    end
    dataByDance = cell(1, length(dataAll));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    phaseClustAllDanses = cell(1, length(dataAll)); % 1x4 cell
    phaseClustAllDanses2 = cell(1, length(dataAll)); % 1x4 cell
    
    for i_dance = 1:length(dataAll)
        
        phaseClustPerFreq = cell(1, length(FOI)); % 1x5 cell
        subjCombiMatrix = nchoosek(1:size(dataAll{i_dance}, 3),2);
        dataSetOneDanseAllFreq = NaN(size(dataAll{i_dance}(:, :, :), 1), length(subjCombiMatrix), length(FOI));
        % 15125 8 5
        
        for i_freq = 1:length(FOI)
            
            % parameters
            timeWindowIdx = round((1000/FOI(i_freq)) * halfCyclePerFreq / (1000/FileStruct.samplingFrequency)); %
            dataAllSubj = squeeze(dataAll{i_dance}(:, i_freq, :)); % take the data across all time for a given dataType and subject
            
            % compute phase differences for all combinations of couples
            phaseDiff = zeros(size(dataAll{i_dance}(:, :, :), 1), length(subjCombiMatrix));
            for i_comb = 1:length(subjCombiMatrix)
                phaseDiff(:, i_comb) =  dataAllSubj(:, subjCombiMatrix(i_comb, 1)) - dataAllSubj(:, subjCombiMatrix(i_comb, 2));
            end
            
            % compute phase clustering in time for all combinations of couples
            dataSetOneDanseOneFreq = NaN(length(phaseDiff), size(phaseDiff, 2));
            % phaseClust = zeros(length(phaseDiff)-timeWindowIdx-timeWindowIdx, size(phaseDiff, 2));
            for i_comb = 1:size(phaseDiff, 2)
                i_position = timeWindowIdx + 1;
                 for i_time = 1:length(phaseDiff)-timeWindowIdx-timeWindowIdx
                    % phaseClust(i_time, i_comb) = abs(mean(exp(1i*phaseDiff(timeWindowIdx+i_time : timeWindowIdx+i_time-1+timeWindowIdx, i_comb)), 1));
                    dataSetOneDanseOneFreq(i_position, i_comb) = abs(mean(exp(1i*phaseDiff(timeWindowIdx+i_time : timeWindowIdx+i_time-1+timeWindowIdx, i_comb)), 1));
                    i_position = i_position + 1;
                end
            end
            
            phaseClustPerFreq{i_freq} = dataSetOneDanseOneFreq;
            dataSetOneDanseAllFreq(:, :, i_freq) = dataSetOneDanseOneFreq;
            
        end
                
        phaseClustAllDanses{i_dance} = phaseClustPerFreq;
        phaseClustAllDanses2{i_dance} = dataSetOneDanseAllFreq;
        
    end
 
   FileStruct.data = phaseClustAllDanses;
   FileStruct.data2 = phaseClustAllDanses2;
   
    %% comment
    FileStruct.processingSteps{size(FileStruct.processingSteps,1)+1} = ['angle clustering have been computed on ', date, ' with compute_angle_clustering.m'];
    
    %% data type
    FileStruct.dataType = 'phase clustering';
    
    %% pair combinations
    FileStruct.pairsComb = subjCombiMatrix;
    
    %% save to the structure
    ouputFolder = sprintf('../%s', destinyFolder);
    cd (ouputFolder) % change directory
    name = sprintf('%s_4', FileStruct.name);
    save(name, 'FileStruct');
    cd (sourcePath) % change directory 
    
end

% END