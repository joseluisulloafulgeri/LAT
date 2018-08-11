function [corrMatrix, pValueMatrix] = variableoverlapcorrelation (data, typeCorr, lengthWindow, lengthStep)
% variableoverlapcorrelation.m
% USE: calculate a correlation matrix for the input data using distinct overlapping windows
% INPUT: m(time) x n(data) matrix
% INPUT: typeCorr, 1 is corrcoef, 2 is partialcorr
% INPUT: lengthWindow (in seconds) -- to measure each minute, lengthWindow = 60;
% INPUT: lenghtStep (in seconds) -- to measure each minute, with no overlap, lengthStep = lengthWindow
% OUTPUT: correlation matrix for each time window of interest
% ROOTS: anywhere

% based on movingwindowcorrelation.m
% created: JLUF 09/02/2015
% last update: 09/02/2015

% bioharness data is 1Hz sampling rate

% data
lengthDataMatrix = length(data); % length total of data

% defining the overlap
lengthOverlap = lengthWindow - lengthStep; % degree of overlap given the lengthStep

% defining the number of windows that will be measured
if lengthWindow == lengthStep % no overlap
    nFullWindows = floor( lengthDataMatrix/(lengthWindow - lengthOverlap) ); % e.g. 430/(60 - 0) = ~7 [each min & no overlap]
else
    nFullWindows = floor( (lengthDataMatrix - lengthWindow) / (lengthWindow - lengthOverlap) );
end

currentWindowAnalyzed = 1:lengthWindow; % set the first window of computation, e.g. 1:60

corrMatrix = cell(1, nFullWindows); % initialize
pValueMatrix = cell(1, nFullWindows); % initialize
for i_Window = 1:nFullWindows
    
    if typeCorr == 1; % compute the correlation with corrcoef
        [corrMatrix{i_Window}, pValueMatrix{i_Window}] = corrcoef(data(currentWindowAnalyzed,:));
    elseif typeCorr == 2;  % compute the correlation with partialcorr
        [corrMatrix{i_Window}, pValueMatrix{i_Window}] = partialcorr(data(currentWindowAnalyzed,:));
    else
        % nothing
    end
    
    % set the next window of computation
    currentWindowAnalyzed = currentWindowAnalyzed + lengthStep; % e.g. 61:120
end
