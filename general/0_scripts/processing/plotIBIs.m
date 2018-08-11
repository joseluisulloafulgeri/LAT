
% plotIBIs.m
% create IBI plots from txt files for a given dataset
% apply in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3

% created by JLUF 10/07/2015
% updates: JLUF 16/07/2015

%%

% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));
mode = 2;

% get into each main folder
for i_folder = 1:length(directoryNames)
    
    cd (directoryNames{i_folder})
    fileName = directoryNames{i_folder};
    fileNameClean = strrep(fileName,'_','-');
    
    files2 = dir('*.txt');
    directory2Names = {files2.name};
    directory2Names = directory2Names';
    
    localDir = pwd;
    subFolder = fullfile(localDir, 'intervals', '*.txt');
    files3 = dir(subFolder);
    directory3Names = {files3.name};
    directory3Names = directory3Names';
    
    maxIndiv = zeros(1, length(directory2Names));
    indivData = cell(1, length(directory2Names));
    indivIBIintervData = cell(1, length(directory2Names));
    for i_IBI = 1:length(directory2Names)
        
        file2 = load(directory2Names{i_IBI});
        indivData{i_IBI} = file2;
        maxIndiv(i_IBI) = max(file2);
        
        accessFile3 = fullfile('intervals', directory3Names{i_IBI});
        file3 = load(accessFile3);
        indivIBIintervData{i_IBI} = file3;
        
    end
    globalMax = max(maxIndiv);
    
    colors = [0 1 0; 0 1 1; 1 0 0; .2 .6 1; ...
        1 .6 .2; 0 0 1; 1 .2 .6; 0 .6 0; .6 0 .6; ...
        .6 .6 0; .7 .7 .7; .6 0 0; .2 .2 .7; ...
        .5 .5 .5; .7 .2 .2; .2 .7 .2; 0 0 .6; .3 .3 .3; ...
        0 .9 .4; 0 .4 .9; .9 .4 0; .4 .9 0; .9 0 .4; ...
        .4 0 .9; .8 .5 .5; .5 .8 .5; .5 .5 .8];
    
    %% Figure

    figure1 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    
    % SUBPLOT 1
    subplot(3,2,1)
    plot(indivData{1}, 'color', colors(1,:))
    hold on
    for i_plot = 2:length(indivData)
        plot (indivData{i_plot}, 'color', colors(i_plot,:))
        hold on
    end
    plot(get(gca,'xlim'),[globalMax globalMax],':r') % horizontal line
    legend1 = legend('show');
    set(legend1,'color','none', 'location', 'eastoutside');
    xlabel('datapoints number'), ylabel('accumulated miliseconds, or IBIs')
    titleStr = sprintf('IBIs: %s', fileNameClean);
    title(titleStr)
    
    % SUBPLOT 2
    subplot(3,2,2)
    plot(indivIBIintervData{1}, 'color', colors(1,:))
    hold on
    for i_plot = 2:length(indivData)
        plot (indivIBIintervData{i_plot}, 'color', colors(i_plot,:))
        hold on
    end
    set(gca,'ylim',[0.3 2.5]) % change y-axis
    xlabel('IBI datapoints'), ylabel('IBIs intervals')
    titleStr = sprintf('IBIs intervals: %s', fileNameClean);
    title(titleStr)
    
    %% Individual data
    
    % SUBPLOT 3 - SUBJ 1
    subplot(3,6,7)
    [n1, xout1] = hist(indivIBIintervData{1}, 100);
    bar(xout1,n1, 'FaceColor', colors(1,:),'EdgeColor', colors(1,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 1');
    title(titleStr)    
    
    % SUBPLOT 4 - SUBJ 2
    subplot(3,6,8)
    [n1, xout1] = hist(indivIBIintervData{2}, 100);
    bar(xout1,n1, 'FaceColor', colors(2,:),'EdgeColor', colors(2,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 2');
    title(titleStr)
    
    % SUBPLOT 5 - SUBJ 3
    subplot(3,6,9)
    [n1, xout1] = hist(indivIBIintervData{3}, 100);
    bar(xout1,n1, 'FaceColor', colors(3,:),'EdgeColor', colors(3,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 3');
    title(titleStr)
    
    % SUBPLOT 6 - SUBJ 4
    subplot(3,6,10)
    [n1, xout1] = hist(indivIBIintervData{4}, 100);
    bar(xout1,n1, 'FaceColor', colors(4,:),'EdgeColor', colors(4,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 4');
    title(titleStr)
    
    % SUBPLOT 7 - SUBJ 5
    subplot(3,6,11)
    [n1, xout1] = hist(indivIBIintervData{5}, 100);
    bar(xout1,n1, 'FaceColor', colors(5,:),'EdgeColor', colors(5,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 5');
    title(titleStr)
    
    % SUBPLOT 8 - SUBJ 6
    if length(indivIBIintervData) > 5
    subplot(3,6,12)
    [n1, xout1] = hist(indivIBIintervData{6}, 100);
    bar(xout1,n1, 'FaceColor', colors(6,:),'EdgeColor', colors(6,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 6');
    title(titleStr)
    end
    
    % SUBPLOT 9 - SUBJ 7
    if length(indivIBIintervData) > 6
    subplot(3,6,13)
    [n1, xout1] = hist(indivIBIintervData{7}, 100);
    bar(xout1,n1, 'FaceColor', colors(7,:),'EdgeColor', colors(7,:)); grid;
    if mode == 2;
        set(gca,'xlim',[0 2])  % change x-axis
    end
    xlabel('IBI distribution'), ylabel('# of datapoints')
    titleStr = sprintf('Subject 7');
    title(titleStr)
    end
    
    % SUBPLOT 10 - SUBJ 8
    if length(indivIBIintervData) > 7
        subplot(3,6,14)
        [n1, xout1] = hist(indivIBIintervData{8}, 100);
        bar(xout1,n1, 'FaceColor', colors(8,:),'EdgeColor', colors(8,:)); grid;
        if mode == 2;
            set(gca,'xlim',[0 2])  % change x-axis
        end
        xlabel('IBI distribution'), ylabel('# of datapoints')
        titleStr = sprintf('Subject 8');
        title(titleStr)
    end
    
    if length(indivIBIintervData) > 8
        % SUBPLOT 11 - SUBJ 9
        subplot(3,6,15)
        [n1, xout1] = hist(indivIBIintervData{9}, 100);
        bar(xout1,n1, 'FaceColor', colors(9,:),'EdgeColor', colors(9,:)); grid;
        if mode == 2;
            set(gca,'xlim',[0 2])  % change x-axis
        end
        xlabel('IBI distribution'), ylabel('# of datapoints')
        titleStr = sprintf('Subject 9');
        title(titleStr)
    end
    
    if length(indivIBIintervData) > 9
        % SUBPLOT 12 - SUBJ 10
        subplot(3,6,16)
        [n1, xout1] = hist(indivIBIintervData{10}, 100);
        bar(xout1,n1, 'FaceColor', colors(10,:),'EdgeColor', colors(10,:)); grid;
        if mode == 2;
            set(gca,'xlim',[0 2])  % change x-axis
        end
        xlabel('IBI distribution'), ylabel('# of datapoints')
        titleStr = sprintf('Subject 10');
        title(titleStr)
    end
    
    if length(indivIBIintervData) > 10
        % SUBPLOT 13 - SUBJ 11
        subplot(3,6,17)
        [n1, xout1] = hist(indivIBIintervData{11}, 100);
        bar(xout1,n1, 'FaceColor', colors(11,:),'EdgeColor', colors(11,:)); grid;
        if mode == 2;
            set(gca,'xlim',[0 2])  % change x-axis
        end
        xlabel('IBI distribution'), ylabel('# of datapoints')
        titleStr = sprintf('Subject 11');
        title(titleStr)
    end
    
    if length(indivIBIintervData) > 11
        % SUBPLOT 14 - SUBJ 12
        subplot(3,6,18)
        [n1, xout1] = hist(indivIBIintervData{12}, 100);
        bar(xout1,n1, 'FaceColor', colors(12,:),'EdgeColor', colors(12,:)); grid;
        if mode == 2;
            set(gca,'xlim',[0 2])  % change x-axis
        end
        xlabel('IBI distribution'), ylabel('# of datapoints')
        titleStr = sprintf('Subject 12');
        title(titleStr)
    end
    
    tightfig;
    
    nameFigure = sprintf('plotIBIs_%s_%d.png', directoryNames{i_folder}, mode);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);
    
    cd ..
    
end

% END