
% saveHRVfiles.m
% create an HRVstruct to save all files related to the HRV analysis
% apply in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3

% created by JLUF 16/07/2015

%%

% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

% get into each main folder
for i_folder = 1:length(directoryNames)
    
    cd (directoryNames{i_folder})
    fileName = sprintf('HRVstruct_%s' , directoryNames{i_folder});
%     fileNameClean = strrep(fileName,'_','-');
    
    files2 = dir('*.txt');
    directory2Names = {files2.name};
    directory2Names = directory2Names';
    
    baseCell = cell(length(directory2Names), 1);
    All_BeatsOrigi = baseCell;
    All_BeatsProc = baseCell;
    All_Freq1HF = baseCell;
    All_Freq1HRV = baseCell;
    All_Freq1LF = baseCell;
    All_Freq2HF = baseCell;
    All_Freq2HRV = baseCell;
    All_Freq2LF = baseCell;
    All_HRNoInterpOrigi = baseCell; 
    All_HRNoInterpProc = baseCell; 
    All_HRInterp = baseCell;
    All_RROrigi = baseCell; 
    All_RRProc = baseCell; 

    for i_IBI = 1:length(directory2Names)
        
        selection = sprintf('*%0.3d.mat', i_IBI);
        files3 = dir(selection);
        directory3Names = {files3.name};
        directory3Names = directory3Names';
        
        % Beats Origi
        load(directory3Names{1}); All_BeatsOrigi{i_IBI} = BeatsOrigi;
        % Beats Proc
        load(directory3Names{2}); All_BeatsProc{i_IBI} = BeatsProc;
        % Freq Analysis 1, HF
        load(directory3Names{3}); All_Freq1HF{i_IBI} = Freq1HF;
        % Freq Analysis 1, HRV
        load(directory3Names{4}); All_Freq1HRV{i_IBI} = Freq1HRV;
        % Freq Analysis 1, LF
        load(directory3Names{5}); All_Freq1LF{i_IBI} = Freq1LF; 
        % Freq Analysis 2, HF
        load(directory3Names{6}); All_Freq2HF{i_IBI} = Freq2HF;
        % Freq Analysis 2, HRV
        load(directory3Names{7}); All_Freq2HRV{i_IBI} = Freq2HRV;
        % Freq Analysis 2, LF
        load(directory3Names{8}); All_Freq2LF{i_IBI} = Freq2LF;
         % HR Interp
        load(directory3Names{9}); All_HRInterp{i_IBI} = HRInterp;        
        % HR no Interp - Origi
        load(directory3Names{10}); All_HRNoInterpOrigi{i_IBI} = HRNoInterpOrigi;
        % HR no Interp - Proc
        load(directory3Names{11}); All_HRNoInterpProc{i_IBI} = HRNoInterpProc;
        % RR - Origi
        load(directory3Names{12}); All_RROrigi{i_IBI} = RROrigi;
        % RR - Proc
        load(directory3Names{13}); All_RRProc{i_IBI} = RRProc;        
    end
    
    HRsamplingFrequency = 10;
    
    % create the structure
    % structure of the data
    structured_data = struct( ...
        'name', fileName, ...
        'beatsOrigi', {All_BeatsOrigi}, ...
        'beatsProc', {All_BeatsProc}, ...
        'Freq1HF', {All_Freq1HF}, ...
        'Freq1LF', {All_Freq1LF}, ...
        'Freq1HRV', {All_Freq1HRV}, ...
        'Freq2HF', {All_Freq2HF}, ...
        'Freq2LF', {All_Freq2LF}, ...
        'Freq2HRV', {All_Freq2HRV}, ...        
        'HRNoInterpOrigi', {All_HRNoInterpOrigi}, ...
        'HRNoInterpProc', {All_HRNoInterpProc}, ...
        'HRInterp', {All_HRInterp}, ... 
        'HRsamplingRate', HRsamplingFrequency, ...
        'RROrigi', {All_RROrigi}, ...          
        'RRProc', {All_RRProc});
    
    % re-naming the dataset
    string_to_evaluate = [fileName, '=structured_data;'];
    eval(string_to_evaluate);
    
    % save the data
    save (fileName, fileName)
    
    cd ..
end

% END