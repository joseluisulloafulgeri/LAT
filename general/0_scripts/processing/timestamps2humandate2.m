function humanDate = timestamps2humandate2(timeStamps, miliseconds)
% time_stamps_2_human_date.mat
% USE: tranform time stamps to human readable time in string format
% INPUT: double
% OUPUT: string
% if miliseconds = 1, include milseconds
% if miliseconds = 2, do not include miliseconds
% EXAMPLE: timestamps2humandate(1413824999100, 1) --> ans = '20-Oct-2014 17:09:59'
% EXAMPLE: timestamps2humandate(1413824999, 2) --> ans = '20-Oct-2014 17:09:59'

% takes into account corrections that were widespread in a given dataset
% session

% created: JLUF 15/01/2015
% last update: 20/01/2015

if miliseconds,
    convertedTime = datestr((timeStamps+7200000)/86400000 + datenum(1970,1,1)); 
    % instead of 86400 cause taking miliseconds
else
    convertedTime = datestr((timeStamps+7200)/86400 + datenum(1970,1,1));
end

humanDate = cellstr(convertedTime);