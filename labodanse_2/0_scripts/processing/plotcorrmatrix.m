function plotcorrmatrix(data, statsOption, statsPvalue, statsThreshold, statsThresholdName, corrMethod, dataType, danceType, danceTypeName, TOI, subjectList, session, inputFolder, outputFolder, freq)
% plotcorrmatrix.m
% USE: plot correlation matrix
% INPUT: correlation matrix
% OUPUT: plot
% ROOTS: folder containing the structures

% created: JLUF 09/02/2015
% last update: 09/02/2015

% figure settings
figure,
set(gcf,'Visible','off');
set(gcf, 'units', 'normalized', 'position', [0 0 .5 .7]);

% optional thresholding of data, according to stats
if statsOption == 0
    % nothing
    
elseif statsOption == 1
    dataB = NaN(length(data), length(data));
    % which values are below my threshold
    statsLogic = logical(statsPvalue < statsThreshold);
    % I leave only them
    dataB(statsLogic) = data(statsLogic);
    data = dataB;
    
elseif statsOption == 2 % binarize
    % which values are below my threshold
    statsLogic = logical(statsPvalue < statsThreshold);
    % I leave only them
    data = double(statsLogic);
end

% make diagonal 0
data(logical(eye(length(data)))) = NaN;

% actual plot
imagesc2(abs(data))
colorbar

if statsOption == 0 || statsOption == 1
    % nothing

elseif statsOption == 2 % binarize
    colormap(flipud(gray))
    
end

% code to change the x-axis label
newLabel = char(subjectList);
newLabel = newLabel(:,1:3);
set(gca, 'xtick', 1:length(data))
set(gca,'xticklabel',newLabel) % I put it back as xticklabel
set(gca,'yticklabel',newLabel) % I put it back as xticklabel
caxis([0 1])
title([corrMethod ' ' char(TOI) ' ' danceTypeName ], 'FontSize', 20)
%tightfig; % tight the figure (external function)
axis image on

% save
cd (outputFolder)

if statsOption == 0
    if strcmp(corrMethod, 'corrcoef')
        nameFigure = sprintf('MC1_sess%d_%s_%s_%0.2f_Hz_%s.png', session, danceType, TOI, freq, char(dataType));
    elseif strcmp(corrMethod, 'partialcorr')
        nameFigure = sprintf('MC2_sess%d_%s_%s_%0.2f_Hz_%s.png', session, danceType, TOI, freq, char(dataType));
    end
    
elseif statsOption == 1
    if strcmp(corrMethod, 'corrcoef')
        nameFigure = sprintf('MC1_sess%d_%s_%s_%0.2f_Hz_%s_stat1thr%s.png', session, danceType, TOI, freq, char(dataType), statsThresholdName);
    elseif strcmp(corrMethod, 'partialcorr')
        nameFigure = sprintf('MC2_sess%d_%s_%s_%0.2f_Hz_%s_stat1thr%s.png', session, danceType, TOI, freq, char(dataType), statsThresholdName);
    end
    
elseif statsOption == 2
    if strcmp(corrMethod, 'corrcoef')
        nameFigure = sprintf('MC1_sess%d_%s_%s_%0.2f_Hz_%s_stat2thr%s', session, danceType, TOI, freq, char(dataType), statsThresholdName);
    elseif strcmp(corrMethod, 'partialcorr')
        nameFigure = sprintf('MC2_sess%d_%s_%s_%0.2f_Hz_%s_stat2thr%s', session, danceType, TOI, freq, char(dataType), statsThresholdName);
    end
end

%% save
saveas(gcf, nameFigure);
close(gcf);

cd (inputFolder)

% END