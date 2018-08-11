
% cleanBreathingSignal.m
% USE: extract Breathing and clean it
% INPUT: *_Breathing.csv (and later *_BB.csv files)
% OUTPUT: BB/IBI timeseries
% ROOT: folder containing the bioharness data (data is embedded in a hierarchy of folders)

% so far, to run in 1_data_organized/

% created: YF 08/06/2015
% updates:
% updates:

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
    directoryNames3 = {files3([files3.isdir]).name};
    directoryNames3 = directoryNames3(~ismember(directoryNames3,{'.','..'})); % e.g. 'A01_846' 'A02_749' ...

    for i_subject = 1:5 % length(directoryNames3) % loop for each subject

        %% Getting the date of each subject-folder

        path4 = fullfile(path3, directoryNames3{i_subject}); % e.g. 2014_10_20_AM/2_bioh_capteurs/A01_846
        files4 = dir (path4);
        directoryNames4 = {files4([files4.isdir]).name};
        directoryNames4 = directoryNames4(~ismember(directoryNames4,{'.','..'})); % e.g. '2014_10_20-09_41_07'

        %% Getting the names of each data file of interest

        path5 = fullfile(path4, directoryNames4{1});
        files5 = dir (char(path5));
        directoryNames5 = {files5.name}; % e.g. 2014_10_20-09_41_07_Accel.csv 2014_10_20-09_41_07_BB.csv ...

        % get 'BB' data  %%%%%%%%%%%%%%
        folderSelectionLogicBB = ~cellfun(@isempty,regexp(directoryNames5, '_BB.csv')); % keep those files
        directorySelectionBB = directoryNames5(folderSelectionLogicBB);
        pathBBdata = fullfile(path5, directorySelectionBB{1})


        % get 'Breathing' data
        folderSelectionLogicBreathing = ~cellfun(@isempty,regexp(directoryNames5, '_Breathing.csv')); % keep those files
        directorySelectionBB = directoryNames5(folderSelectionLogicBreathing);
        pathBreathingdata = fullfile(path5, directorySelectionBB{1});

        dataOfInterest = 3; %%%%%%%%%%%%%

        % ---- Data processing ----

        %% IBI data

        fsBreathing = 25; % bioharness sensors are 1 Hz, ECG data is 250 Hz, Breathing is 25 Hz %%%%%
        fileName = textscan(pathBBdata,'%s','Delimiter','.');
        fileNameWithoutExtension = textscan(fileName{1}{1},'%s','Delimiter','_');
        fileType = fileNameWithoutExtension{1}{end};
        fid = fopen(pathBBdata); % open the IBI file
        fileTabBB = textscan (fid,'%s','Headerlines',1);
        IBIintervals_bioH = str2double(fileTabBB{1}); % convert str mat to double mat

        % make a relative timeline for IBIintervals_bioH
        timeLine_IBI_bioH = zeros(1,length(IBIintervals_bioH));
        timeLine_IBI_bioH(1)= 0;
        for i_ibi = 2:length(IBIintervals_bioH)
            timeLine_IBI_bioH(i_ibi) = IBIintervals_bioH(i_ibi) + timeLine_IBI_bioH(i_ibi-1);
        end

        %% Breathing data

        infoBreathingdata = textscan(pathBreathingdata,'%s','delimiter','/'); % folder name, data type, subject, date&time, file name
        infoBreathingdata = cellfun (@(x) strrep(x, '_', '-'), infoBreathingdata, 'UniformOutput', false);

        fid = fopen(pathBreathingdata);
        headerLines = fgetl(fid);
        headlinerNb = textscan(headerLines,'%s','delimiter',','); % determine Nb of headliners (= columns in csv file).
        % This method allows us to open various kind of files with different number of columns.
        columnString = '%f/%f/%f%f:%f:%f'; % is a string which will be completed by the next loop. Will be used as an argument in the next textscan function.
        % corresponds to year/month/day,hours:minutes:seconds.
        for nCol = 1 : length(headlinerNb{1})
            columnString = [columnString,'%f64']; % 1st loop: columnString = [date,time,1st column of data name]
        end
        dataOfInterestName = headlinerNb{1}(2); % data of interest label

        fileTabBreathing = textscan (fid,columnString,'Delimiter',',');%'Headerlines',1), % extract the all set of data (not only the data of interest)

        timeAxisBreathing = fileTabBreathing{4}.*(60*60) + fileTabBreathing{5}.*60 + fileTabBreathing{6}; % generate commonSeconds timeline (timeAxis in seconds)
        timeStartBreathing = timeAxisBreathing(1);
        timeEndBreathing = timeAxisBreathing(end);

        timeSeriesSOI = [timeAxisBreathing, fileTabBreathing{7}]; % put together time with data
        % column 7 is the data of interest / columns 1-6 are related to date and time / column 8 are NaNs;
        BreathingSignal = timeSeriesSOI(:,2); Breathingtime = timeSeriesSOI(:,1); % create two arrays to identify and use them easily

        % Process and clean breathing signals
        %
        % Get the coefficient of an IIR high pass filter so as to get rid
        % of noises => mess up the phase of the signals. => See
        % next step for zero-phase filtering

        normalisedCutOffFreq = 0.15/25;         % normalised cutoff frequency for the highpass filter
        filterOrder = 7;
        filterCoefTab = zeros(filterOrder + 1,1);
        [B,A] = butter(filterOrder, normalisedCutOffFreq , 'high')

        % Zero-phase distorsion filtering
        FilteredBreathingSignal=[];
        FilteredBreathingSignal = filtfilt(B,A,BreathingSignal);

        % Set NaN values for unreal peaks and stuffs for signal - mean(signal)...
        NaNThreshold = 15*10^5;
        NaNIndex = find(FilteredBreathingSignal>NaNThreshold);
        FilteredBreathingSignal(NaNIndex) = NaN;

        % findpeaks function

        [breathingPeaksHeight,breathingLocsIndex] =findpeaks(FilteredBreathingSignal,'MinPeakHeight', 2000, 'MinPeakDistance', 30);
        breathingLocsSeconds = breathingLocsIndex / fsBreathing  + timeStartBreathing; % Convert locs index in locsSeconds

        % Compute IBI from the "locsSeconds" array, which contains the time (in seconds) of each detected peaksIndex
        % Each IBI interval is therefore the duration between the peaks
        breathingIBIintervals = [];
        breathingIBIintervals = (breathingLocsSeconds(2:end) - breathingLocsSeconds(1:end-1));
        breathingIBIintervalsTime = breathingLocsSeconds(2:end); % array in which the corresponding time of each intervals is stored.

        % ---- figure ------

        % figure to check the output of the filtering and peak detection steps

        figure,
        subplot(211)
        plot(timeAxisBreathing,BreathingSignal-mean(BreathingSignal) ,'DisplayName','raw signal - mean')
        hold on
        plot(timeAxisBreathing,FilteredBreathingSignal,'k','DisplayName','filtfilt(rawSignal)'),
        scatter(breathingLocsSeconds, breathingPeaksHeight,'o','r','LineWidth',1.2)
        legend('-DynamicLegend')
        xlabel('time [s]');
        ylabel('breathing amp')

        titleStr = ['findpeaks on filtfilt(raw breathing signal) for ', fileName{1}{1}]
        title(titleStr)
        subplot(212)
        plot(breathingIBIintervalsTime,breathingIBIintervals)
        ylabel('time [s]')
        title('homemade breathing IBI')



        % figure to compare home made IBI to bioharness breathing IBI
        figure,
        subplot(211)
        plot(timeLine_IBI_bioH/1000+timeStartBreathing,IBIintervals_bioH/1000,'DisplayName','BioH breathing IBI','DisplayName','BioH breathing IBI')
        legend('-DynamicLegend')
        ylabel('[s]')
        ylim([0 20])
        titleStr = ['Comparison homemade vs bioH breathing IBI for ',fileName{1}{1},]
        title(titleStr)

        subplot(212)
        plot(breathingIBIintervalsTime,breathingIBIintervals,'k','DisplayName','homemade breathing IBI')
        legend('-dynamicLegend')
        ylabel('[s]')
        ylim([0 20])

        pause


    end % i_subject
end % i_session

% END