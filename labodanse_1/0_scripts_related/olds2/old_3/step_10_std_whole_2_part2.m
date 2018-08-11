
% step_10_std_whole_2_part2.m
% script to calculate the standard deviation
% created: JLUF 03/12/2014
% to run in /2_data_analysis/subj_online_v3

%% 0. variables of interest
% data_type = {'x' 'y'};

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
    
    %% standard deviation
    data_all_dances = squeeze(fileStruct.data(:,2,:));
    SD_1 = std(data_all_dances');
    MEAN_1 = mean(data_all_dances');
    
    % gral_SD_2, gral_M_SD &  gral_threshold has been calculated before
    threshold_dance = 0.8786;
    
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
    
    cd ../../3_images/eng_timecourses_std_whole_2
    
    % name_picture = sprintf('engagement_std_session_%d_data_%s', i_struct, data_type{i_data_type});
    % saveas (h, name_picture, 'png' )
    
    f = getframe(gcf);              %# Capture the current window
    name_picture = sprintf('engagement_std_session_%d_data_y.png', i_struct);
    imwrite(f.cdata, name_picture);  %# Save the frame data
    cd ../../2_data_analysis/subj_online_v3
    
end

% END