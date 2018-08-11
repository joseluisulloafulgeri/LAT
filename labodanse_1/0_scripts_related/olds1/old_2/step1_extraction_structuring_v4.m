
% script that extract and synchronize bioharness data, and put it into a structure
% created: YF 06/10/2014; modified: JLUF 12/10/2014 modified_2: JLUF 13/10/2014
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
% dir_level_2 = {'1_eeg' '2_bioh_capteurs' '3_bioh_online' '4_bioh_tablette' '5_subj_offline' ...
%    '6_subj_online' '7_questionnaire' ' 8_time_distort'};


%% 1. getting the directory file names

dir_level_1 = dir; % first we get in the first directory,
dir_level_1 = dir_level_1(3:end); % we get ride of '.' and '..',

folders_level_1 = {};
for i_level_1 = 1 : length(dir_level_1)
    folders_level_1{i_level_1} = [dir_level_1(i_level_1).name]; % e.g. 2014_10_20_AM; 2014_10_20_PM1; 2014_10_21_PM2, etc ...
end

selected_folders = {'2014_10_20_PM1' '2014_10_20_PM2' '2014_10_21_PM1' '2014_10_21_PM2'};
folders_level_1 = selected_folders;

%% 2. selecting data type

% for the moment we are interested in the bioh data,
% next step is to make a loop with all the types of data
data_type = '6_subj_online';
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
        
        path_target_file = fullfile(path_level_3, folders_level_3{i_subject});
        all_path_target_files{i_subject} = path_target_file;
        
        %% 4. opening the data-file
        
        % TEST-to erase... imported_data = importdata('A01_804_PM1_ENG.csv');
        
        imported_data = importdata(path_target_file); % import the dataset associated with the target_file
        % the 'importdata' function generates a structure with 2 fields:
        % one associated with numerical data, and another with text,
        % imported_data.textdata give us the labels, and in our case the first column with the dates
        % imported_data.data give us the numerical data, attention! in our case all data is shifted one colum to the left
        % because the timeline is not included here, see below
        
        %% 5. gathering time info of each subject: replacing data values in an extended timeline
        
        % time correction => x + 7200000
        correction = 7200000;
        corrected_data_timeline = bsxfun(@plus, imported_data.data(:,1), correction);
        % whole_timeline
        extended_timeline = corrected_data_timeline(1):corrected_data_timeline(end); % e.g. 1413824400000:1413826800000;
        
        % replacing data values in the extended version of the timeline
        value_eng = NaN(1, length(extended_timeline));
        timeline_true = ones(1, length(extended_timeline));
        [test_member, index_in_rounded] = ismember(extended_timeline, corrected_data_timeline);
        
        for i_step = 1:length(extended_timeline)
            if test_member(i_step) == 1;
                value_eng(i_step) = imported_data.data(index_in_rounded(i_step), 2);
            else
                % nothing
            end
        end
        
        % taking the maximal value each 1000 points == 1 seg.
        count = 1;
        value_eng_2 = NaN(1, round(length(extended_timeline)/1000)); % 1 901
        for i_new_points = 1:1000:round(length(extended_timeline)/1000)*1000 % 1 901 199
            value_eng_2(count) = max(value_eng(i_new_points:i_new_points + 998));
            count = count + 1;
        end
        
        % --------------------------------------
        data_first_step{i_subject} = value_eng_2;
        new_timeline = round(corrected_data_timeline(1))/1000:round(corrected_data_timeline(end)/1000);
        % --------------------------------------
        
        %% 6. once the data and timeline were obtained we come back to the old method
        
        % first, we get the column with the timestamps
        unconverted_time = new_timeline;
        % third, we convert them to human-readable format
        converted_time = datestr(unconverted_time/86400 + datenum(1970,1,1));
        % fourth, convert the strings to cells
        converted_time_2 = cellstr(converted_time);
        
        % fifth, we re-format the date from 20-Oct-2014 15:09:59 to 20/10/2014 15:09:59
        converted_time_3  = {};
        for y_string = 1:length(converted_time_2)
            converted_time_3{y_string} = strrep(converted_time_2{y_string}, '-Oct-', '/10/');
        end
        converted_time_3 = converted_time_3';
                       
        % six, we re-create the fields in imported_data
        imported_data.textdata{1} = 'Time';
        
        % 
        new_textdata = cell(length(converted_time_3) + 1, length(imported_data.textdata));
        
        for i_cell = 1:length(new_textdata) - 1
            new_textdata{i_cell+1, 1} = converted_time_3{i_cell};
        end
        
        new_textdata{1,1} = imported_data.textdata(1,1);
        new_textdata{1,2} = imported_data.textdata(1,2);
        new_textdata{1,3} = imported_data.textdata(1,3);
        
        % for data we eliminate one column,
        imported_data.data(:,1) = []; % eliminate the first column,
        
        imported_data.textdata = new_textdata;     
        
        %-----------------------
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
        
%         %% 10. gathering the data from each subject
%         % which data? --> 'Time','HR','BR','HRConfidence','HRV','CoreTemp'
%         data_of_interest = {'x','y'};
%         % we recover the data of time, which the function 'importdata' put elsewhere,
%         data_all = [data_time_seconds_mat{i_subject}' imported_data.data];
%         % we create a logic vector which indicate the index of the data we want to retrieve,
%         index_selection = ismember([imported_data.textdata{1,:}], data_of_interest);
%         % get save the data in a cell array
%         data_first_step{i_subject} = data_all(:, index_selection);
        
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
%        selected_dataset(:,:,n_subject) = data_first_step{n_subject}(min_time_index(n_subject):min_time_index(n_subject) + lenght_data, :);
        selected_dataset(:, n_subject) = data_first_step{n_subject}(min_time_index(n_subject):min_time_index(n_subject) + lenght_data);
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
    structured_data = struct( ...
        'name', file_name, ...
        'data', selected_dataset, ...
        'data_type', data_type_name, ...
        'data_list', {structure_data_list}, ...
        'subject_list', {structure_subject_list}, ...
        'source', {structure_sources}, ...
        'sampling_frequency', sampling_frequency, ...        
        'comments', {structure_comments});
    
    % re-naming the dataset
    string_to_evaluate = [file_name, '=structured_data;'];
    eval(string_to_evaluate);
   
    % change directory
    cd ../2_data_analysis
    
    % save the data
    save (file_name, file_name)
    
    cd ../1_data_organized
    
end

% checking time
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
 
% END