
% step_10_std_whole.m
% script to calculate the standar deviation
% created: JLUF 03/12/2014
% to run in /2_data_analysis/subj_online_v3

%% 0. variables of interest
% markersInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
data_type = {'x' 'y'};

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
    
    for i_data_type = 1:length(data_type)
        
        %% standard deviation
        data_all_dances = squeeze(fileStruct.data(:,i_data_type,:));
        SD_1 = std(data_all_dances');
        MEAN_1 = mean(data_all_dances');
        
        SD_1b = SD_1;
        SD_1b(isnan(SD_1b)) = [];
        
        % thresold
        SD_2 = std(SD_1b); % one single value
        M_SD = mean(SD_1b); % one single value
        threshold_dance =  M_SD - 0.5*SD_2;
        
        %% plot
        set(gcf,'Visible','off');
        % h = figure('units', 'normalized', 'position', [0 0 0.5 .7], 'name', 'dances');
        h = figure('name', 'dances');
        
%        set(gca,'Units','normalized','Position',[0 0 1 1]);  %# Modify axes size
        set(gcf,'Units','pixels','Position',[200 200 1300 600]);  %# Modify figure size
        
        % data: all individual curves
        h1 = plot(1:length(data_all_dances), data_all_dances, 'color',[0.8,0.8,0.8], 'lineWidth', 2);
        hold on
        
        % data: mean curve
        h2 = plot(1:length(data_all_dances), MEAN_1, 'g', 'lineWidth', 3);
        hold on
        
        % data: standard deviation
        %plot(fileStruct.common_seconds(),var_data_group_1_eng2)
        h3 = plot(1:length(data_all_dances), SD_1, 'r','lineWidth', 3);
        hold on
        
        % adding lines
        plot(get(gca,'xlim'),[0 0],'k') % horizontal line
        %    plot([0 0], get(gca,'ylim'), 'k') % horizontal line
        h4 = plot(get(gca,'xlim'),[threshold_dance threshold_dance],'--r'); % horizontal line
        
        % plot settings
        legend([h2 h3 h4],{'average','standard deviation' 'threshold'}, 'FontSize', 10);
        set(gca,'xlim',[1 length(MEAN_1)], 'FontSize', 20) % change x-axis
        xlabel('Time (compilated seconds)'), ylabel('Engagement (z-score)', 'FontSize', 20)
        title('Engagement timecourse', 'FontSize', 10)
      
        %% saving
        
        cd ../../3_images/eng_timecourses_std_whole

        % name_picture = sprintf('engagement_std_session_%d_data_%s', i_struct, data_type{i_data_type});
        % saveas (h, name_picture, 'png' )
        
        f = getframe(gcf);              %# Capture the current window
        name_picture = sprintf('engagement_std_session_%d_data_%s.png', i_struct, data_type{i_data_type});
        imwrite(f.cdata, name_picture);  %# Save the frame data
        cd ../../2_data_analysis/subj_online_v3
        
    end
end

% END