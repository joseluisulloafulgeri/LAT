
% script to add time-markers
% created: YF 31/11/2014; modified: JLUF 01/12/2014

% to run in: 2_data_analysis/subj_online_v1

%% 1. find the names of the structures

dir_level_1 = dir; % first we get in the first directory,
dir_level_1 = dir_level_1(3:end); % we get ride of '.' and '..',

% file names
files_names_level_1 = {};
for i_level_1 = 1 : length(dir_level_1)
    files_names_level_1{i_level_1} = [dir_level_1(i_level_1).name];
end

for i_struct = 1:length(files_names_level_1)
    
    %% 2. load structures
    load(files_names_level_1{i_struct});
%   load('data_2014_10_21_PM1_subj_online');
    
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
    
    %% 4. define temporal index
    
    last_index = fileStruct.common_seconds(end);
    time_markers_list = []; time_marker_cell = {};
    
    for i_index = 1:length(time_markers_info) % e.g. 8
        
        if time_markers_info(i_index) < last_index %%% FOR-SHORTER-SEQUENCES
            time_markers_list(i_index) = find(fileStruct.common_seconds >= (time_markers_info(i_index))-1,1,'first'); %%% YANN-DEFAULT
            
            if i_index ~= length(time_markers_info) % e.g. ~= 8 %%% YANN-DEFAULT
                if time_markers_info(i_index +1) < last_index %%% FOR-SHORTER-SEQUENCES
                    time_markers_list(i_index +1) = find(fileStruct.common_seconds >= (time_markers_info(i_index +1))-1,1,'first'); %%% YANN-DEFAULT
                end
            else
%                if time_markers_info(i_index +1) < last_index %%% FOR-SHORTER-SEQUENCES
%                    time_markers_list(i_index +1) = length(fileStruct.common_seconds); %%% YANN-DEFAULT
%                end
            end
            
            if time_markers_info(i_index) < last_index && time_markers_info(i_index + 1) < last_index %%% FOR-SHORTER-SEQUENCES
                time_marker_cell(time_markers_list(i_index):time_markers_list(i_index +1)) = time_markers_names(i_index);
%                time_marker_numbers(time_markers_list(i_index):time_markers_list(i_index +1)) = i_index;
            else
                time_marker_cell(time_markers_list(i_index):find(fileStruct.common_seconds == last_index)) = time_markers_names(i_index);
%                time_marker_numbers(time_markers_list(i_index):time_markers_list(i_index +1)) = i_index;
            end
        end
    end
    
    %% 5. generates the 'marker' fields
    
    if isfield(fileStruct,'marker_tab') == 0
        fileStruct.marker_tab{1} = time_marker_cell;
        fileStruct.marker_type{1} = time_markers_info;
    else
        fileStruct.marker_tab{size(fileStruct.marker_tab,1)+1} = time_marker_cell;
        fileStruct.marker_type{size(fileStruct.marker_type,1)+1,1} = time_markers_info;
    end
    
    %% 6. save the structure
    
    cd ../subj_online_v2
    save(fileStruct.name,'fileStruct');
    cd ../subj_online_v1
    
end

% END