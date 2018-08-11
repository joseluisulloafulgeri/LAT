
% concatenatemat.m
% script to concatenate data
% created: JLUF 07/12/2014
% to run in /2_data_analysis/subj_online_v4

%% 0. variables of interest
sessions = {'1' '2' '3' '4'};
markersInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
data_type = {'x' 'y'};
    
for i_data = 1:length(data_type)

    for i_session = 1:length(sessions)
        
        all_dances = []; all_times = []; all_times_2 = [];
        for i_dance = 1:length(markersInterest)
        
            data_to_open = sprintf('engData_session_%d_%s_data_%s', i_session, markersInterest{i_dance}, data_type{i_data});
            load(data_to_open)
            one_dance = data_saving_2;
            clear data_saving_2;
            all_dances = [all_dances; one_dance];
            
            time_to_open = sprintf('engTime_session_%d_%s', i_session, markersInterest{i_dance});
            load(time_to_open)
            one_time = time_saving;
            clear data_saving;
            all_times = [all_times; one_time];

            time_to_open_2 = sprintf('engTime2_session_%d_%s', i_session, markersInterest{i_dance});
            load(time_to_open_2)
            one_time_2 = time_saving_2;
            clear data_saving_2;
            all_times_2 = [all_times_2; one_time_2];
        end
       
    cd ../subj_online_v5
    
    name_data = sprintf('whole_session_%d_data_%s', i_session, data_type{i_data});
    name_time = sprintf('whole_time_%d', i_session); % overwitted for each type of data, but doesn't matter,
    name_time_2 = sprintf('whole_time2_%d', i_session);
    
    save(name_data, 'all_dances')
    save(name_time, 'all_times')
    save(name_time_2, 'all_times_2')
    
    cd ../subj_online_v4
    end
end

% END