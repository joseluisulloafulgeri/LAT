
% script to add time-markers
% created: YF 31/11/2014; modified: JLUF 01/12/2014

% to run in: 2_data_analysis/subj_online_v1

close all
clear all

%% 1. find the names of the structures

dir_level_1 = dir; % first we get in the first directory,
dir_level_1 = dir_level_1(3:end); % we get ride of '.' and '..',

% % % % file names
% % % files_names_level_1 = {};
% % % for i_level_1 = 1 : length(dir_level_1)
% % %     files_names_level_1{i_level_1} = [dir_level_1(i_level_1).name];
% % % end

files_names_level_1 = dir_level_1.name;

% for i_struct = 1:length(files_names_level_1)
    
    %% 2. load structures
%    load(files_names_level_1{i_struct});
%    load('data_2014_10_21_PM1_subj_online');
    
    %% 3. get names for markers files and open it
    
    struct_name = fileStruct.name;
    markers_file_name = sprintf('timing_%s_dances.csv', char(struct_name(6:19)));
    file_location = '../../1_data_timing';
    markers_file_location = fullfile(file_location, markers_file_name);
    
    % open files
    fid = fopen(markers_file_location);
    time_markers_file = textscan(fid,'%f%s','Delimiter',';');
    
    time_markers_info = time_markers_file{1}; % e.g. [69435;69856;69893;70319;70287;70770;70802;71227]
    time_markers_names = time_markers_file{2}; % e.g. {'solo_1' 'interlude_1' 'duo_1' 'interlude_2' 'solo_2' 'interlude_3' 'duo_2' 'fin'}
    
    % correction applied to files 10_21
    
    % PM1
    % time_markers_info = time_markers_info - 60;
    % PM2
    % time_markers_info = time_markers_info - 60;
    % time_markers_info(4) = 70255;
    % time_markers_info(5) = 70285;
    
    %% 4. define temporal index
    
    last_index = fileStruct.common_seconds(end);
    time_markers_index = []; time_markers_cell = {};
    numeric_markers = [];
    
    for i_mark = 1:length(time_markers_info) % e.g. 8
        
        if time_markers_info(i_mark) < last_index %%% FOR-SHORTER-SEQUENCES
            time_markers_index(i_mark) = find(fileStruct.common_seconds >= time_markers_info(i_mark),1,'first'); %%% ADDING-INDEX
            
            if i_mark ~= length(time_markers_info) % e.g. ~= 8 %%% YANN-DEFAULT
                if time_markers_info(i_mark +1) < last_index %%% FOR-SHORTER-SEQUENCES
                    time_markers_index(i_mark +1) = find(fileStruct.common_seconds >= time_markers_info(i_mark +1), 1, 'first'); %%% ADDING-INDEX
                else
                    time_markers_index(i_mark +1) = find(fileStruct.common_seconds == last_index); %%% ADDING-INDEX                    
                end
            else
                %
            end
            %% doing the time_markers_cell
            if i_mark ~= length(time_markers_info) % i_mark < 8 %%% CHECKING
                if time_markers_info(i_mark) < last_index && time_markers_info(i_mark + 1) < last_index %%% FOR-SHORTER-SEQUENCES
                    time_markers_cell(time_markers_index(i_mark):time_markers_index(i_mark +1)) = time_markers_names(i_mark);
                    numeric_markers(time_markers_index(i_mark):time_markers_index(i_mark +1)) = i_mark;

                else time_markers_info(i_mark) < last_index &&  fileStruct.common_seconds(time_markers_index(i_mark +1)) == last_index; %%% EXTRA
                    time_markers_cell(time_markers_index(i_mark):time_markers_index(i_mark +1)) = time_markers_names(i_mark);
                    numeric_markers(time_markers_index(i_mark):time_markers_index(i_mark +1)) = i_mark;
                end
            else % i_mark = 8
                if time_markers_info(i_mark) < last_index %%% FOR-SHORTER-SEQUENCES
                    time_markers_cell(time_markers_index(i_mark):find(fileStruct.common_seconds == last_index)) = time_markers_names(i_mark);
                    numeric_markers(time_markers_index(i_mark):find(fileStruct.common_seconds == last_index)) = i_mark;
                else
                    %
                end
            end
        else
            time_markers_index(i_mark) = find(fileStruct.common_seconds == last_index,1,'first'); %%% ADDING-INDEX
        end
    end
    
    %% 5. generates the 'marker' fields
    
    fileStruct.marker_numeric = numeric_markers;
    fileStruct.marker_tab = time_markers_cell;
    fileStruct.marker_times = time_markers_info;
    fileStruct.marker_names = time_markers_names;
    
    %% 6. add a comment

    fileStruct.comments{size(fileStruct.comments,1)+1} = ['time-markers added on ', date];
    
    %% 7. save the structure
    
    cd ../subj_online_v2
    
    name = sprintf('%s_v2', fileStruct.name);
    save(name,'fileStruct');
    
    cd ../subj_online_v1
    
% end

% END