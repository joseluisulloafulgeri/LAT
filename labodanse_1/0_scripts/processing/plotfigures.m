% plotfigures.m

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

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
    
    for y_dataType = 1:length(dataType)
        
        %% Getting the markers
        
        % markers
        markNumbers = zeros(length(FileStruct.mrkTime), 1);
        for i_elements = 1:length(markNumbers)
            if strcmp(FileStruct.mrkTime(i_elements), 'solo_1')
                markNumbers(i_elements) = 1;
            elseif strcmp(FileStruct.mrkTime(i_elements), 'duo_1')
                markNumbers(i_elements) = 1;
            elseif strcmp(FileStruct.mrkTime(i_elements), 'solo_2')
                markNumbers(i_elements) = 1;
            elseif strcmp(FileStruct.mrkTime(i_elements), 'duo_2')
                markNumbers(i_elements) = 1;
            end
        end
        
        if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
            %markNumbers = markNumbers*0.1; % 0.5
            markNumbers = markNumbers*40; % 700
        elseif strcmp(dataType(y_dataType), 'HR')
            markNumbers = markNumbers*180;
        elseif strcmp(dataType(y_dataType), 'BR')
            markNumbers = markNumbers*30;
        end
        
        %% Getting the data
        ValuesW = squeeze(FileStruct.data(:,y_dataType,:));
        
        % Time scale
        TimeOrigi = (1:length(ValuesW));
        
        if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
            % engagement  - 10 Hz
            TimeCentiSecW = TimeOrigi;
            TimeSecW = TimeCentiSecW./10;

        elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')            
            %bioharness - 1 Hz
            TimeSecW = TimeOrigi;
        end
        
        TimeMinW = TimeSecW./60;
        TimeW = TimeMinW;
        
        figure,
        set(gcf,'Visible','off');
        set(gcf, 'units', 'normalized', 'position', [0 0 1.3 .8]);
       
        if size(ValuesW, 2) == 6;
            h1 = plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
            h2 = plot(TimeW, ValuesW(:,2), 'Color', [1 0 1]); hold on
            h3 = plot(TimeW, ValuesW(:,3), 'Color', [0 1 1]); hold on
            h4 = plot(TimeW, ValuesW(:,4), 'Color', [1 0 0]); hold on
            h5 = plot(TimeW, ValuesW(:,5), 'Color', [.2 0.6 1]); hold on
            h6 = plot(TimeW, ValuesW(:,6), 'Color', [1 .2 .6]); hold on
            h7 = plot(TimeW, markNumbers, 'k');
            
        elseif size(ValuesW, 2) == 7;
            h1 = plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
            h2 = plot(TimeW, ValuesW(:,2), 'Color', [1 0 1]); hold on
            h3 = plot(TimeW, ValuesW(:,3), 'Color', [0 1 1]); hold on
            h4 = plot(TimeW, ValuesW(:,4), 'Color', [1 0 0]); hold on
            h5 = plot(TimeW, ValuesW(:,5), 'Color', [.2 0.6 1]); hold on
            h6 = plot(TimeW, ValuesW(:,6), 'Color', [1 .2 .6]); hold on
            h7 = plot(TimeW, ValuesW(:,7), 'Color', [1 .6 .2]); hold on
            h8 = plot(TimeW, markNumbers, 'k');
            
        elseif size(ValuesW, 2) == 8;
            h1 = plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
            h2 = plot(TimeW, ValuesW(:,2), 'Color', [1 0 1]); hold on
            h3 = plot(TimeW, ValuesW(:,3), 'Color', [0 1 1]); hold on
            h4 = plot(TimeW, ValuesW(:,4), 'Color', [1 0 0]); hold on
            h5 = plot(TimeW, ValuesW(:,5), 'Color', [.2 0.6 1]); hold on
            h6 = plot(TimeW, ValuesW(:,6), 'Color', [1 .2 .6]); hold on
            h7 = plot(TimeW, ValuesW(:,7), 'Color', [1 .6 .2]); hold on
            h8 = plot(TimeW, ValuesW(:,8), 'Color',[0 0 1]); hold on
            h9 = plot(TimeW, markNumbers, 'k');
            
        elseif size(ValuesW, 2) == 9;
            h1 = plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
            h2 = plot(TimeW, ValuesW(:,2), 'Color', [1 0 1]); hold on
            h3 = plot(TimeW, ValuesW(:,3), 'Color', [0 1 1]); hold on
            h4 = plot(TimeW, ValuesW(:,4), 'Color', [1 0 0]); hold on
            h5 = plot(TimeW, ValuesW(:,5), 'Color', [.2 0.6 1]); hold on
            h6 = plot(TimeW, ValuesW(:,6), 'Color', [1 .2 .6]); hold on
            h7 = plot(TimeW, ValuesW(:,7), 'Color', [1 .6 .2]); hold on
            h8 = plot(TimeW, ValuesW(:,8), 'Color',[0 0 1]); hold on
            h9 = plot(TimeW, ValuesW(:,9), 'Color',[.6 .1 .2]); hold on
            h10 = plot(TimeW, markNumbers, 'k');

        elseif size(ValuesW, 2) == 10;
            h1 = plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
            h2 = plot(TimeW, ValuesW(:,2), 'Color', [1 0 1]); hold on
            h3 = plot(TimeW, ValuesW(:,3), 'Color', [0 1 1]); hold on
            h4 = plot(TimeW, ValuesW(:,4), 'Color', [1 0 0]); hold on
            h5 = plot(TimeW, ValuesW(:,5), 'Color', [.2 0.6 1]); hold on
            h6 = plot(TimeW, ValuesW(:,6), 'Color', [1 .2 .6]); hold on
            h7 = plot(TimeW, ValuesW(:,7), 'Color', [1 .6 .2]); hold on
            h8 = plot(TimeW, ValuesW(:,8), 'Color',[0 0 1]); hold on
            h9 = plot(TimeW, ValuesW(:,9), 'Color',[.6 .1 .2]); hold on
            h10 = plot(TimeW, ValuesW(:,10), 'Color',[.6 .2 1]); hold on
            h11 = plot(TimeW, markNumbers, 'k');            
            
        elseif size(ValuesW, 2) == 11;
            h1 = plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
            h2 = plot(TimeW, ValuesW(:,2), 'Color', [1 0 1]); hold on
            h3 = plot(TimeW, ValuesW(:,3), 'Color', [0 1 1]); hold on
            h4 = plot(TimeW, ValuesW(:,4), 'Color', [1 0 0]); hold on
            h5 = plot(TimeW, ValuesW(:,5), 'Color', [.2 0.6 1]); hold on
            h6 = plot(TimeW, ValuesW(:,6), 'Color', [1 .2 .6]); hold on
            h7 = plot(TimeW, ValuesW(:,7), 'Color', [1 .6 .2]); hold on
            h8 = plot(TimeW, ValuesW(:,8), 'Color',[0 0 1]); hold on
            h9 = plot(TimeW, ValuesW(:,9), 'Color',[.6 .1 .2]); hold on
            h10 = plot(TimeW, ValuesW(:,10), 'Color',[.6 .2 1]); hold on
            h11 = plot(TimeW, ValuesW(:,11), 'Color',[1 1 0]); hold on
            h12 = plot(TimeW, markNumbers, 'k');            
        end
        
        % plot settings
        plot(get(gca,'xlim'),[0 0], 'Color', [0.5 0.5 0.5]);  hold on % horizontal line around zero
        
        % axis limits
        if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
            axis([ min(TimeMinW)-.1 max(TimeMinW)+.1 -40 40 ]) % -5 5 sets the x-axis (first 2) and y-axis (last 2) limits
            %axis([ min(TimeMinW)-.1 max(TimeMinW)+.1 0 1000 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
            %axis([ min(TimeMinW)-.1 max(TimeMinW)+.1 -0.1 0.1 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
        elseif strcmp(dataType(y_dataType), 'HR')
            axis([ min(TimeW)-.1 max(TimeW)+.1 0 200 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
        elseif strcmp (dataType(y_dataType), 'BR')
            axis([ min(TimeW)-.1 max(TimeW)+.1 0 50 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
        end
        
        % legend
        if size(ValuesW, 2) == 6;
            legend([h1 h2 h3 h4 h5 h6 h7],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'mrk'}, 'FontSize', 12);
        elseif size(ValuesW, 2) == 7;
            legend([h1 h2 h3 h4 h5 h6 h7 h8],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'mrk'}, 'FontSize', 12);
        elseif size(ValuesW, 2) == 8;
            legend([h1 h2 h3 h4 h5 h6 h7 h8 h9],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'mrk'}, 'FontSize', 12);
        elseif size(ValuesW, 2) == 9;
            legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9' 'mrk'}, 'FontSize', 12);            
        elseif size(ValuesW, 2) == 10;
            legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9' 'S10' 'mrk'}, 'FontSize', 12);
        elseif size(ValuesW, 2) == 11;
            legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12],{'S1','S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9' 'S10' 'S11' 'mrk'}, 'FontSize', 12);             
        end
        
        % X-axis
        if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
            % engagement  - 10 Hz
            xAxis = floor(TimeW(1:600:end));

        elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')            
            %bioharness - 1 Hz
            xAxis = floor(TimeW(1:60:end));
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
        title(horzcat(dataType{y_dataType}, ' responses for ', fileNameCleanB), 'FontSize', 20)
        
        %% save
        
        inputFolder = sourcePath;
        outputFolder = sprintf('/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/%s', destinyFolder);
        cd (outputFolder)
        
        % name
        if strcmp(dataType(y_dataType), 'x')
            nameFigure = sprintf('%s_data_X_overallview.png', fileNameClean); 
        elseif strcmp(dataType(y_dataType), 'y')
            nameFigure = sprintf('%s_data_Y_overallview.png', fileNameClean);
        elseif strcmp(dataType(y_dataType), 'HR')
            nameFigure = sprintf('%s_data_HR_overallview.png', fileNameClean);
        elseif strcmp(dataType(y_dataType), 'BR')
            nameFigure = sprintf('%s_data_BR_overallview.png', fileNameClean);
        end
        
        % save
        f = getframe(gcf); % Capture the current window
        imwrite(f.cdata, nameFigure); % Save the frame data
        close(gcf);
        cd (inputFolder)
        
        %%
        
        for iDanceType = 1:length(markersOfInterest)
            
            % set the values of interest according to the dance type
            indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{iDanceType});
            
            %% Getting the data
            
            Values = FileStruct.data(indexMarkersLogic,y_dataType,:);
            Values = squeeze(Values); % e.g. 430x8
            
            % Time scale
            TimeOrigi = (1:length(Values));            
            
            if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
                
                % engagement  - 10 Hz
                TimeCentiSec = TimeOrigi;
                TimeSec = TimeCentiSec./10;

            elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')
                
                %bioharness - 1 Hz
                TimeSec = TimeOrigi;
            end
            
            TimeMin = TimeSec./60;
            TimeMinP = TimeMin;

            figure,
            set(gcf,'Visible','off');
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
                h2 = plot(TimeMinP, Values(:,2), 'Color', [1 0 1]); hold on
                h3 = plot(TimeMinP, Values(:,3), 'Color', [0 1 1]); hold on
                h4 = plot(TimeMinP, Values(:,4), 'Color', [1 0 0]); hold on
                h5 = plot(TimeMinP, Values(:,5), 'Color', [.2 0.6 1]); hold on
                h6 = plot(TimeMinP, Values(:,6), 'Color', [1 .2 .6]); hold on
                h7 = plot(TimeMinP, Values(:,7), 'Color', [1 .6 .2]); hold on
                h8 = plot(TimeMinP, Values(:,8), 'Color',[0 0 1]); hold on
                
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
            if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
                %axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 -5 5 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
                %axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 0 1000 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
                axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 -40 40 ]) % -0.1 0.1 sets the x-axis (first 2) and y-axis (last 2) limits
            elseif strcmp(dataType(y_dataType), 'HR')
                axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 0 200 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
            elseif strcmp(dataType(y_dataType), 'BR')
                axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 0 50 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
            end
        
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
