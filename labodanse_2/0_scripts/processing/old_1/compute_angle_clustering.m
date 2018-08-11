
% compute_angle_clustering.m
% USE: compute angle clustering in time
% INPUT: structures (angle data)
% OUPUT: structures (connectivity matrices)
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
% FOI = logspace(-4,1,10); % frequencies of interest
halfCyclePerFreq = 1.5;

%% loop

phaseDiff = [];
for i_struct = 1:length(filesNames)
    
    load(filesNames{i_struct}); % load structures
    indexMarkers = []; dataAll = cell(1, length(markersOfInterest));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i_dance = 1:length(markersOfInterest)
        indexMarkers = find(ismember(FileStruct.mrkTime, markersOfInterest{i_dance}));
        dataAll{i_dance} = FileStruct.data(indexMarkers,:,:); % 1x4 cell - get data according to the markers
    end
    dataByDance = cell(1, length(dataAll));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    phaseClustperDanse = cell(1, length(dataAll));
    
    for i_dance = 1:length(dataAll)
        
        phaseClustperFreq = cell(1, length(FOI));
        for i_freq = 1:length(FOI)
            
            % parameters
            timeWindowIdx = round((1000/FOI(i_freq)) * halfCyclePerFreq / (1000/FileStruct.samplingFrequency)); %
            dataByTypeAndSubj = []; NaNvalues = [];
            subjCombiMatrix = nchoosek(1:size(dataAll{1}, 3),2);
            dataAllSubj = squeeze(dataAll{i_dance}(:, i_freq, :)); % take the data across all time for a given dataType and subject
            
            % compute phase differences for all combinations of couples
            phaseDiff = [];
            for i_comb = 1:length(subjCombiMatrix)
                phaseDiff =  [phaseDiff dataAllSubj(:, subjCombiMatrix(i_comb, 1)) - dataAllSubj(:, subjCombiMatrix(i_comb, 2))];
            end
            
            % compute phase clustering in time for all combinations of couples            
            phaseClust = zeros(length(phaseDiff)-timeWindowIdx-timeWindowIdx, size(phaseDiff, 2));
            for i_comb = 1:size(phaseDiff, 2)
                for i_time = 1:length(phaseDiff)-timeWindowIdx-timeWindowIdx
                    phaseClust(i_time, i_comb) = abs(mean(exp(1i*phaseDiff(timeWindowIdx+i_time : timeWindowIdx+i_time-1+timeWindowIdx, i_comb)), 1));
                end
            end
            
            phaseClustperFreq{i_freq} = phaseClust;
            
        end
                
        phaseClustperDanse{i_dance} = phaseClustperFreq;
        
    end
 
    
    
end
