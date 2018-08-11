
% step_10_std_whole_2_part1.m
% script to calculate the standard deviation
% created: JLUF 03/12/2014
% to run in /2_data_analysis/subj_online_v3

%% 0. variables of interest
data_type = {'x' 'y'};

%% 1. find the names of the structures
dir_level_1 = dir; % first we get in the first directory,
dir_level_1 = dir_level_1(3:end); % we get ride of '.' and '..',

% file names
files_names_level_1 = {};
for i_level_1 = 1 : length(dir_level_1)
    files_names_level_1{i_level_1} = [dir_level_1(i_level_1).name];
end

data_all_sessions = [];
for i_struct = 1:length(files_names_level_1)
    
    %% 2. load structures
    load(files_names_level_1{i_struct});
    data_all_dances{i_struct} = (squeeze(fileStruct.data(:,2,:)))';
    data_all_sessions = [data_all_sessions data_all_dances];
end

% matrices has been concatenated manually (of different sizes, I leave the
% shorter: 17723), and I create the variable A,

data_all_sessions = A;
grnal_SD_1 = std(data_all_sessions);
grnal_MEAN_1 = mean(data_all_sessions);
        
grnal_SD_1b = grnal_SD_1;
grnal_SD_1b(isnan(grnal_SD_1b)) = [];
        
% thresold
grnal_SD_2 = std(grnal_SD_1b); % one single value
grnal_M_SD = mean(grnal_SD_1b); % one single value
grnal_threshold_dance =  grnal_M_SD - 0.5*grnal_SD_2;

% END