
function humanTime = compiledsec2humantime(compilSec)
% function to transform compiled seconds in human readable time in a char format
% use: compilsec2humanread(69435) --> ans = '19:17:15'
% input: double
% ouput: character

% created: JLUF 05/01/2015
% last update: 08/01/2015

epochHoursA = compilSec/(60*60); % get the hours,
epochHoursB = floor(epochHoursA); % get the hours,
epochMinutesA = (epochHoursA - epochHoursB)*60; % get the minutes,
epochMinutesB = floor(epochMinutesA); % get the minutes,
epochSecondsA = (epochMinutesA - epochMinutesB)*60; % get the seconds,

humanTime = [num2str(epochHoursB),':',num2str(epochMinutesB),':',num2str(epochSecondsA)];