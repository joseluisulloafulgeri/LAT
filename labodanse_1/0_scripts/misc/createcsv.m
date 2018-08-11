
% createcsv
% save data as a csv file
% created: JLUF 03/12/2014
% to run in /2_data_analysis/subj_online_v2
% input: structures
% output: structures

%% 0. variables of interest
markersInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};

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
    
    %% 3. get the data according to markers
    
    index_markers = []; dance_cell = {};
    
    for i_dance = 1:length(markersInterest)
        index_markers = find(ismember(fileStruct.marker_tab, markersInterest{i_dance}));
        dance_cell{i_dance} = fileStruct.data(index_markers,:,:);
    end
    
    data_saving = []; data_saving_2 =[]; var_data_group_1_eng2 = [];
    
    for i_dance = 1:length(dance_cell)
        
        %% gathering data
        
        data_type = {'x' 'y'};
        
        for i_data = 1:length(data_type)
            
            data_saving = dance_cell{i_dance};
            data_saving_2 = squeeze(data_saving(:,i_data,:));
            
            %% saving
            name_file = sprintf('engData_session_%d_%s_data_%s', i_struct, markersInterest{i_dance}, data_type{i_data});
            csvwrite(name_file, data_saving_2)
        end
        
    end
end

% END