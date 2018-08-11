% plotfiguresderivative.m

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

%% Variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
namesMarkers = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};
dataType = {'x' 'y'};

%% Get the names of the structures

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
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
            markNumbers = markNumbers*0.1; % 700
        elseif strcmp(dataType(y_dataType), 'HR')
            markNumbers = markNumbers*180;
        elseif strcmp(dataType(y_dataType), 'BR')
            markNumbers = markNumbers*30;
        end
        
        %% Getting the data
        
        if y_dataType == 1;
            ValuesW = FileStruct.summedDerivativex;
        elseif y_dataType == 2;
            ValuesW = FileStruct.summedDerivativey;
        end
        
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
        
        plot(TimeW, ValuesW(:,1), 'Color', [0 1 0]); hold on
        plot(TimeW, markNumbers, 'k'); hold on;
        
        % plot settings
        plot(get(gca,'xlim'),[0 0], 'Color', [0.5 0.5 0.5]); % horizontal line around zero
        
        % axis limits
        if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
            axis([ min(TimeMinW)-.1 max(TimeMinW)+.1 -0.01 0.01 ]) % -5 5 sets the x-axis (first 2) and y-axis (last 2) limits
            %axis([ min(TimeMinW)-.1 max(TimeMinW)+.1 0 1000 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
            %axis([ min(TimeMinW)-.1 max(TimeMinW)+.1 -0.1 0.1 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
        elseif strcmp(dataType(y_dataType), 'HR')
            axis([ min(TimeW)-.1 max(TimeW)+.1 0 200 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
        elseif strcmp (dataType(y_dataType), 'BR')
            axis([ min(TimeW)-.1 max(TimeW)+.1 0 50 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
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
        xlabel('Time (minute)', 'FontSize', 20)
        
        if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
            ylabel([dataType{y_dataType} ' summed derivative'], 'FontSize', 20)
        elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')
            ylabel([dataType{y_dataType} ' (beats per minute)'], 'FontSize', 20)
        end
        fileNameCleanB = strrep(fileNameClean,'_','-');
        title(horzcat(dataType{y_dataType}, ' summed derivative for ', fileNameCleanB), 'FontSize', 20)
        
        %% save
        
        inputFolder = sourcePath;
        outputFolder = sprintf('/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/%s', destinyFolder);
        cd (outputFolder)
        
        % name
        if strcmp(dataType(y_dataType), 'x')
            nameFigure = sprintf('%s_data_summedderivX.png', fileNameClean);
        elseif strcmp(dataType(y_dataType), 'y')
            nameFigure = sprintf('%s_data_summedderivY.png', fileNameClean);
        elseif strcmp(dataType(y_dataType), 'HR')
            nameFigure = sprintf('%s_data_HR_summed_derivative.png', fileNameClean);
        elseif strcmp(dataType(y_dataType), 'BR')
            nameFigure = sprintf('%s_data_BR_summed_derivative.png', fileNameClean);
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
            
            Values = ValuesW(indexMarkersLogic,:);
            
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
            
            plot(TimeMinP, Values, 'Color', [0 1 0]); hold on
            
            % plot settings
            plot(get(gca,'xlim'),[0 0], 'Color', [0.5 0.5 0.5]); % horizontal line around zero
            
            % axis limits
            if strcmp(dataType(y_dataType), 'x') || strcmp(dataType(y_dataType), 'y')
                %axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 -5 5 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
                %axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 0 1000 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
                axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 -0.01 0.01 ]) % -0.1 0.1 sets the x-axis (first 2) and y-axis (last 2) limits
            elseif strcmp(dataType(y_dataType), 'HR')
                axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 0 200 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
            elseif strcmp(dataType(y_dataType), 'BR')
                axis([ min(TimeMinP)-.1 max(TimeMinP)+.1 0 50 ]) % sets the x-axis (first 2) and y-axis (last 2) limits
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
                ylabel([dataType{y_dataType} ' summed derivative'], 'FontSize', 20)
            elseif strcmp(dataType(y_dataType), 'HR') || strcmp(dataType(y_dataType), 'BR')
                ylabel([dataType{y_dataType} ' (beats per minute)'], 'FontSize', 20)
            end
            fileNameCleanB = strrep(fileNameClean,'_','-');
            title(horzcat(dataType{y_dataType}, ' summed derivative for ', fileNameCleanB, '-during-', namesMarkers{iDanceType}), 'FontSize', 20)
            
            %% save
            
            inputFolder = sourcePath;
            outputFolder = sprintf('/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/%s', destinyFolder);
            cd (outputFolder)
            
            % name
            nameFigure = sprintf('%s_data_summedderiv%s_%s.png', fileNameClean, dataType{y_dataType}, namesMarkers{iDanceType});
            
            % save
            f = getframe(gcf); % Capture the current window
            imwrite(f.cdata, nameFigure); % Save the frame data
            close(gcf);
            cd (inputFolder)
            
        end
    end
end

% END
