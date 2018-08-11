
% visualizeHRV_1.m
% inspired from visualizeHRV_3.m (ex visualizeHRV.m)
% compare the effects of a manipulation on HRV data
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_new/bioharness_3

% created by JLUF 04/08/2015

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% variables

session = {'ECG_2014_10_20' 'ECG_2014_10_21'};
effects = {'PM1_alt' 'PM2_alt' 'Yoga'};

%for i_session = 1:length(session)
for i_session = 1:length(session)    
    for i_effects = 1:length(effects)
        
        if strcmp(effects{i_effects}, 'PM1_alt') || strcmp(effects{i_effects}, 'PM2_alt')
            first_path = sprintf('%s_%s_PTB', session{i_session}, effects{i_effects});
            second_path = sprintf('%s_%s_PTA', session{i_session}, effects{i_effects});
        else
            first_path = sprintf('%s_%s_YTB', session{i_session}, effects{i_effects});
            second_path = sprintf('%s_%s_YTA', session{i_session}, effects{i_effects});
        end
        
        if strcmp(effects{i_effects}, 'PM1_alt') || strcmp(effects{i_effects}, 'PM2_alt')
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
        
        %structureName = sprintf('first_file.Freq1HRV'); % before data
        %eval(['lengthData = length(' structureName ');']);
        
        %%
        first_file_HRV = first_file.Freq1HRV;
        first_file_HRV_save = first_file.Freq1HRV;
        second_file_HRV = second_file.Freq1HRV;
        second_file_HRV_save = second_file.Freq1HRV;
         
        %% first part
        figure1 = figure('Color',[1 1 1]);
        set(gcf,'Visible','off');
        set(gcf, 'units', 'normalized', 'position', [0 0 1 1]);
        
        titleFigure_ini = sprintf('%s_%s', session{i_session}, effects{i_effects});
        titleFigure = strrep(titleFigure_ini,'_','-');
                
        % ----------------------------- %
        
        if strcmp(session{i_session}, 'ECG_2014_10_20') && strcmp(effects{i_effects}, 'PM2_alt')   
            cellReplace = cell(length(first_file_HRV), 1);
            cellReplace{1} = second_file_HRV{1};
            cellReplace{2} = NaN;
            cellReplace{3} = NaN;
            cellReplace{4} = NaN;
            cellReplace{5} = second_file_HRV{2};
            cellReplace{6} = second_file_HRV{3};
            cellReplace{7} = second_file_HRV{4};
            cellReplace{8} = second_file_HRV{5};
            cellReplace{9} = NaN;
            %
            second_file_HRV = cellReplace;
            
        elseif strcmp(session{i_session}, 'ECG_2014_10_20') && strcmp(effects{i_effects}, 'Yoga')            
            cellReplace = cell(length(first_file_HRV), 1);
            cellReplace{1} = second_file_HRV{1};
            cellReplace{2} = second_file_HRV{2};
            cellReplace{3} = second_file_HRV{3};
            cellReplace{4} = NaN;
            cellReplace{5} = second_file_HRV{4};
            cellReplace{6} = NaN;
            cellReplace{7} = second_file_HRV{5};
            cellReplace{8} = second_file_HRV{6};
            cellReplace{9} = NaN;
            %
            second_file_HRV = cellReplace;
        
        elseif strcmp(session{i_session}, 'ECG_2014_10_21') && strcmp(effects{i_effects}, 'PM2_alt')            
            cellReplace = cell(8, 1);
            cellReplace{1} = first_file_HRV{1};
            cellReplace{2} = first_file_HRV{2};
            cellReplace{3} = first_file_HRV{3};
            cellReplace{4} = NaN;
            cellReplace{5} = first_file_HRV{4};
            cellReplace{6} = first_file_HRV{5};
            cellReplace{7} = first_file_HRV{6};
            cellReplace{8} = first_file_HRV{7};
            %
            first_file_HRV = cellReplace;
            
            cellReplace2 = cell(8, 1);
            cellReplace2{1} = second_file_HRV{1};
            cellReplace2{2} = second_file_HRV{2};
            cellReplace2{3} = second_file_HRV{3};
            cellReplace2{4} = NaN;
            cellReplace2{5} = NaN;
            cellReplace2{6} = second_file_HRV{4};
            cellReplace2{7} = second_file_HRV{5};
            cellReplace2{8} = second_file_HRV{6};
            %
            second_file_HRV = cellReplace2;            

        elseif strcmp(session{i_session}, 'ECG_2014_10_21') && strcmp(effects{i_effects}, 'Yoga')
            cellReplace = cell(length(first_file_HRV), 1);
            cellReplace{1} = second_file_HRV{1};
            cellReplace{2} = second_file_HRV{2};
            cellReplace{3} = second_file_HRV{3};
            cellReplace{4} = second_file_HRV{4};
            cellReplace{5} = second_file_HRV{5};
            cellReplace{6} = second_file_HRV{6};
            cellReplace{7} = NaN;
            cellReplace{8} = NaN;
            cellReplace{9} = NaN;
            cellReplace{10} = second_file_HRV{7};
            %
            second_file_HRV = cellReplace;              
        end        
        
        lengthData = length(first_file_HRV);
        
        %% second part
        for i_subplot = 1:lengthData
            subplot(3,4,i_subplot)
            
            i_subplot_b = i_subplot;
            eval_1 = sprintf('h1 = plot(first_file_HRV{%d}, \''-o\'', \''color\'',\''b\'');', i_subplot); % before
            eval(eval_1)
            hold on
            eval_2 = sprintf('h2 = plot(second_file_HRV{%d}, \''-o\'', \''color\'', \''r\'');', i_subplot_b); % after
            eval(eval_2)
            
            xlabel('datapoints'), ylabel('HRV')
            titleStr = sprintf('before(b) vs after(r) (subj %d)', i_subplot);
            title(titleStr)
        end
        suplabel(titleFigure, 't');
        tightfig;
        
        %% Save
        
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
