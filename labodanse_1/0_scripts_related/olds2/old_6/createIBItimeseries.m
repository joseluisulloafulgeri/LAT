
%% subject
subject = i_subject;

%% generating IBI in milliseconds and rounding the values
IBImilliseconds = IBIintervals*1000;
IBIfloor = floor(IBImilliseconds);

% visual inspection -- plot
% clear title xlabel ylabel
if subject == 1
    yLimitsUpper = 1200;
elseif subject == 2
    yLimitsUpper = 1500;
end
figure, plot(IBIfloor)
ylim([300 yLimitsUpper]); xlabel('samples'); ylabel('IBI [ms]')
title([ '1. raw IBI ' char(infoECGdata{1}(3)) ])

%% taking out extreme values
IBIclean1 = IBIfloor(IBIfloor < 2000);  % first value is outlier, last values as well

% visual inspection -- plot
figure, plot(IBIclean1)
ylim([300 yLimitsUpper]); xlabel('samples'); ylabel('IBI [ms]')
title([ '2. clean IBI ' char(infoECGdata{1}(3)) ])

%% taking out extreme values on the basis of visual inspection
if subject == 1
    IBIclean2 = IBIclean1(1:9786); % value from visual inspection
elseif subject == 2
    IBIclean2 = IBIclean1(1:9786);
end

% visual inspection -- plot
figure, plot(IBIclean2)
ylim([300 1200]); xlabel('samples'); ylabel('IBI [ms]')
title([ '3. clean2 IBI ' char(infoECGdata{1}(3)) ])

% timeline
IBItime = zeros(1,length(IBIclean2));
IBItime(1)= IBIclean2(1);
for i_ibi = 2:length(IBIclean2)
IBItime(i_ibi) = IBIclean2(i_ibi) + IBItime(i_ibi-1);
end
IBItime = IBItime';

% visual inspection -- plot
figure, plot(IBItime, IBIclean2)
ylim([300 1200]); xlabel('time (ms)'); ylabel('IBI [ms]')
title([ '4. clean2 IBI ' char(infoECGdata{1}(3)) ])

% further cleaning
IBIclean3 = IBIclean2;
IBIclean3(IBIclean3 > 900) = NaN;
figure, plot(IBItime, IBIclean3)
ylim([300 1200]); xlabel('time (ms)'); ylabel('IBI [ms]')
title([ '5. clean3 IBI ' char(infoECGdata{1}(3)) ])

IBIclean3(IBIclean3 < 500) = NaN;
figure, plot(IBItime, IBIclean3)
ylim([300 1200]); xlabel('time (ms)'); ylabel('IBI [ms]')
title([ '6. clean4 IBI ' char(infoECGdata{1}(3)) ])

% length data in miliseconds
length_data = IBItime(end);
% creation of a timeline
uniformDataset = NaN(1,length_data);
numberTimeLine = 1:length_data;

% testing if timepoint data exist
[testMember, indexInRounded] = ismember(numberTimeLine, IBItime);

% creating the dataset, resolution is 1000 Hz
for iTimePoint = 1:length(uniformDataset)
    if testMember(iTimePoint);
        uniformDataset(1, iTimePoint) = IBIclean3(indexInRounded(iTimePoint), 1);
    else
        % nothing
    end
end

dataStep0 = uniformDataset;

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

% visual inspection -- plot
figure, plot(1:length(dataStep1b), dataStep1b);
ylim([300 1200]); xlabel('time (ms)'); ylabel('IBI [ms]')
title([ '7. IBI timeseries ' char(infoECGdata{1}(3)) ])

% rounding the values
dataStep2 = floor(dataStep1b);
% visual inspection -- plot
figure, plot(1:length(dataStep1b), dataStep2)
ylim([300 1200]); xlabel('time (ms)'); ylabel('IBI [ms]')
title([ '8. IBI timeseries ' char(infoECGdata{1}(3)) ])

% timeline
timeline = 0:0.001:(length(dataStep2)/1000)-0.001;
timeline2 = bsxfun(@plus, timeline, 59073);
% value '59073' is based on the start time of ECG data for this subject

% selecting the data during the 'performance' period
dataStep3 = dataStep2(find(timeline2 == 61609):find(timeline2 == 64137));
% values are selected based on the marker times in the structure where this subject belongs

figure, plot(dataStep3)
ylim([300 1200]); xlabel('samples'); ylabel('IBI [ms]')
title([ '9. IBI timeseries during dance ' char(infoECGdata{1}(3)) ])

% END