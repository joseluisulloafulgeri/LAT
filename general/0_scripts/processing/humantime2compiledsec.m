
function compilSec = humantime2compiledsec(humanTime)
% function to transform human readable time in compiled seconds
% use: humantime2compiledsec('19:17:15') --> ans = 69435
% input: character
% ouput: double

% created: JLUF 03/06/2016
% last update: 03/06/2016

data = strsplit(humanTime,':');
compilSec = str2double(data{1})*(60*60) + str2double(data{2})*60 + str2double(data{3});