
% script that extract and synchronize bioharness data, and put it into a structure
% created: YF 06/10/2014; modified: JLUF 12/10/2014
% to run in 1_data_organized/
% needs a 2_data_analysis folder inside ../ relative to 1_data_organized
% input: a set of folders in 1_data_organized/
% output: a set of structure-files in 2_data_analysis

% remember the data is organized as follows:
% example: 1_data_organized/2014_10_20_AM/2_bioh_capteurs/A01_846/2014_10_20-09_41_07/2014_10_20-09_41_07_Summary.csv
% where you can find the distinct directory levels. Since we start in 1_data_organized, the first directory level give us 
% the name of the folders in 1_data_organized, which are for instance 2014_10_20_AM; 2014_10_20_PM1; 2014_10_21_PM2, ... etc.
% Thus, for our data, the directory levels are:
% 1_data_organized = dir_level_1
% 2014_10_20_AM = dir_level_2 --> the sessions
% 2_bioh_capteurs = dir_level_3 --> the data-types
% A01_846 = dir_level_4 --> the subjects
% 2014_10_20-09_41_07 = dir_level_5, (which is the date) where you can find our data-files of interest, e.g. 2014_10_20-09_41_07_Summary.csv

% checking time
tStart = tic;

%% 0. pre-defined variables

% the dir_level_2 is pre-defined because we established an organization of folders for each session,
dir_level_2 = {'1_eeg' '2_bioh_capteurs' '3_bioh_online' '4_bioh_tablette' '5_subj_offline' ...
    '6_subj_online' '7_questionnaire' ' 8_time_distort'};


%% 1. getting the directory file names

dir_level_1 = dir; % first we get in the first directory,
dir_level_1 = dir_level_1(3:end); % we get ride of '.' and '..',

folders_level_1 = {};
for i_level_1 = 1 : length(dir_level_1)
    folders_level_1{i_level_1} = [dir_level_1(i_level_1).name]; % e.g. 2014_10_20_AM; 2014_10_20_PM1; 2014_10_21_PM2, etc ...
end

%% 2. selecting data type

% for the moment we are interested in the bioh data,
% next step is to make a loop with all the types of data
data_type = '2_bioh_capteurs';
dir_level_2 = data_type; % in this case the dir_level_2 is identical to the type of data we want to retrieve,

for x_sessions = 1:length(folders_level_1) % HERE start the loop for each session
    
    %% 3. getting the names of each subject-folder within each session/data_type
    
    path_level_3 = fullfile(folders_level_1{x_sessions}, dir_level_2); % generate the path, e.g. 2014_10_20_AM/2_bioh_capteurs/
    dir_level_3 = dir(path_level_3);
    dir_level_3 = dir_level_3(3:end); % we get ride of '.' and '..',
    
    folders_level_3 = {};
    for x_level_3 = 1 : length(dir_level_3)
        folders_level_3{x_level_3} = [dir_level_3(x_level_3).name]; % e.g. A01_846, A02_749, A03_810, etc ...
    end
    
    data_time_seconds_mat = {}; timeline_min = []; timeline_max = []; data_first_step = {};
    
    for i_subject = 1:length(folders_level_3) % HERE start the loop for each subject
        
        %% 4. getting the date of each subject-folder
        
        path_level_4 = fullfile(path_level_3, folders_level_3{i_subject}); % e.g. 2014_10_20_AM/2_bioh_capteurs/A01_846
        dir_level_4 = dir (path_level_4);
        date_4_level = dir_level_4(3).name; % the date within each subject-folder, e.g. 2014_10_20-09_41_07
        % date_4_level is at the same time the directory by which we access the data,
        dir_level_4 = date_4_level;
        
        %% 5. getting the names of each file within a subject-folder/date
        
        path_level_5 = fullfile(path_level_4, dir_level_4);
        dir_level_5 = dir (path_level_5);
        dir_level_5 = dir_level_5(3:end-1); % until end-1 because in addition to '.' and '..', there is 'no_scv_files'
        
        folders_level_5 = {};
        for y_level_5 = 1 : length(dir_level_5)
            folders_level_5{y_level_5} = [dir_level_5(y_level_5).name]; % e.g. 2014_10_20-09_41_07_Accel.csv, 2014_10_20-09_41_07_BB.csv etc...
        end
        
        %% 6. getting a specific kind of data within subject-folder/data, e.g. Summary
        
        % for the moment we are interested in the 'Summary' data,
        target_file = 'Summary';
        
        for i_search = 1:length(folders_level_5)
            if regexp(folders_level_5{i_search},target_file) > 1 % search the target_file within the directory and returns the index
                index_target = i_search;
            else
                % nothing
            end
        end
        
        %% 7. defining the name and paths to the target data-file
        name_file_target = folders_level_5{index_target};
        path_target_file = fullfile(path_level_5, name_file_target);
        
        all_path_target_files{i_subject} = path_target_file;
        
        %% 8. opening the data-file
        
        imported_data = importdata(path_target_file); % import the dataset associated with the target_file
        % the 'importdata' function generates a structure with 2 fields:
        % one associated with numerical data, and another with text,
        % imported_data.textdata give us the labels, and in our case the first column with the dates
        % imported_data.data give us the numerical data, attention! in our case all data is shifted one colum to the left
        % because the timeline is not included here, see below
        
        %% 9. gathering time info of each subject
        
        time_data = imported_data.textdata(2:end,1); % from 2 to exclude the label / 1 because first column is time,
        
        full_date = {};
        for y_date = 1:length(time_data)
            full_date{y_date} = strsplit(time_data{y_date}); % 
        end
        
        segmented_date = {}; data_time_seconds = {};
        for xo_date = 1:length(time_data)
            segmented_date{xo_date} = strsplit(full_date{:,xo_date}{1,2},':');
            data_time_seconds{xo_date} = str2num(segmented_date{xo_date}{1})*60*60 + str2num(segmented_date{xo_date}{2})*60 + str2num(segmented_date{xo_date}{3});
        end
        
        % we save the timelines of each subject
        data_time_seconds_mat{i_subject} = cell2mat(data_time_seconds);
        
        % we save the minimal timepoint of the timeline for each subject
        timeline_min(i_subject) = data_time_seconds_mat{i_subject}(1);
        % we save the maximal timepoint of the timeline for each subject
        timeline_max(i_subject) = data_time_seconds_mat{i_subject}(end);
        
        %% 10. gathering the data from each subject
        
        % which data? --> 'Time','HR','BR','HRConfidence','HRV','CoreTemp'
        data_of_interest = {'Time','HR','BR','HRConfidence','HRV','CoreTemp'};
        
        % we recover the data of time, which the function 'importdata' put elsewhere,
        data_all = [data_time_seconds_mat{i_subject}' imported_data.data];
        
        % we create a logic vector which indicate the index of the data we want to retrieve,
        index_selection = ismember(imported_data.textdata(1,:), data_of_interest);
        
        % get save the data in a cell array
        data_first_step{i_subject} = data_all(:, index_selection);
        
    end
    
    % across all subjects we find the minimal and maximal common timepoints,
    [common_min_time, min_time_subject_index] = max(timeline_min);
    [common_max_time, max_time_subject_index] = min(timeline_max);
    
    % for the data of each subject we select the dataset that lay between the common minimal and maximal datapoints
    for oi_subjects = 1:length(folders_level_3)
        min_time_index(oi_subjects) = find(data_time_seconds_mat{oi_subjects} >= common_min_time, 1, 'first');
        max_time_index(oi_subjects) = find(data_time_seconds_mat{oi_subjects} <= common_max_time, 1, 'last');
        common_timepoints(oi_subjects) = max_time_index(oi_subjects) - min_time_index(oi_subjects); % common timepoints should be equal,
    end
    
    %% 11. include the limiting file in the field "remarq" of the structure
    
    structure_comments{1} = ['timeline minimum defined by ', folders_level_3{min_time_subject_index}];
    structure_comments{2} = ['timeline maximum defined by ', folders_level_3{max_time_subject_index}];
    structure_comments{3} = strcat('length of the session: ', num2str((common_max_time - common_min_time)/60),' min');
    
    %% 12. selection of data with common datapoints
    
    lenght_data = min(common_timepoints) - 1; % e.g. 11575 datapoints -- ask Yann why -1?
    selected_dataset = [];
    
    % here, a new dataset is created by looking at the original dataset but taking only those datapoints where we find a shared timeline,
    % e.g between the index 1 of the timeline that start the later, and the index 11577 (i.e. 11576 common timepoints across all subjects)
    
    for n_subject = 1:length(folders_level_3)
        selected_dataset(:,:,n_subject) = data_first_step{n_subject}(min_time_index(n_subject):min_time_index(n_subject) + lenght_data, :);
    end
    
    % -> data_second_step is a 3 (time, data_of_interest, subject) matrix
    
    %% 13. data start epoch
    
    start_epoch = selected_dataset(1,1,1); % get the first epoch data that is common across all subjects,
    start_epoch_hours = floor(start_epoch/60*60); % get the hours,
    start_epoch_minutes = floor((start_epoch - start_epoch_hours *60*60)/60); % get the minutes,
    start_epoch_seconds = floor(start_epoch - start_epoch_hours*60*60 - start_epoch_minutes*60); % get the seconds,
    structure_epoch = [num2str(start_epoch_hours),'-',num2str(start_epoch_minutes),'-',num2str(start_epoch_seconds)];
    
    %% 14. saving data
    
    % variables to save,
    sampling_frequency = 1;
    structure_data_list =  data_of_interest';
    structure_date = date_4_level;
    structure_subject_list = folders_level_3';
    structure_sources = all_path_target_files';
    structure_comments = structure_comments';
    data_type_name = data_type(3:end); 
    
    % name of the data-file
    file_name = sprintf('data_%s_%s', folders_level_1{x_sessions}, data_type_name);
    
    % structure of the data
    fileStruct = struct( ...
        'name', file_name, ...
        'data', selected_dataset, ...
        'data_type', data_type_name, ...
        'data_list', {structure_data_list}, ...
        'subject_list', {structure_subject_list}, ...
        'source', {structure_sources}, ...
        'sampling_frequency', sampling_frequency, ...        
        'comments', {structure_comments});
    
    % re-naming the dataset
%     string_to_evaluate = [file_name, '=structured_data;'];
%     eval(string_to_evaluate);
   
    % change directory
    cd ../2_data_analysis
    
    % save the data
    save (file_name, 'fileStruct')
    
    cd ../1_data_organized
    
end

% checking time
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));

% END