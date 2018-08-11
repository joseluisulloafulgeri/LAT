
% getIBIfromECG.m
% taken as v4 from /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/0_scripts_related/work_in_progress
% USE: extract RR-IBI series from ECG data
% INPUT: *_ECG.csv
% OUTPUT: RR-IBI series
% ROOT: folder containing the bioharness data (data is embedded in a hierarchy of folders)

% so far, to run in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_2

% created: YF, JLUF 18/05/2015
% updates: YF 29/05/2015
% updates: JLUF 01/06/2015
% updates: JLUF 01/07/2015
% updates: JLUF 08/07/2015

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% Getting the directory file names

% get names of current directory
files = dir('ECG*.mat');
% files = dir('ECG*05_12_A*.mat'); 

directoryNames = {files.name};

%% Selecting data type

for i_session = 1:length(directoryNames) % loop for each session
    
    load(directoryNames{i_session})
    [path, nameDirectory,ext]= fileparts(directoryNames{i_session});
    nameDirectory = nameDirectory(1:end-2);
    
    if regexp(FileStruct.name, 'alt') > 0
        markersOfInterest = {'PTB' 'PER' 'PTA'};
    elseif regexp(FileStruct.name, 'Yoga') > 0
        markersOfInterest = {'YTB' 'YOG' 'YTA'};
    elseif regexp(FileStruct.name, '05_12_A') > 0
        markersOfInterest = {'PTB' 'PER' 'PTA'};
    else % regular
        markersOfInterest = {'PER'}; % before was {'PER'}
    end
    
    %markersOfInterest = {'PTB' 'PER' 'PTA'};
    
    for i_mrk = 1:length(markersOfInterest)
        
        % ECGdataSection2 = sscanf(sprintf('%s\v',ECGdataSection{:}),'%f\v');
        lookingIndex = cellfun(@(x) strcmp (x, char(markersOfInterest(i_mrk))), FileStruct.mrkTime, 'UniformOutput', false);
        logicIndex = cell2mat(lookingIndex);
        first_index = find(logicIndex == 1, 1, 'first');
        last_index = find(logicIndex == 1, 1, 'last');
        ECGdata = FileStruct.data (first_index:last_index,:);
        
        % COMPUTING HERE
        IBI = cell(size(ECGdata, 2), 1); % initialize
        IBIintervals = cell(size(ECGdata, 2), 1);
        for i_indiv = 1:size(ECGdata, 2)
            [IBI{i_indiv}, IBIintervals{i_indiv}] = getibi(ECGdata(:,i_indiv));
        end
        
        % checking
        individualDuration = cell(size(ECGdata, 2), 1);
        lastTime = zeros(size(ECGdata, 2), 1);
        for x_time = 1:size(ECGdata, 2)
            lastTime(x_time) = IBI{x_time}(end);
            individualDuration{x_time} = compiledsec2humantime(lastTime(x_time));
        end

        %% Save the IBIs
        
        % change directory
        ouputFolder = sprintf('../%s', destinyFolder);
        cd (ouputFolder)
        
        motherFolderName = sprintf('%s_%s', nameDirectory, char(markersOfInterest(i_mrk)));
        mkdir (motherFolderName)
        
        cd (motherFolderName)
        
        % save the IBIs
        counter = 1;
        for i_IBI = 1:length(IBI)
            
            file_name = sprintf('%s_%s_%0.3d.txt', nameDirectory, char(markersOfInterest(i_mrk)), counter);
            fid = fopen(file_name, 'wt' );
            fprintf(fid,'%.3f \n',IBI{i_IBI});
            fclose(fid);

            file_name2 = sprintf('%s_%s_interv_%0.3d.txt', nameDirectory, char(markersOfInterest(i_mrk)), counter);
            fid = fopen(file_name2, 'wt' );
            fprintf(fid,'%.3f \n',IBIintervals{i_IBI});
            fclose(fid);
            
            counter = counter + 1;
        end
        
        mkdir('intervals')
        movefile('*_interv_*.txt','intervals')
        
        save('LastTimeChecking.mat' , 'lastTime')
        save('IndividualDurationChecking.mat' , 'individualDuration')
        
        cd ..
        
    end % i_mrk
    cd (sourcePath)
    
end % i_session

% END