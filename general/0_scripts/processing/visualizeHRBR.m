
%visualizeHRBR.m

% appy in:
%/Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_reloaded/bioharness_2
% created by JLUF 31/08/2015

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% variables

%session = {'HRBR_2014_10_20' 'HRBR_2014_10_21'};
%session = {'HRBR_2014_12_11'};
session = {'HRBR_2014_12_12'};

section = {'PM1_alt' 'PM2_alt' 'Yoga'};
%section = {'PM1_alt' 'Yoga'};

dataType = {'HR' 'BR'};

for i_dataType = 1:length(dataType)
    for i_session = 1:length(session)
        for i_section = 1:length(section)
            
            % defining path
            if strcmp(section{i_section}, 'PM1_alt') || strcmp(section{i_section}, 'PM2_alt')
                effect1 = 'PTB';
                effect2 = 'PTA';
            else
                effect1 = 'YTB';
                effect2 = 'YTA';                
            end
            
            % first file - before effect
            first_path = sprintf('%s_%s_2.mat', session{i_session}, section{i_section});
            load(first_path);
            logicDataFirst = strcmp(FileStruct.mrkTime, effect1);
            first_data = squeeze(FileStruct.data(logicDataFirst, i_dataType, :));
            % second file - after effect
            logicDataSecond = strcmp(FileStruct.mrkTime, effect2);
            second_data = squeeze(FileStruct.data(logicDataSecond, i_dataType, :));                
               
            
            %% first part
            figure1 = figure('Color',[1 1 1]);
            set(gcf,'Visible','off');
            set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
            
            titleFigure_ini = sprintf('%s_%s', session{i_session}, section{i_section});
            titleFigure = strrep(titleFigure_ini,'_','-');
            
            lengthData = size(first_data, 2);
            
            %% second part
            for i_subplot = 1:lengthData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_data(:,%d), \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                eval_2 = sprintf('h2 = plot(second_data(:,%d), \''color\'', \''r\'');', i_subplot_b); % after
                eval(eval_2)
                
                xlabel('datapoints'),
                
                if strcmp(dataType{i_dataType}, 'HR')
                    ylabel('HR')
                elseif strcmp(dataType{i_dataType}, 'BR')
                    ylabel('BR')
                end
                
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)
            end
            suplabel(titleFigure, 't');
            tightfig;
            
            %% Save
            
            ouputFolder = sprintf('../%s', destinyFolder);
            cd (ouputFolder)
            
            %% third part
            nameFigure = sprintf('%s_%s_comparison_%s.png', session{i_session}, section{i_section}, dataType{i_dataType});
            f = getframe(gcf); % Capture the current window
            imwrite(f.cdata, nameFigure); % Save the frame data
            close(gcf);
            
            cd (sourcePath)
            
        end
    end
end
