
% plotHRVdata.m
% apply in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3

% created by JLUF 20/07/2015

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

%% get into each main folder
for i_folder = 1:length(directoryNames)
    
    cd (directoryNames{i_folder})
    fileName = directoryNames{i_folder};
    fileNameClean = strrep(fileName,'_','-');
    localPath = pwd;
    
    targetFile = sprintf('HRVstruct_%s', directoryNames{i_folder});
    load (targetFile)
    
    colors = [0 1 0; 0 1 1; 1 0 0; .2 .6 1; ...
        1 .6 .2; 0 0 1; 1 .2 .6; 0 .6 0; .6 0 .6; ...
        .6 .6 0; .7 .7 .7; .6 0 0; .2 .2 .7; ...
        .5 .5 .5; .7 .2 .2; .2 .7 .2; 0 0 .6; .3 .3 .3; ...
        0 .9 .4; 0 .4 .9; .9 .4 0; .4 .9 0; .9 0 .4; ...
        .4 0 .9; .8 .5 .5; .5 .8 .5; .5 .5 .8];
    
    structureName = sprintf('%s.beatsOrigi', targetFile);
    eval(['lenghtData = length(' structureName ');']);
    
    %% Figure
    
    ouputFolder = sprintf('../../%s', destinyFolder);
    cd (ouputFolder)
    
    % PLOT 1 - BEATS SERIES - ORGINAL & CORRECTED
    figure1 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    
    for i_subplot = 1:lenghtData
        subplot(3,4,i_subplot)
        eval_1 = sprintf('h1 = plot(%s.beatsOrigi{%d}, \''b\'');', targetFile, i_subplot);
        eval(eval_1)
        hold on
        eval_2 = sprintf('h2 = plot(%s.beatsProc{%d}, \''r\'');', targetFile, i_subplot);
        eval(eval_2)
        xlabel('IBI datapoints'), ylabel('IBIs')
        titleStr = sprintf('origi(b) vs processed(r) IBIs (subj %d)', i_subplot);
        title(titleStr)
    end
    tightfig;
    
    nameFigure = sprintf('%s_dataHRV_checking1_IBIs.png', fileName);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);
    
    % PLOT 2 - HEART not interpolated - ORGINAL & CORRECTED
    figure2 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    for i_subplot = 1:lenghtData
        subplot(3,4,i_subplot)
        eval_1 = sprintf('h1 = plot(%s.HRNoInterpOrigi{%d}, \''b\'');', targetFile, i_subplot);
        eval(eval_1)
        hold on
        eval_2 = sprintf('h2 = plot(%s.HRNoInterpProc{%d}, \''r\'');', targetFile, i_subplot);
        eval(eval_2)
        xlabel('HR datapoints'), ylabel('Heart Rate')
        titleStr = sprintf('origi(b) vs processed (r) HR (subj %d)', i_subplot);
        title(titleStr)
    end
    tightfig;
    
    nameFigure = sprintf('%s_dataHRV_checking2_HRnoInterp.png', fileName);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);    
    
    % PLOT 3 - HRV FOR EACH INDIVIDUAL
    figure3 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    for i_plot = 1:lenghtData
        eval_1 = sprintf('h1 = plot(%s.Freq1HRV{%d}, \''-o\'', \''color\'', colors(%d,:));', targetFile, i_plot, i_plot);
        eval(eval_1)
        ylabel('HRV')
        titleStr = sprintf('HRV for each subject');
        title(titleStr)
        hold on
    end
    legend('show');
    tightfig;
    
    nameFigure = sprintf('%s_dataHRV_HRVseries.png', fileName);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);
    
    % PLOT 4 - HF FOR EACH INDIVIDUAL
    figure4 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    for i_plot = 1:lenghtData
        eval_1 = sprintf('h1 = plot(%s.Freq1HF{%d}, \''-o\'', \''color\'', colors(%d,:));', targetFile, i_plot, i_plot);
        eval(eval_1)
        ylabel('HF')
        titleStr = sprintf('HF for each subject');
        title(titleStr)
        hold on
    end
    legend('show');
    tightfig;
    
    nameFigure = sprintf('%s_dataHRV_seriesHF.png', fileName);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);
    
    % PLOT 5 - LF FOR EACH INDIVIDUAL
    figure5 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    for i_plot = 1:lenghtData
        eval_1 = sprintf('h1 = plot(%s.Freq1LF{%d}, \''-o\'', \''color\'', colors(%d,:));', targetFile, i_plot, i_plot);
        eval(eval_1)
        ylabel('LF')
        titleStr = sprintf('LF for each subject');
        title(titleStr)
        hold on
    end
    legend('show');
    tightfig;
    
    nameFigure = sprintf('%s_dataHRV_seriesLF.png', fileName);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);
    
    % PLOT 6 - HR interpolated FOR EACH INDIVIDUAL
    figure6 = figure('Color',[1 1 1]);
    set(gcf,'Visible','off');
    set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
    for i_plot = 1:lenghtData
        eval_1 = sprintf('h1 = plot(%s.HRInterp{%d}, \''color\'', colors(%d,:));', targetFile, i_plot, i_plot);
        eval(eval_1)
        ylabel('HR')
        titleStr = sprintf('interpolated HR for each subject');
        title(titleStr)
        hold on
    end
    legend('show');
    tightfig;
    
    nameFigure = sprintf('%s_dataHRV_checking3_HRInterp.png', fileName);
    f = getframe(gcf); % Capture the current window
    imwrite(f.cdata, nameFigure); % Save the frame data
    close(gcf);
    
    cd (sourcePath)
end