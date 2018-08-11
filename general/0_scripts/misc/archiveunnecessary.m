
% archiveunnecessary.m
% script for re-organize files in a folder
% to launch in /1_data_organized

% JLUF 04/10/2014

%% 1. get the content of the main folder
first_level = dir;

first_level_2 = {}; zet = 1;
for i_val = 1:length(dir)
    first_level_2{zet} = first_level(i_val).name;
    zet = zet + 1;
end
first_level_2 = first_level_2(3:end); % first two are useless (. and ..)

%% 2. get into each main folder
for i_folder = 1:length(first_level_2)
    
    %% 3. jump into the folders, and there into 2_bioh_tablette
    second_level = fullfile(first_level_2{i_folder}, '2_bioh_tablette');
    cd (second_level)
    
    %% 4. get the list of each subject-folder
    third_level = dir;
    third_level_2 = {}; zet = 1;
    
    for y_val = 1:length(dir)
        third_level_2{zet} = third_level(y_val).name;
        zet = zet + 1;
    end
    
    third_level_2 = third_level_2(3:end); % first two are useless (. and ..)
    
    %% 5. get into each subject-folder...
    for xy_folder = 1:length(third_level_2)
        
        fourth_level = dir(third_level_2{xy_folder});
        fourth_level_2 = fourth_level(3,1).name;
        %% 6. ... throught each one of the dates
        fourth_level_3 = fullfile(third_level_2{xy_folder},fourth_level_2);
        
        cd (fourth_level_3)
        
        %% 7. move the files
        mkdir no_scv_files
        movefile('*.dat', 'no_scv_files')
        movefile('*.hed', 'no_scv_files')
        movefile('*.txt', 'no_scv_files')
        
        %% 8. go back
        cd ../../
    end
    cd ../../
end