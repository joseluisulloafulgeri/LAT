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
files = dir;
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
        
        [IBItimeseries]= createECGmat_4(filesPathName, dataOfInterest);
    
    end % i_subject
end % i_session 