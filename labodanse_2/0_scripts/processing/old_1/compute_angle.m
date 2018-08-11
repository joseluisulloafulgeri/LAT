
% compute_angle.m
% USE: compute angle of data
% INPUT: structures(with markers)
% OUPUT: structures (angle data)
% ROOTS: folder containing the structures

% so far, to run in C:\Users\jose\Documents\OtherProjects\Labodanse\transfering_files_labodanse_2\2_data_analysis\bioharness_2016\bioharness_1
% created: JLUF 18/05/2016, inspired from transformdata.m

%%
destinyFolder = input('Folder name to save the data? > ', 's'); % defining the destiny folder
sourcePath = pwd;
markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'}; % define variables of interest
files = dir('Breathing*.mat'); % get the names of the structures
filesNames = {files.name}; %
FOI = linspace(0.15,0.3,5);
% FOI = logspace(-4,1,10); % frequencies of interest

%% loop

for i_struct = 1:length(filesNames)
    load(filesNames{i_struct}); % load structures
    indexMarkers = []; dataAll = cell(1, length(markersOfInterest));
    for i_dance = 1:length(markersOfInterest)
        indexMarkers = find(ismember(FileStruct.mrkTime, markersOfInterest{i_dance}));
        dataAll{i_dance} = FileStruct.data(indexMarkers,:,:); % 1x4 cell - get data according to the markers
    end
    dataByDance = cell(1, length(dataAll));
    for i_dance = 1:length(dataAll)
        
        dataByTypeAndSubj = []; NaNvalues = [];
        for x_subject = 1:size(dataAll{1}, 2) % from one cell of the dataAll variable I get the number of subjects
            
            dataStep0 = dataAll{i_dance}(:, x_subject); % take the data across all time for a given dataType and subject
            
            %% do time-frequency analysis - wavelet method
            freqList = FOI;
            time = -1:1/FileStruct.samplingFrequency:1; % 1x51
            nCycle = 5;
            % convolution parameters
            nKernel = length(time); % 51
            nData = length(dataStep0); % 15125
            nConv = nKernel+nData-1; % 15175
            nConvPow2 = pow2(nextpow2(nConv)); % 16384
            halfKernel = (nKernel-1)/2; % 25
            % data
            data = dataStep0'; % 15125x1
            freqDomainData = fft(data, nConvPow2); % 16384x1
            
            % FFT-Kernel, FFT-Data + Convolution
            analyticSignal = zeros(length(freqList), nData);
            angleSignal = zeros(length(freqList), nData);
            for i_Freq = 1:length(freqList) % loop for each frequency
                complexMorletWavelets = exp(1i*(2*pi*freqList(i_Freq).*time)) .* exp(-time.^2./(2*(nCycle./(2*pi.*freqList(i_Freq))).^2)); %
                freqDomainKernel = fft(complexMorletWavelets, nConvPow2);
                freqDomainKernel = freqDomainKernel./max(freqDomainKernel); %
                analyticSignalNow = ifft(freqDomainData.*freqDomainKernel); % multipl. in the frequency domain
                analyticSignalNow = analyticSignalNow(1:nConv); % cutting of
                analyticSignal(i_Freq,:) = analyticSignalNow(halfKernel+1:end-halfKernel); % cutting off
                angleSignal(i_Freq,:) = angle(analyticSignal(i_Freq,:)); % 10x15125
            end
            
            dataByTypeAndSubj = [dataByTypeAndSubj angleSignal']; % 15125x80
        end
        
        %% reshape
        dataLength = length(FOI);
        % dataByTypeAndSubj is e.g. 15125 x 80 [for each subject (8) there are 10 side-by-side columns of data]
        reshapeStep1 = reshape(dataByTypeAndSubj, size(dataByTypeAndSubj, 1)*dataLength, size(dataByTypeAndSubj, 2)/dataLength); % --> 151250 x 8
        nlay = dataLength; % ten values
        reshapeStep2 = reshape(reshapeStep1', [size(reshapeStep1, 2),size(reshapeStep1, 1)/nlay,nlay]); % -->  8 x 15125 x 10
        reshapeStep3 = permute(reshapeStep2,[2,1,3]); % --> 15125 8 10
        reshapeStep4 = permute(reshapeStep3,[1,3,2]); % --> 15125 10 8
        dataByDance{i_dance} = reshapeStep4; % DATA IS NOW 10 TIMES (I.E. ANGLES FOR 10 FREQUENCIES) --> 15125 10 8
    end
    
    %% replacing the data file
    newData = NaN(size(FileStruct.data, 1), size(freqList, 2), size(FileStruct.data, 2));
    for i_dance2 = 1:length(markersOfInterest)
        indexMarkers = find(ismember(FileStruct.mrkTime, markersOfInterest{i_dance2}));
        newData(indexMarkers,:,:) = dataByDance{i_dance2}(:,:,:);
    end
    FileStruct.data = newData;
    
    %% comment
    FileStruct.processingSteps{size(FileStruct.processingSteps,1)+1} = ['angles have been computed on ', date, ' with compute_angle.m'];
    
    %% data type
    FileStruct.dataType = 'breathing phase';
    
    %% Frequencies
    FileStruct.freqs = freqList;
    
    %% save to the structure
    ouputFolder = sprintf('../%s', destinyFolder);
    cd (ouputFolder) % change directory
    name = sprintf('%s_3', FileStruct.name);
    save(name,'FileStruct');
    cd (sourcePath) % change directory

end

% END