% inspired from plotfigures.m

%% Defining the destiny folder

% % destinyFolder = input('Folder name to save the data? > ', 's');
% % % example: > bioharness_3
% % sourcePath = pwd;

%% Variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
namesMarkers = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};

%% Get the names of the structures

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
    dataType = FileStruct.dataList;
    [pathstr,fileNameClean,ext] = fileparts(filesNames{i_struct});
    freqList = FileStruct.freqs;
    
    for i_freq = 1:length(freqList)
        for iDanceType = 1:length(markersOfInterest)
            
            % set the values of interest according to the dance type
            indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{iDanceType});
            
            % getting the data
            Values = FileStruct.data(indexMarkersLogic, i_freq, :);
            Values = squeeze(Values); % e.g. 430x8
            
            % Time scale
            TimeOrigi = (1:length(Values));
            % 25 Hz
            TimeCentiSecW = TimeOrigi;
            TimeSecW = TimeCentiSecW./25;
            TimeMinW = TimeSecW./60;
            TimeMinP = TimeMinW;
            
            figure,
            %set(gcf,'Visible','off');
            set(gcf, 'units', 'normalized', 'position', [0 0 .9 .7]);
            
            if size(Values, 2) == 6;
                h1 = plot(TimeMinP, Values(:,1), 'Color', [0 1 0]); hold on
                h2 = plot(TimeMinP, Values(:,2), 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3), 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4), 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5), 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6), 'Color', [1 .2 .6]); hold on
                
            elseif size(Values, 2) == 7;
                h1 = plot(TimeMinP, Values(:,1), 'Color', [0 1 0]); hold on
                h2 = plot(TimeMinP, Values(:,2), 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3), 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4), 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5), 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6), 'Color', [1 .2 .6]); hold on
                h7 = plot(TimeMinP, Values(:,7), 'Color', [1 .6 .2]); hold on
                
            elseif size(Values, 2) == 8;
                h1 = plot(TimeMinP, Values(:,1), 'Color', [0 1 0]); hold on
                h2 = plot(TimeMinP, Values(:,2).*2, 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3).*3, 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4).*4, 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5).*5, 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6).*6, 'Color', [1 .2 .6]); hold on
                h7 = plot(TimeMinP, Values(:,7).*7, 'Color', [1 .6 .2]); hold on
                h8 = plot(TimeMinP, Values(:,8).*8, 'Color',[0 0 1]); hold on
                
            elseif size(Values, 2) == 9;
                h1 = plot(TimeMinP, Values(:,1), 'Color', [0 1 0]); hold on
                h2 = plot(TimeMinP, Values(:,2), 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3), 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4), 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5), 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6), 'Color', [1 .2 .6]); hold on
                h7 = plot(TimeMinP, Values(:,7), 'Color', [1 .6 .2]); hold on
                h8 = plot(TimeMinP, Values(:,8), 'Color',[0 0 1]); hold on
                h9 = plot(TimeMinP, Values(:,9), 'Color',[.6 .1 .2]); hold on
                
            elseif size(Values, 2) == 10;
                h1 = plot(TimeMinP, Values(:,1), 'Color', [0 1 0]); hold on
                h2 = plot(TimeMinP, Values(:,2), 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3), 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4), 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5), 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6), 'Color', [1 .2 .6]); hold on
                h7 = plot(TimeMinP, Values(:,7), 'Color', [1 .6 .2]); hold on
                h8 = plot(TimeMinP, Values(:,8), 'Color',[0 0 1]); hold on
                h9 = plot(TimeMinP, Values(:,9), 'Color',[.6 .1 .2]); hold on
                h10 = plot(TimeMinP, Values(:,10), 'Color',[.6 .2 1]); hold on
                
            elseif size(Values, 2) == 11;
                h1 = plot(TimeMinP, Values(:,1), 'Color', [0 1 0]); hold on
                h2 = plot(TimeMinP, Values(:,2), 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3), 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4), 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5), 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6), 'Color', [1 .2 .6]); hold on
                h7 = plot(TimeMinP, Values(:,7), 'Color', [1 .6 .2]); hold on
                h8 = plot(TimeMinP, Values(:,8), 'Color',[0 0 1]); hold on
                h9 = plot(TimeMinP, Values(:,9), 'Color',[.6 .1 .2]); hold on
                h10 = plot(TimeMinP, Values(:,10), 'Color',[.6 .2 1]); hold on
                h11 = plot(TimeMinP, Values(:,11), 'Color',[1 1 0]); hold on
            end
            
            % plot settings
            plot(get(gca,'xlim'),[0 0], 'Color', [0.5 0.5 0.5]);  hold on % horizontal line around zero
            % axis limits
            axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 -10 10 ]) % -0.1 0.1 sets the x-axis (first 2) and y-axis (last 2) limits
           
            % legend
            if size(Values, 2) == 6;
                legend([h1 h2 h3 h4 h5 h6],{'S1','S2' 'S3' 'S4' 'S5' 'S6'}, 'FontSize', 12);
            elseif size(Values, 2) == 7;
                legend([h1 h2 h3 h4 h5 h6 h7],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7'}, 'FontSize', 12);
            elseif size(Values, 2) == 8;
                legend([h1 h2 h3 h4 h5 h6 h7 h8],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8'}, 'FontSize', 12);
            elseif size(Values, 2) == 9;
                legend([h1 h2 h3 h4 h5 h6 h7 h8 h9],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9'}, 'FontSize', 12);
            elseif size(Values, 2) == 10;
                legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9' 'S10'}, 'FontSize', 12);
            elseif size(Values, 2) == 11;
                legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9' 'S10' 'S11'}, 'FontSize', 12);
            end
            
            % X-axis
            if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
                % engagement  - 10 Hz
                xAxis = floor(TimeMinP(1:600:end));
                
            elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')
                %bioharness - 1 Hz
                xAxis = floor(TimeMinP(1:60:end));
            end
            set(gca,'XTick',xAxis)
            
            % other settings
            set(legend,'color','none', 'location', 'best'); % make legend background transparent
            xlabel('Time (minute)', 'FontSize', 20)
            
            if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
                ylabel([dataType{y_dataType} ' (z-score)'], 'FontSize', 20)
            elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')
                ylabel([dataType{y_dataType} ' (beats per minute)'], 'FontSize', 20)
            end
            fileNameCleanB = strrep(fileNameClean,'_','-');
            title(horzcat(dataType{y_dataType}, ' responses for ', fileNameCleanB, '-during-', namesMarkers{iDanceType}), 'FontSize', 20)
            
            %% save
            
            inputFolder = sourcePath;
            outputFolder = sprintf('/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/%s', destinyFolder);
            cd (outputFolder)
            
            % name
            nameFigure = sprintf('%s_data_%s_%s.png', fileNameClean, dataType{y_dataType}, namesMarkers{iDanceType});
            
            % save
            f = getframe(gcf); % Capture the current window
            imwrite(f.cdata, nameFigure); % Save the frame data
            close(gcf);
            cd (inputFolder)
            
        end
    end
end

% END
