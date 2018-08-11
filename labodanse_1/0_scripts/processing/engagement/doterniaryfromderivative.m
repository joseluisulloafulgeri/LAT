% doterniaryfromderivative.m

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
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
   
    data = FileStruct.data;
    
    for i_dataType = 1:length(dataType)
    
        data2 = squeeze(data(:,i_dataType,:));     
        data3 = zeros(size(data2, 1), size(data2, 2));       
        for i_raw = 1:size(data2, 1);
            for i_column = 1:size(data2, 2);

                if data2(i_raw, i_column) > 0
                data3(i_raw, i_column) = 1;

                elseif data2(i_raw, i_column) < 0
                data3(i_raw, i_column) = -1;
                
                end
            end
        end
        
        positiveValues = double(data3 > 0);
        positiveOverall = sum(positiveValues, 2);
        positiveOverall = positiveOverall./size(positiveValues, 2);
        
        negativeValues = double(data3 < 0);
        negativeOverall = sum(negativeValues, 2);
        negativeOverall = negativeOverall./size(negativeValues, 2);
        
        % Time scale
        TimeOrigi = (1:length(data));
        TimeCentiSecW = TimeOrigi;
        TimeSecW = TimeCentiSecW./10;
        TimeMinW = TimeSecW./60;
        TimeW = TimeMinW;
        
        % correction by session
        
        delay = 0;
        
        if i_struct == 1
            delay = 28*10; % centisec
        elseif i_struct == 2
            delay = 53*10; % centisec
        elseif i_struct == 4
            delay = 27*10; % centisec            
        end
        
        addDelay = NaN([delay, 1]);
        positiveOverallB = [addDelay; positiveOverall];
        negativeOverallB = [addDelay; negativeOverall];

        addDelay = 0.1:0.1:(delay/10); % there are 10 samples per second
        addDelayB = addDelay./60;
        addDelayC = bsxfun(@plus, addDelayB, TimeMinW(end));
        TimeMinWB = [TimeMinW addDelayC];
        
        % plot
                
        figure,
        %set(gcf,'Visible','off');
        set(gcf, 'units', 'normalized', 'position', [0 0 1.3 .8]);
        
        subplot(2,1,1)
        h1 = plot(TimeMinWB, positiveOverallB, 'Color', [1 0 0]);
        legend(h1,{'increasing'}, 'FontSize', 12);     
        xAxis = floor(TimeMinWB(1:600:end));
        axis([ min(TimeMinWB)-.1 max(TimeMinWB)+.1 0 1])
        set(gca,'XTick',xAxis)
        ylabel('# of subjects', 'FontSize', 20)
        fileNameCleanB = strrep(fileNameClean,'_','-');
        title(horzcat(fileNameCleanB), 'FontSize', 20)
        set(legend,'color','none', 'location', 'best'); % make legend background transparent
        xlabel('Time (minute)', 'FontSize', 20)
        
        subplot(2,1,2)
        h2 = plot(TimeMinWB, negativeOverallB, 'Color', [0 0 1]);
        legend(h2,{'decreasing'}, 'FontSize', 12);        
        xAxis = floor(TimeMinWB(1:600:end));
        axis([ min(TimeMinWB)-.1 max(TimeMinWB)+.1 0 1])
        set(gca,'XTick',xAxis)
        ylabel('# of subjects', 'FontSize', 20)
        set(legend,'color','none', 'location', 'best'); % make legend background transparent
        xlabel('Time (minute)', 'FontSize', 20)

        tightfig
        
        %% save
        inputFolder = sourcePath;
        outputFolder = sprintf('/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/3_images/%s', destinyFolder);
        
        cd (outputFolder)
        nameFigure = sprintf('%s_data_subjectsNumber_overallview.png', fileNameClean); 
        
        f = getframe(gcf); % Capture the current window
        imwrite(f.cdata, nameFigure); % Save the frame data
        close(gcf);
        cd (inputFolder)
        
    end         
end

% END