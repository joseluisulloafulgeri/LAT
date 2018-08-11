
% step_10_std_2.m
% script to smooth and normalize the data
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
    
    data_dance = []; data_single =[]; data_3 = [];
    
    for i_dance = 1:length(dance_cell)
        
        %% standard deviation
        data_dance = dance_cell{i_dance};
        data_single = squeeze(data_dance(:,2,:));
        data_3 = std(data_single');
        SD_1 = data_3;
        MN_ofSD = mean(data_single');
        
        %SD_2 = std(SD_1); % one single value
        %M_SD = mean(SD_1); % one single value
        %threshold_dance =  M_SD - 0.5*SD_2;
        
        % gral_SD_2, gral_M_SD &  gral_threshold has been calculated before
        threshold_dance = 0.8786;
                        
        %% plot
        set(gcf,'Visible','off');
        
        h = figure('units', 'normalized', 'position', [0 0 .9 .7], 'name', markersInterest{i_dance});

        % data: all individual curves
        h1 = plot(1:length(data_3), data_single, 'color',[0.8,0.8,0.8], 'lineWidth', 2);
        hold on

        % data: mean curve
        h2 = plot(1:length(data_3), MN_ofSD, 'g', 'lineWidth', 3);
        hold on
        
        % data: standard deviation
        %plot(fileStruct.common_seconds(),var_data_group_1_eng2)
        h3 = plot(1:length(data_3), data_3, 'r','lineWidth', 3);
        hold on

        % adding lines
        plot(get(gca,'xlim'),[0 0],'k') % horizontal line
        h4 = plot(get(gca,'xlim'),[threshold_dance threshold_dance],'--r'); % horizontal line
        
        % plot settings
        legend([h2 h3 h4],{'average','standard deviation' 'threshold'}, 'FontSize', 10);
        set(gca,'xlim',[1 length(data_3)], 'FontSize', 20) % change x-axis
        xlabel('Time (compilated seconds)'), ylabel('Engagement level (z-score)', 'FontSize', 20)
        title(['Engagement timecourse' markersInterest(i_dance)], 'FontSize', 20)
        
        
        %% saving
        cd ../../3_images/eng_timecourses_std_2
       
        f = getframe(gcf);              %# Capture the current window
        name_picture = sprintf('engagement_std_2_session_%d_data_%s.png', i_struct, markersInterest{i_dance});
        imwrite(f.cdata, name_picture);  %# Save the frame data
        cd ../../2_data_analysis/subj_online_v3
        
    end
end

% END