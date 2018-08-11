% createECGmat.m

function ECGmat = createECGmat_4(filesPathName, dataOfInterest)

%% Open RR.csv file so as to see how precise the obtained IBI can be.

%% data
%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INFOS FROM FILE NAME
%%%%%%%%%%%%%%%%%%%%%%%%%%
infos = textscan(filesPathName{1},'%s','delimiter','\\');
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

if dataOfInterest == 2, % From the linked scripts and actual focus : it should be 2 ! ! 

    % get data from the RR file
    fileTabRR = textscan (fid,'%s','Headerlines',1);
    IBIintervals = str2double(fileTabRR{1}); % convert str mat to double mat

elseif dataOfInterest == 3,

    % get the data from the BB file
    fgetl(fid);
    line2getInitialLag = fgetl(fid); % get the IBI value hidden in the 2nd headerlines.
    initialLagStr = textscan(line2getInitialLag,'%s','Delimiter',',');
    initialLag = str2double(initialLagStr{1}(2));
    fileTabRaw = textscan (fid,'%s','Headerlines',2); % get the rest of the data
    IBIintervals = [initialLag; str2double(fileTabRaw{1})]; % convert string to double
end

%% OPEN ECG file, and let's process the raw ECG signal so as to extract IBI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GETTING DURATION OF 'ECG' FILE & EXTRACT DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% combine the timeAxis with the data of interest previously extracted from the ECG file in a single
% matrix
ECGmat = [timeAxisECG, fileTabECG{7+dataOfInterest-2}];
% Since the script only deals with one sigle data of interest,
% only the column of interest is taken,
% with its index 7 + dataOfInterest -2);

ECGsignal = ECGmat(:,2);
ECGtime = ECGmat(:,1);

% Compute the 1st derivative of raw ECGs
diffECGsignal = diff(ECGsignal);

% Detect the peaks of the ECG first derivative, according to basic statistic parameters, mean and
% standard deviation :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set index in which the mean and standard deviation are calculated
windowIndex = (floor(length(ECGsignal)*2/10):floor(length(ECGsignal)*8/10));

% Compute the mean and standard deviation over the previous index
sigInWindow = diffECGsignal(windowIndex);
meanSigInWindow = mean(sigInWindow);
stdSigInWindow = std(sigInWindow);

% Set the minimum height of a beat to be detected
beatThreshold = meanSigInWindow + 1.5*stdSigInWindow;

% Trick to get the flat peaks... It works well
evenIndex = [2:2:length(diffECGsignal)];
diffECGsignal(evenIndex)=diffECGsignal(evenIndex)+0.5; % add 0.5 to one point on two... there are no flat spikes anymore.
 
% Use the function findpeaks to find all the detected peaks in the ECG
% signal
[peaksIndex,locsIndex] = findpeaks(diffECGsignal,'MinPeakHeight',beatThreshold,'MinPeakDistance',0.0010*100000);

% Convert locs index in locsSeconds
locsSeconds = locsIndex / fsECG;

% Compute IBI from the "locsIndex" array, which contains the index of each
% detected peaksIndex
% IBIseconds1stPass = (locsIndex(2:end)-locsIndex(1:end-1))/fsECG;
IBIseconds1stPass = (locsSeconds(2:end)-locsSeconds(1:end-1));

% Plot both IBI coming from ECG and RR files
figure, 
subplot(211)
plot(IBIintervals/1000,'m','DisplayName','RR IBI')
ylim([0 2])
ylabel('time [s]')
xlabel('time [s]')
titleStr = ['non sync IBI curve, from RR file, for ',infos{1}(3),', without time line'];
title(titleStr)

subplot(212)
plot(locsSeconds(2:end),IBIseconds1stPass)
titleStr = ['1st pass : IBI curve, from raw ECG, relative time for ',infos{1}(3)];
ylim([0 2])
xlabel('time [s]')
ylabel('IBI [s]')
title(titleStr)


% Plot the obtained IBI and the ECG + detected peak
% This graph is useful to chech where are the peaks which hasn't been
% detected, and therefore to set the findpeaks parameters.

% Plot the figure which shows the detected spikes
figure, 
subplot(211)
plot(ECGtime(2:end),diffECGsignal)
hold on 
scatter(locsSeconds + timeStartECG, peaksIndex,'o','r','LineWidth',2)
ylim([-60 60])
xlabel('time [s]')
ylabel('time [s]')
titleStr = ['1st Pass : 1st derivative of raw ECGsignal + peak detection, absolute time, for : ',infos{1}(3)];
title(titleStr)

subplot(212)
plot(locsSeconds(1:end-1) + timeStartECG,IBIseconds1stPass)
ylim([0 2])
xlabel('time [s]')
ylabel('time [s]')
titleStr = ['1st Pass : IBI curve for',infos{1}(3)];
title(titleStr)


%% Correct the undetected beats...



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correct the bioharness BB/RR.csv file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A) Detect missed beat :
%%%%%%%%%%%%%%%%%%%%%%%%%

% Find all the peak indexs which are directly surrounded by two values nearly two
% times inferior to it.

% initialisation
IBIintervalsRefilled = IBIseconds1stPass'; % duplicate the IBIintervals array so as to keep the IBIintervals array untouched
IBIintervals = IBIseconds1stPass';

% create two columns, the first one to mark where positive peaks (IBI too long : missed beat) are found
% the second one to mark where negative peaks (IBI too short : too short to be a beat) are found.
IBIintervals = [IBIintervals , zeros(length(IBIintervals),2)];

totalRefil = 0;
totalSuppr = 0;
totalError = 0;

% settings
multipleThreshold = 0.7; % we look for peaks which are 1+multipleThreshold or 2+multipleThreshold or 3+... or 4+...
% superior to the peak's surrounding values.
% See next loops

% loop which compare every IBI, regarding to its direct neighbours.
for i_IBI = 2 : length(IBIintervals)-1

    nRefil = 0; % initialise the number of beat, missed by the sensor, which has to be reincluded in the IBIintervalsRefilled array
    % % % % %     IBIintervalsRefilledCorrected = [];

    for n_refil = 1 : 4 % check if there are peaks which are 2, 3 or 4 times superior, and 3, 4 or 5 times inferior to neighbour values. This method works well but has to be improved.
        % and
        if  IBIintervals(i_IBI)> (n_refil + multipleThreshold)*IBIintervals(i_IBI+1) && ...
                IBIintervals(i_IBI)< (n_refil +1 + multipleThreshold)*IBIintervals(i_IBI+1) && ...
                IBIintervals(i_IBI)> (n_refil + multipleThreshold)*IBIintervals(i_IBI-1) && ...
                IBIintervals(i_IBI)< (n_refil +1 + multipleThreshold)*IBIintervals(i_IBI-1)

            nRefil = n_refil + 1;
            IBIintervals(i_IBI,2)= nRefil;
            %%%%%             index2refil = i_IBI
        end
    end

    if  nRefil > 0 % if the current IBI has been detected as too large

        initialIBIvalue = IBIintervals(i_IBI);
        IBIintervalsRefilled(i_IBI + totalRefil - totalSuppr) = floor(initialIBIvalue/(nRefil)); % (i_IBI+totalRefil) : is used to take into account the increasing length difference between
        % IBIintervalsRefilled and IBIintervals due to undetected beats
        % initialIBIvalue/(nRefil) : we assume that the IBI value is divided linearly by the number of undetected beat.

        for n_refil = 1 : nRefil % loop to refil the IBIintervalsRefilled, for each beat undetected beat
            IBIintervalsRefilled = [IBIintervalsRefilled(1 : i_IBI + totalRefil - totalSuppr) ; floor(initialIBIvalue/(nRefil)); IBIintervalsRefilled(i_IBI + totalRefil - totalSuppr + 1 : end)];
            totalRefil = totalRefil +1;
            totalError = totalError +1;
        end
    end


    % B) Detect wrongly detected beat :
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Find all the peak indexs which are directly surrounded by two values nearly two
    % times superior to it.

    thresholdToSuppr = 1.7;

    if  IBIintervals(i_IBI)< IBIintervals(i_IBI+1)/(thresholdToSuppr) && ...
            IBIintervals(i_IBI)< IBIintervals(i_IBI-1)/thresholdToSuppr

        IBIintervals(i_IBI,3)= -1; % set the third IBIintervals column to -1 so as to rember and plot where an error has been detected

        initialIBIvalue = IBIintervals(i_IBI);
        IBIintervalsRefilled(i_IBI + totalRefil - totalSuppr-1) = IBIintervalsRefilled(i_IBI + totalRefil - totalSuppr-1) + initialIBIvalue; % (i_IBI+totalRefil-1) : is used to take into account the increasing length difference between
        % IBIintervalsRefilled and IBIintervals due to wrongly detected beats.
        % We assume that the current and too short IBI has to be added to the previous IBI.
        % This time, the IBIintervalsRefilled array is shortened, because the current IBI is added to the previous one.
        % This method can be improved.
        IBIintervalsRefilled = [IBIintervalsRefilled(1 : i_IBI + totalRefil - totalSuppr-1) ; IBIintervalsRefilled(i_IBI + totalRefil - totalSuppr +1 : end)];
        totalSuppr = totalSuppr +1;
        totalError = totalError +1;
    end
end % end of the loop done through each IBI point

% Display the number of corrected points
totalError

% Plot graphs of corrected / non corrected peakHeight and peakdistance +
% their respective 1st derivative


    % plot figures to check if errors has been well detected and corrected

    figure,
    subplot(211)
    plot(IBIintervals([1:end],1)/1000-(mean(IBIintervals([1:end],1)/1000)),'b','DisplayName','initial IBIintervals')
    hold on
    plot(IBIintervals([100:end-100],2),'r','DisplayName','detected error, "n" missed beat detected')
    plot(IBIintervals([100:end-100],3),'g','DisplayName','detected error, "1" wrongly detected beat')
    ylim([min(IBIintervals([100:end-100],1)/1000-(mean(IBIintervals([100:end-100],1)/1000))) max(max(IBIintervals([100:end-100],1)/1000-(mean(IBIintervals([100:end-100],1)/1000)),max (IBIintervals([100:end-100],2))))])
    title('where are errors in RR file')

    xlabel('time [s]')
    ylabel('IBIinterval [second]')
    legend('-DynamicLegend')

    subplot(212)
    plot(IBIintervalsRefilled([100:end-100])/1000)
    ylim([min(IBIintervalsRefilled([100:end-100])/1000) max(IBIintervalsRefilled([100:end-100])/1000)])
    xlabel('time [s]')
    ylabel('IBIinterval [second]')
    title('corrected IBIintervals')


% Substitute the refilled array with the initial IBIintervals array
IBIintervals = IBIintervalsRefilled; %
% 
% % How long last the BB file determine the sum of the BB time steps
% IBIfileDurationInMilliSeconds = sum(IBIintervals(:,1))
% 
% % create the time line
% IBIline = zeros(IBIfileDurationInMilliSeconds,1); % IBIline contains as many index as milliseconds
% 
% % generate timeline with the duration of IBI file, and taking the first timepoint of the Summary file
% IBItime = (0:IBIfileDurationInMilliSeconds-1)/ fsIBI; % the IBI time starts at "0" and is shifted later in the script, after the correlation step.
% % create the IBI timeline (IBIline): distribute the IBI intervals in the created timeline
% % one  breathing/heart beat is coded as a '1' in the timeline
% compiledMiliSec = 0;
% 
% IBIsecondsIntervals = zeros(1, length(IBIintervals));
% 
% for ii = 1:length(IBIintervals)
%     compiledMiliSec = compiledMiliSec + IBIintervals(ii); % spread the RR/BB steps along the created time line (one RR/BB event is coded as a '1' in the time line)
%     IBIline(compiledMiliSec) = IBIintervals(ii); % set IBIline to the IBIinteravls value, for each heart/breathing event
%     IBIsecondsIntervals(ii) = compiledMiliSec/fsIBI; % store the time of each heart/breathing event [s]
% end

disp('l.316')

pause


%%


% Analyse the detected peaks so as to give extra parameters
% to compute another peak detection, with more precision :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
sortedPeaks = sortrows(peaksIndex'); % sort peak values in an ascending mode
diffSortedPeaks = diff(sortedPeaks);

sortedIBIindex = sortrows(IBIseconds1stPass'); % sort IBI values in an ascending mode
diffSortedIBIindex = diff(sortedIBIindex); % compute the first derivative of the sorted IBI values
% % 
% % % plot grafs
% % figure, 
% % subplot(211)
% % plot(sortedPeaks,'DisplayName','sortedPeaks');
% % hold on
% % plot(diffSortedPeaks,'r','DisplayName','diffSortedPeaks')
% % title('sortedPeaks')
% % legend('-DynamicLegend')
% % 
% % subplot(212)
% % plot(sortedIBIindex,'DisplayName','sortedIBIindex');
% % hold on
% % plot(diffSortedIBIindex,'r','DisplayName','diffSortedIBIindex');
% % title('sortedIBIindex')
% % legend('-DynamicLegend')
% % 
% % size(windowIndex)
% % size(sortedIBIindex)
% % size(diffSortedIBIindex)
% % 
% % % double plot
% % figure, 
% % ha = plotyy(1:length(sortedIBIindex), sortedIBIindex ,1:length(diffSortedIBIindex), diffSortedIBIindex)
% % 
% % set(ha(1),'ylim',[0 800],'ytick',[0:100 : 800]);
% % set(ha(2),'ylim',[0 10],'ytick',[0:0.5 : 10]);
% % 
% % title('#1) blue = sortedIBIindex, green = diffSortedIBIindex')
% % 
% % 
% % figure, 
% % ha = plotyy(1:length(sortedPeaks), sortedPeaks ,1:length(diffSortedPeaks), diffSortedPeaks)
% % 
% % set(ha(1),'ylim',[2000 3000],'ytick',[2000:100 : 3000]);
% % set(ha(2),'ylim',[0 15],'ytick',[0:0.5 : 10]);
% % 
% % title('#2) blue = sortedPeaks, green = diffSortedPeaks')
% % 
% % 
% % % 2nd pass through findpeaks...
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % % Set the minimum height of a beat to be detected
% % beatThreshold = meanSigInWindow + 2*stdSigInWindow;
% % 
% % % Set the minimum distance between two peaks
% % indexOfMinimumIBI = find(diffSortedIBIindex(1:floor(1/10*(length(diffSortedIBIindex))))>2,1,'last')
% % 
% % if isempty(indexOfMinimumIBI)==1
% %     indexOfMinimumIBI = 1
% % end
% % 
% % minimumIBI = sortedIBIindex(indexOfMinimumIBI)
% %  
% % % Use the function findpeaks to find all the detected peaks in the derivative of raw    ECG
% % % signal
% % [peaksIndex,locsIndex] = findpeaks(diffECGsignal,'MinPeakHeight',beatThreshold,'MINPEAKDISTANCE',minimumIBI);
% % 
% % figure(diffECGfig), 
% % hold on
% % scatter(locsIndex, peaksIndex,'o','k','LineWidth',1)
% % title('test ''2nd'' pass')
% % 
% % % Compute IBI from the locsIndex array, which contains the index of each
% % % detected peaks
% % IBIindex = locsIndex(2:end)-locsIndex(1:end-1);
% % 
% % figure, plot(locsIndex(1:end-1),IBIindex)
% % titleStr = ['2nd pass : IBI curve for',infos{1}(3)]
% % title(titleStr)
% % 
% % 
% % % Analyse the detected peaks so as to give extra parameters
% % % to compute another peak detection, with more precision :
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  
% % sortedPeaks = sortrows(peaksIndex'); % sort peak values in an ascending mode
% % diffSortedPeaks = diff(sortedPeaks);
% % 
% % sortedIBIindex = sortrows(IBIindex'); % sort IBI values in an ascending mode
% % diffSortedIBIindex = diff(sortedIBIindex); % compute the first derivative of the sorted IBI values
% % 
% % % plot grafs
% % figure, 
% % subplot(211)
% % plot(sortedPeaks,'DisplayName','sortedPeaks');
% % hold on
% % plot(diffSortedPeaks,'r','DisplayName','diffSortedPeaks')
% % title('2nd pass : sortedPeaks')
% % legend('-DynamicLegend')
% % 
% % subplot(212)
% % plot(sortedIBIindex,'DisplayName','sortedIBIindex');
% % hold on
% % plot(diffSortedIBIindex,'r','DisplayName','diffSortedIBIindex');
% % title('2nd pass : sortedIBIindex')
% % legend('-DynamicLegend')
% % 
% % size(windowIndex)
% % size(sortedIBIindex)
% % size(diffSortedIBIindex)
% % 
% % figure, 
% % ha = plotyy(1:length(sortedIBIindex), sortedIBIindex ,1:length(diffSortedIBIindex), diffSortedIBIindex)
% % 
% % set(ha(1),'ylim',[0 800],'ytick',[0:100 : 800]);
% % set(ha(2),'ylim',[0 10],'ytick',[0:0.5 : 10]);
% % 
% % title('2nd pass : #1) blue = sortedIBIindex, green = diffSortedIBIindex')
% % 
% % %%%
% % 
% % figure, 
% % ha = plotyy(1:length(sortedPeaks), sortedPeaks ,1:length(diffSortedPeaks), diffSortedPeaks)
% % 
% % set(ha(1),'ylim',[2000 3000],'ytick',[2000:100 : 3000]);
% % set(ha(2),'ylim',[0 15],'ytick',[0:0.5 : 10]);
% % 
% % title('2nd pass : #2) blue = sortedPeaks, green = diffSortedPeaks')
% % 
% % %% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % % 
% % % % %%%%% SAME TEST WITH RESAMPLED DATA ! ! ! ! ! !
% % % % 
% % % % 
% % % % fs =  250
% % % % fsResamp = 4;
% % % % [P1,Q1] = rat(fsResamp/fs); 
% % % % 
% % % % resampleECGsignal = resample(diffECGsignal, P1, Q1);
% % % % 
% % % % tResamp = (0:numel(resampleECGsignal)-1) / fsResamp;
% % % % trucResampleECGsignal = sgolayfilt(resampleECGsignal,1,17);
% % % % figure
% % % % plot(tResamp,resampleECGsignal,'r');
% % % % 
% % % % 
% % % % 
% % % % %%%%%%%%%%%%
% % % % 
% % % % % Detect the peaks according to basic statistic parameters, mean and
% % % % % standard deviation :
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % 
% % % % 
% % % % diffECGsignal = resampleECGsignal
% % % % 
% % % % 
% % % % windowIndex = (floor(length(diffECGsignal)*5/10):floor(length(diffECGsignal)*7/10));
% % % % sigInWindow = diffECGsignal(windowIndex);
% % % % maxSigInWindow = max((sigInWindow))
% % % % meanSigInWindow = mean(sigInWindow)
% % % % stdSigInWindow = std(sigInWindow)
% % % % 
% % % % % Set the minimum height of a beat to be detected
% % % % beatThreshold = meanSigInWindow + 3*stdSigInWindow;
% % % %  
% % % % % Use the function findpeaks to find all the detected peaks in the ECG
% % % % % signal
% % % % [peaksIndex,locsIndex] = findpeaks(diffECGsignal,'MinPeakHeight',beatThreshold);
% % % % 
% % % % % Compute IBI from the locsIndex array, which contains the index of each
% % % % % detected peaks
% % % % IBIindex = locsIndex(2:end)-locsIndex(1:end-1);
% % % % 
% % % % % Analyse the detected peaks so as to give extra parameters
% % % % % to compute another peak detection, with more precision :
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %  
% % % % sortedPeaks = sortrows(peaksIndex'); % sort peak values in an ascending mode
% % % % diffSortedPeaks = diff(sortedPeaks);
% % % % 
% % % % sortedIBIindex = sortrows(IBIindex'); % sort IBI values in an ascending mode
% % % % diffSortedIBIindex = diff(sortedIBIindex); % compute the first derivative of the sorted IBI values
% % % % 
% % % % % plot grafs
% % % % figure, 
% % % % subplot(211)
% % % % plot(sortedPeaks,'DisplayName','sortedPeaks');
% % % % hold on
% % % % plot(diffSortedPeaks,'r','DisplayName','diffSortedPeaks')
% % % % title('sortedPeaks')
% % % % legend('-DynamicLegend')
% % % % 
% % % % subplot(212)
% % % % plot(sortedIBIindex,'DisplayName','sortedIBIindex');
% % % % hold on
% % % % plot(diffSortedIBIindex,'r','DisplayName','diffSortedIBIindex');
% % % % title('sortedIBIindex')
% % % % legend('-DynamicLegend')
% % % % 
% % % % size(windowIndex)
% % % % size(sortedIBIindex)
% % % % size(diffSortedIBIindex)
% % % % 
% % % % 
% % % % figure, 
% % % % ha = plotyy(1:length(sortedIBIindex), sortedIBIindex ,1:length(diffSortedIBIindex), diffSortedIBIindex)
% % % % 
% % % % set(ha(1),'ylim',[0 800],'ytick',[0:100 : 800]);
% % % % set(ha(2),'ylim',[0 10],'ytick',[0:0.5 : 10]);
% % % % 
% % % % title('#1) blue = sortedIBIindex, green = diffSortedIBIindex')
% % % % 
% % % % 
% % % % %%%
% % % % 
% % % % figure, 
% % % % ha = plotyy(1:length(sortedPeaks), sortedPeaks ,1:length(diffSortedPeaks), diffSortedPeaks)
% % % % 
% % % % set(ha(1),'ylim',[2000 3000],'ytick',[2000:100 : 3000]);
% % % % set(ha(2),'ylim',[0 15],'ytick',[0:0.5 : 10]);
% % % % 
% % % % title('#2) blue = sortedPeaks, green = diffSortedPeaks')
% % % % 
% % % % 
% % % % %%%%%%%%%%%%
% % % % 
% % % % 
% % % % 
% % % % % % % % % % %% Compute heart rate
% % % % % % % % % % Fs1 = 1000
% % % % % % % % % % Fs = 1
% % % % % % % % % % 
% % % % % % % % % % window = 3*Fs1;
% % % % % % % % % % noverlap = window - Fs1/Fs;
% % % % % % % % % % Nfft = 2048*2;
% % % % % % % % % % % for hh=1:nSession
% % % % % % % % % % %     for jj=1:nSet,
% % % % % % % % % % %         ecg=dataRaw(:,3,jj,hh)-mean(dataRaw(:,3,jj,hh));
% % % % % % % % % %         
% % % % % % % % % % ecg = ECGmat(:,2);
% % % % % % % % % % 
% % % % % % % % % % Y = buffer(ecg,window,noverlap);
% % % % % % % % % %         Y = abs(fft(Y,Nfft));
% % % % % % % % % %         Y=Y(1:Nfft/2,:);
% % % % % % % % % %         bpm = ViterbiSmoothing(Y(60:260,:), 0.07, 2);
% % % % % % % % % % 
% % % % % % % % % % %         if plotHeartRate == 1
% % % % % % % % % %             figure, imagesc(20*log10(abs(Y))); axis xy; colormap(flipud(pink));hold on
% % % % % % % % % % %             subplot(2,1,1)
% % % % % % % % % %             figure, plot(bpm+60,'k'); hold off
% % % % % % % % % %             title('HeartRate')
% % % % % % % % % % %         end
% % % % % % % % % % 
% % % % % % % % % % 
% % % % % % % % % % 
% % % % % % % % % % %                 for ii=1:length(indSync1)
% % % % % % % % % % %                     subplot(2,1,2)
% % % % % % % % % % %                     plot([(indSync1(ii)) (indSync1(ii))],[-5 5])
% % % % % % % % % % %                     hold on
% % % % % % % % % % %                 end
% % % % % % % % % % 
% % % % % % % % % % %         data(:,3,jj,hh)= (bpm+60-1)*Fs1*60/(2*(Nfft/2));
% % % % % % % % % % %     end
% % % % % % % % % % % end
% % % % 
