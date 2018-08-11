% Anciennement ...tocreateIBI ! !
%
% getdata2createECGmat.m
% USE : open all the sessions and subjects folders so as to extract RR
% bioharness data with the scrypt createIBItimeseries
% INPUT : its input is the directory of the sessions folder + the directory
% of the folder in which are stored the output files.
% OUTPUT : its output is the ouput of createIBItimeseries.
%
% created by JL for Labodanse
%
% last update : 04 03 15 by YF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Getting the directory file names

% get names of current directory
files = dir('*PM*');
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM' '2014_10_20_PM1'...

%% Selecting data type

directoryNames2 = '2_bioh_capteurs';

for i_session = 1:length(directoryNames) % loop for each session
    
    %% Getting the names of each subject-folder
    
    path3 = fullfile(directoryNames{i_session}, directoryNames2); % generate the path, e.g. 2014_10_20_PM1/6_subj_online/
    files3 = dir(path3);
    directoryNames3 = {files3([files3.isdir]).name}
    directoryNames3 = directoryNames3(~ismember(directoryNames3,{'.','..'})); % e.g. 'A01_846' 'A02_749' ...
    
    for i_subject = 1:length(directoryNames3) % loop for each subject
        
        %% Getting the date of each subject-folder
        
        path4 = fullfile(path3, directoryNames3{i_subject}); % e.g. 2014_10_20_AM/2_bioh_capteurs/A01_846
        files4 = dir (path4);
        directoryNames4 = {files4([files4.isdir]).name};
        directoryNames4 = directoryNames4(~ismember(directoryNames4,{'.','..'})); % e.g. '2014_10_20-09_41_07'
        
        %% Getting the names of each data file of interest
        
        path5 = fullfile(path4, directoryNames4{1});
        files5 = dir (char(path5));
        directoryNames5 = {files5.name}; % e.g. 2014_10_20-09_41_07_Accel.csv 2014_10_20-09_41_07_BB.csv ...
        
        % get 'summary' data
        folderSelectionLogicSummary = ~cellfun(@isempty,regexp(directoryNames5, 'Summary.csv')); % keep those files
        directorySelectionSummary = directoryNames5(folderSelectionLogicSummary);
        pathSummaryData = fullfile(path5, directorySelectionSummary{1});
        
        % get 'RR' data
        folderSelectionLogicRR = ~cellfun(@isempty,regexp(directoryNames5, '_RR.csv')); % keep those files
        directorySelectionRR = directoryNames5(folderSelectionLogicRR)
        pathRRData = fullfile(path5, directorySelectionRR{1})
        
        % get 'ECG' data
        folderSelectionLogicECG = ~cellfun(@isempty,regexp(directoryNames5, '_ECG.csv')); % keep those files
        directorySelectionRR = directoryNames5(folderSelectionLogicECG)
        pathECGData = fullfile(path5, directorySelectionRR{1})
        
        filesPathName = {pathECGData,pathRRData};
        
        dataOfInterest = 2
        
        %% Open RR.csv file so as to see how precise the obtained IBI can be.
        
        %% data
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        % GET INFOS FROM FILE NAME
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %infos = textscan(filesPathName{1},'%s','delimiter','\\');
        infos = textscan(filesPathName{1},'%s','delimiter','//');

        % infos{1}(1): session folder name
        % infos{1}(2): type of data
        % infos{1}(3): subject
        % infos{1}(4): precise date and time
        % infos{1}(5): precise file name
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        % EXTRACTING 'IBI' DATA
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        % sampling frequency of IBIs
        fsECG = 250; % since bioharness sensors has a precision of 1 ms, we use a sampling frequency of 1000Hz (sampling period of 1ms)
        
        % get name of IBI file and infos
        fileName = textscan(filesPathName{2},'%s','Delimiter','.');
        fileNameWithoutExtension = textscan(fileName{1}{1},'%s','Delimiter','_');
        fileType = fileNameWithoutExtension{1}{end}
        
        % open the IBI file
        fid = fopen(filesPathName{2});
        
        % get the IBIs given by the RR file
        fileTabRR = textscan (fid,'%s','Headerlines',1);
        IBIintervals_bioH = str2double(fileTabRR{1}); % convert str mat to double mat
        
        % make a relative timeline for IBIintervals_bioH
        timeLine_IBI_bioH = zeros(1,length( IBIintervals_bioH));
        timeLine_IBI_bioH(1)= 0;
        for i_ibi = 2 : length(IBIintervals_bioH)
            timeLine_IBI_bioH(i_ibi) = IBIintervals_bioH(i_ibi)+timeLine_IBI_bioH(i_ibi-1);
        end
        
        %% OPEN ECG file, and let's process the raw ECG signal so as to extract IBI
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Extract time, data and its 1st derivative from the raw ECG file
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % open the file
        fid = fopen(filesPathName{1});
        headerLines = fgetl(fid);
        hl = textscan(headerLines,'%s','delimiter',',');
        
        % Determine the number of headliners (= columns in the csv file)
        % this methods allows one to open various kind of files with different
        % number of columns. There lay be a simpler way to compute this though.
        
        columnString = '%f/%f/%f%f:%f:%f'; % is a string which will be completed by the next loop.
        % it will be used as an argument in the next textscan function.
        % It corresponds to year/month/day,hours:minutes:seconds.
        for nCol = 1 : length(hl{1})
            columnString = [columnString,'%f64']; % 1st loop: columnString = [date,time,1st column of data name]
        end
        
        % get the name of the data of interest
        dataOfInterestName = hl{1}(dataOfInterest)
        
        % extract the all set of data (not only the data of interest)
        fileTabECG = textscan (fid,columnString,'Delimiter',',');%,'Headerlines',1);
        
        % generate commonSeconds timeline
        timeAxisECG = fileTabECG{4}.*(60*60)+fileTabECG{5}.*60+fileTabECG{6}; % timeAxis in seconds
        timeStartECG = timeAxisECG(1);
        timeEndECG = timeAxisECG(end);
        
        % combine the timeAxis with the data of interest previously extracted from the ECG file in a single
        % matrix
        timeSeriesSOI = [timeAxisECG, fileTabECG{7}]; % 7 is the number of the column of interest, since columns 1 to 6 are related to date and time, while the 8th is a NaN column;
        
        % Create two arrays to identify and use them easily.
        ECGsignal = timeSeriesSOI(:,2);
        ECGtime = timeSeriesSOI(:,1);
        
        % Compute the 1st derivative of raw ECGs
        diffECGsignal = diff(ECGsignal);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Detect the peaks of the ECG first derivative, according to basic statistic parameters, mean and
        % standard deviation :
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Set index in which the mean and standard deviation are calculated
        windowIndex = (floor(length(ECGsignal)*2/10):floor(length(ECGsignal)*8/10)); % The begining (the two first tenth) and the very end of the dataset (the last two tenth) are not used for the analysis : these data may have errors due to movements from publics at the beginning or at the end of the session.
        
        % Compute the mean and standard deviation over the previous index
        sigInWindow = diffECGsignal(windowIndex);
        meanSigInWindow = mean(sigInWindow);
        stdSigInWindow = std(sigInWindow);
        
        % Set the minimum height of a beat to be detected
        beatThreshold = meanSigInWindow + 2*stdSigInWindow;%before it was "+ 1.5*stdSigInWindow;" , now "2" is used instead of 1.5 since it seems to provide better results...%
        
        % Trick to get the flat peaks... It works well
        evenIndex = [2:2:length(diffECGsignal)];
        diffECGsignal(evenIndex)=diffECGsignal(evenIndex)+0.5; % add 0.5 to one point on two... there are no flat spikes anymore.
        
        % Use the function findpeaks to find all the detected peaks in the ECG
        % signal
        [peaksHeight,locsIndex] = findpeaks(diffECGsignal,'MinPeakHeight',beatThreshold,'MinPeakDistance',100);
        
        % Convert locs index in locsSeconds
        locsSeconds = locsIndex / fsECG;
        
        % Compute IBI from the "locsSeconds" array, which contains the time, in seconds, of each
        % detected peaksIndex. Each IBIintervals is therefore the duration between each peaks.
        IBIintervals = (locsSeconds(2:end)-locsSeconds(1:end-1));
        IBIintervalsTime = locsSeconds(2:end); % IBIintervalsTime is the array in which the corresponding time of each intervals is stored.
        
        
        % get infos from the first pass in the findpeaks function
        
        % time information -> to feed the MinPeakDistance parameter of the second
        % findpeaks function
        meanIBIintervals = mean(IBIintervals)
        stdIBIintervals = std(IBIintervals)
        meanIBIintervals_inIndex = meanIBIintervals*fsECG;
        stdIBIintervals = std(IBIintervals)*fsECG;
        minPeakDistance_2ndPass = meanIBIintervals_inIndex - 2*stdIBIintervals %%%%%% here the "2" may need to be adjusted
        
        % peak height information -> to feed the MinPeakHeight parameter of the second
        % findpeaks function
        meanPeakHeight = mean(peaksHeight)
        stdPeakHeight = std(peaksHeight)
        minPeakHeight_2ndPass = meanPeakHeight - 4*stdPeakHeight  %%%%%% here the "4" may need to be adjusted
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 2nd pass in the peak detection function, using IBI mean from the previous
        % steps
        
        % Use the function findpeaks to find all the detected peaks in the ECG
        % signal
        [peaksHeight_2ndPass,locsIndex_2ndPass] = findpeaks(diffECGsignal,'MinPeakHeight',minPeakHeight_2ndPass,'MinPeakDistance',floor(minPeakDistance_2ndPass));
        
        % Convert locs index in locsSeconds
        locsSeconds_2ndPass = locsIndex_2ndPass / fsECG;
        
        % Compute IBI from the "locsSeconds" array, which contains the time, in seconds, of each
        % detected peaksIndex. Each IBIintervals is therefore the duration between each peaks.
        IBIintervals_2ndPass = (locsSeconds_2ndPass(2:end)-locsSeconds_2ndPass(1:end-1));
        IBIintervalsTime_2ndPass = locsSeconds_2ndPass(2:end); % IBIintervalsTime is the array in which the corresponding time of each intervals is stored.
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % parameters evolution between first and second pass through findPeaks..
        minPeakHeight_1stPass = beatThreshold
        minPeakDistance_2ndPass
        minPeakHeight_2ndPass
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Plot both IBI coming from ECG and RR files
        figure,
        subplot(311)
        plot(timeLine_IBI_bioH/1000,IBIintervals_bioH/1000,'m','DisplayName','RR IBI') % ../1000 because IBIintervals_bioH is in [ms]
        ylim([0 2])
        ylabel('time [s]')
        xlabel('time [s]')
        titleStr = ['non sync IBI curve, from RR file, for ',infos{1}(3),', with relative timeline'];
        title(titleStr)
        
        subplot(312)
        plot(locsSeconds(2:end),IBIintervals,'DisplayName','ecgIBI from raw ecg')
        % plot(IBIintervals,'DisplayName','ecgIBI from raw ecg')
        titleStr = ['1st pass : IBI curve, from raw ECG, relative time for ',infos{1}(3)];
        ylim([0 2])
        xlabel('time [s]')
        ylabel('IBI [s]')
        title(titleStr)
        
        subplot(313)
        plot(locsSeconds_2ndPass(2:end),IBIintervals_2ndPass,'DisplayName','ecgIBI from raw ecg')
        % plot(IBIintervals,'DisplayName','ecgIBI from raw ecg')
        titleStr = ['2nd pass : IBI curve, from raw ECG, relative time for ',infos{1}(3)];
        ylim([0 2])
        xlabel('time [s]')
        ylabel('IBI [s]')
        title(titleStr)
        
        %%%%%%%%%
        
        % Plot the obtained IBI and the ECG + detected peak
        % This graph is useful to chech where are the peaks which hasn't been
        % detected, and therefore to set the findpeaks parameters.
        
        % Plot the figure which shows the detected spikes
        figure,
        subplot(211)
        plot(ECGtime(2:end),diffECGsignal)
        hold on
        scatter(locsSeconds + timeStartECG, peaksHeight,'o','r','LineWidth',2)
        ylim([-60 60])
        xlabel('time [s]')
        ylabel('time [s]')
        titleStr = ['1st Pass : 1st derivative of raw ECGsignal + peak detection, absolute time, for : ',infos{1}(3)];
        title(titleStr)
        
        subplot(212)
        plot(locsSeconds(1:end-1) + timeStartECG,IBIintervals)
        ylim([0 2])
        xlabel('time [s]')
        ylabel('time [s]')
        titleStr = ['1st Pass : IBI curve for',infos{1}(3)];
        title(titleStr)
        
        
        %%%%%%%%%
        
        % Plot the obtained IBI and the ECG + detected peak
        % This graph is useful to chech where are the peaks which hasn't been
        % detected, and therefore to set the findpeaks parameters.
        
        % Plot the figure which shows the detected spikes
        figure,
        subplot(211)
        plot(ECGtime(2:end),diffECGsignal)
        hold on
        scatter(locsSeconds_2ndPass + timeStartECG, peaksHeight_2ndPass,'o','r','LineWidth',2)
        ylim([-60 60])
        xlabel('time [s]')
        ylabel('time [s]')
        titleStr = ['2nd Pass : 1st derivative of raw ECGsignal + peak detection, absolute time, for : ',infos{1}(3)];
        title(titleStr)
        
        subplot(212)
        plot(locsSeconds_2ndPass(1:end-1) + timeStartECG,IBIintervals_2ndPass)
        ylim([0 2])
        xlabel('time [s]')
        ylabel('time [s]')
        titleStr = ['2nd Pass : IBI curve for',infos{1}(3)];
        title(titleStr)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % % IBItimeseries = [locsSeconds(1:end-1) + timeStartECG,IBIintervals];
        
        %%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%
        
        
        
    end % i_subject
end % i_session