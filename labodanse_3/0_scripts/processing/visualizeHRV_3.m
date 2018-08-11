
% visualizeHRV.m
% compare the effects of a manipulation on HRV data
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3

% created by JLUF 04/08/2015

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% variables

session = {'ECG_2015_05_12' 'ECG_2015_05_14' 'ECG_2015_05_15'};
effects = {'A_alt' 'B_alt' 'Yoga'};

for i_session = 1:length(session)
    for i_effects = 1:length(effects)
        
        if strcmp(effects{i_effects}, 'A_alt') || strcmp(effects{i_effects}, 'B_alt')
            first_path = sprintf('%s_%s_PTB', session{i_session}, effects{i_effects});
            second_path = sprintf('%s_%s_PTA', session{i_session}, effects{i_effects});
        else
            first_path = sprintf('%s_%s_YTB', session{i_session}, effects{i_effects});
            second_path = sprintf('%s_%s_YTA', session{i_session}, effects{i_effects});
        end
        
        if strcmp(effects{i_effects}, 'A_alt') || strcmp(effects{i_effects}, 'B_alt')
            first_matfile = sprintf('HRVstruct_%s_%s_PTB.mat', session{i_session}, effects{i_effects});
            first_targetfile = sprintf('HRVstruct_%s_%s_PTB', session{i_session}, effects{i_effects});
            second_matfile = sprintf('HRVstruct_%s_%s_PTA.mat', session{i_session}, effects{i_effects});
            second_targetfile = sprintf('HRVstruct_%s_%s_PTA', session{i_session}, effects{i_effects});
        else
            first_matfile = sprintf('HRVstruct_%s_%s_YTB.mat', session{i_session}, effects{i_effects});
            first_targetfile = sprintf('HRVstruct_%s_%s_YTB', session{i_session}, effects{i_effects});
            second_matfile = sprintf('HRVstruct_%s_%s_YTA.mat', session{i_session}, effects{i_effects});
            second_targetfile = sprintf('HRVstruct_%s_%s_YTA', session{i_session}, effects{i_effects});
        end
        
        first_link = fullfile(first_path, first_matfile);
        load(first_link);
        eval([' first_file = ' first_targetfile ';']);
        
        second_link = fullfile(second_path, second_matfile);
        load(second_link);
        eval([' second_file = ' second_targetfile ';']);
        
        structureName = sprintf('first_file.Freq1HRV'); % before data
        eval(['lenghtData = length(' structureName ');']);
          
        %% first part
        figure1 = figure('Color',[1 1 1]);
        set(gcf,'Visible','off');
        set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
        
        titleFigure_ini = sprintf('%s_%s', session{i_session}, effects{i_effects});
        titleFigure = strrep(titleFigure_ini,'_','-');
                
        % ----------------------------- %
        
        if strcmp(session{i_session}, 'ECG_2015_05_12') && strcmp(effects{i_effects}, 'A_alt')   
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                if i_subplot==2; % nothing
                else
                    if i_subplot>2; i_subplot_b = i_subplot-1; end
                    eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                    eval(eval_2)
                end
                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)
            end       
            suplabel(titleFigure, 't');
            tightfig;        
        elseif strcmp(session{i_session}, 'ECG_2015_05_12') && strcmp(effects{i_effects}, 'B_alt')
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                if i_subplot==1; % nothing
                else
                    if i_subplot>1; i_subplot_b = i_subplot-1; end
                    eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                    eval(eval_2)
                end
                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)               
            end
            suplabel(titleFigure, 't');            
            tightfig;
        elseif strcmp(session{i_session}, 'ECG_2015_05_14') && strcmp(effects{i_effects}, 'A_alt')
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                if i_subplot==7  || i_subplot==8 ; % nothing
                else
                    if i_subplot>8; i_subplot_b = i_subplot-2; end
                    eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                    eval(eval_2)
                end
                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)               
            end
            suplabel(titleFigure, 't');            
            tightfig;            
        elseif strcmp(session{i_session}, 'ECG_2015_05_14') && strcmp(effects{i_effects}, 'Yoga')
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                if i_subplot==7; % nothing
                else
                    if i_subplot>7; i_subplot_b = i_subplot-1; end
                    eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                    eval(eval_2)
                end
                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)              
            end
            suplabel(titleFigure, 't');            
            tightfig;
        elseif strcmp(session{i_session}, 'ECG_2015_05_15') && strcmp(effects{i_effects}, 'B_alt')
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                if i_subplot==4; % nothing
                else
                    if i_subplot>4; i_subplot_b = i_subplot-1; end
                    eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                    eval(eval_2)
                end
                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)               
            end
            suplabel(titleFigure, 't');            
            tightfig;            
        elseif strcmp(session{i_session}, 'ECG_2015_05_15') && strcmp(effects{i_effects}, 'Yoga')
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)
                
                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                if i_subplot==4; % nothing
                else
                    if i_subplot>4; i_subplot_b = i_subplot-1; end
                    eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                    eval(eval_2)
                end
                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)               
            end
            suplabel(titleFigure, 't');            
            tightfig;  
            
        else
            %% second part
            for i_subplot = 1:lenghtData
                subplot(3,4,i_subplot)

                i_subplot_b = i_subplot;
                eval_1 = sprintf('h1 = plot(first_file.Freq1HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
                eval(eval_1)
                hold on
                eval_2 = sprintf('h2 = plot(second_file.Freq1HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
                eval(eval_2)

                xlabel('datapoints'), ylabel('HRV')
                titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
                title(titleStr)              
            end
            suplabel(titleFigure, 't');            
            tightfig; 
        end
        
        ouputFolder = sprintf('../%s', destinyFolder);
        cd (ouputFolder)
        
        %% third part
        nameFigure = sprintf('%s_%s_comparison_HRV.png', session{i_session}, effects{i_effects});
        f = getframe(gcf); % Capture the current window
        imwrite(f.cdata, nameFigure); % Save the frame data
        close(gcf);
        
        cd (sourcePath)
        
    end
end
