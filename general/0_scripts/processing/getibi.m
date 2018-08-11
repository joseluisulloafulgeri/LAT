function [IBI, IBIintervals] = getibi(ECGdata)
% USE: extract RR-IBI series from ECG data
% INPUT: ECG segments (currently with a 250 Hz resolution)
% OUTPUT: RR-IBI series

% created: YF, JLUF 18/05/2015
% updates: JLUF 01/07/2015

ECGsignal = ECGdata;

% detection of peaks of derivated ECG according to basic statistic parameters (mean and standard deviation)
diffECGsignal = diff(ECGsignal); % Compute the 1st derivative of raw ECGs
% calculate the mean and standard deviation
meanBeats = nanmean(diffECGsignal);
stdBeats = nanstd(diffECGsignal);
beatThreshold = meanBeats + 2*stdBeats; % minimum beat height to be detected

evenIndex = 2:2:length(diffECGsignal); % sometimes picks are not sharp, trick to make detectable peaks,
diffECGsignal(evenIndex) = diffECGsignal(evenIndex) + 0.5; % add 0.5 to one point on two / no more plateu-looking peaks

% use the function findpeaks to find all the detected peaks in the ECG signal
[~, intervalsIndex] = findpeaks(diffECGsignal,'MinPeakHeight', beatThreshold, 'MinPeakDistance', 100);
intervalsSeconds = intervalsIndex/250; % convert data-points intervals to seconds intervals
intervalsSeconds2 = [0; intervalsSeconds(1 : end-1)];
IBIintervals = (intervalsSeconds - intervalsSeconds2);
IBI = cumsum(IBIintervals); % cumulative sum

% END