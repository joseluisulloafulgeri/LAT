
% timedelayplotbypartseng.m
% run in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/4_workingmatfiles
% differenceTiming files has been computed previously

files = dir('*.mat');
fileNames = {files.name}; % get the name of each file
mainConcat = [];

for i_dataFile = 1:length(files)
    
    load(fileNames{i_dataFile})
    mainConcat = padconcatenation(mainConcat, differenceTiming, 2);

end

%% TO PLOT  - use individually

figure, plot(1:length(mainConcat),mainConcat)
axis([ 0 length(mainConcat) -5000 6000]) % sets the x-axis (first 2) and y-axis (last 2) limits

subsection = mainConcat(1:70,:);
figure, plot(1:length(subsection),subsection)
axis([ 0 length(subsection) -5000 6000]) % sets the x-axis (first 2) and y-axis (last 2) limits

modeValue = mode(subsection, 1);
modeValue = modeValue';

subsectionB = differenceTiming(300:700,:); % exception for specific data
figure, plot(1:length(subsectionB),subsectionB)
%axis([ 0 length(subsection) -5000 6000]) % sets the x-axis (first 2) and y-axis (last 2) limits

% END