
% computeHRVmean_1.m
% inspired from computeHRVmean_3.m
% compute mean of the HRV data
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_new/bioharness_3

% created by JLUF 12/08/2015

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% variables

session = {'ECG_2014_10_20' 'ECG_2014_10_21'};
effects = {'PM1_alt' 'PM2_alt' 'Yoga'};

for i_session = 1:length(session)
%for i_session = 2:2   
    for i_effects = 1:length(effects)
    %for i_effects = 2:2    
        
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
        
        structureName = sprintf('first_file.Freq1HRV'); % before data
        eval(['lenghtData = length(' structureName ');']);
        
        %% Average
        
        % average
        HRVmean_first_file = zeros(length(first_file.Freq1HRV), 1);
        HRVstdev_first_file = zeros(length(first_file.Freq1HRV), 1);
        for i_mean = 1:length(HRVmean_first_file)
            HRVmean_first_file(i_mean) = mean(cell2mat(first_file.Freq1HRV(i_mean)));
            HRVstdev_first_file(i_mean) = std(cell2mat(first_file.Freq1HRV(i_mean)));
        end
        
        % average
        HRVmean_second_file = zeros(length(second_file.Freq1HRV), 1);
        HRVstdev_second_file = zeros(length(second_file.Freq1HRV), 1);
        for i_mean = 1:length(HRVmean_second_file)
            HRVmean_second_file(i_mean) = mean(cell2mat(second_file.Freq1HRV(i_mean)));
            HRVstdev_second_file(i_mean) = std(cell2mat(second_file.Freq1HRV(i_mean)));
        end
        
        %% Putting data together
                
        if strcmp(session{i_session}, 'ECG_2014_10_20') && strcmp(effects{i_effects}, 'PM2_alt')
            
            completeSetMean = zeros(length(first_file.Freq1HRV), 2);
            %
            completeSetMean(:, 1) = HRVmean_first_file;
            %
            completeSetMean(1, 2) = HRVmean_second_file(1);
            completeSetMean(2, 2) = NaN;
            completeSetMean(3, 2) = NaN;
            completeSetMean(4, 2) = NaN;
            completeSetMean(5, 2) = HRVmean_second_file(2);
            completeSetMean(6, 2) = HRVmean_second_file(3);
            completeSetMean(7, 2) = HRVmean_second_file(4);
            completeSetMean(8, 2) = HRVmean_second_file(5);
            completeSetMean(9, 2) = NaN;            
            %
            %
            completeSetSD = zeros(length(first_file.Freq1HRV), 2);
            %
            completeSetSD(:, 1) = HRVstdev_first_file;
            %
            completeSetSD(1, 2) = HRVstdev_second_file(1);
            completeSetSD(2, 2) = NaN;
            completeSetSD(3, 2) = NaN;
            completeSetSD(4, 2) = NaN;
            completeSetSD(5, 2) = HRVstdev_second_file(2);
            completeSetSD(6, 2) = HRVstdev_second_file(3);
            completeSetSD(7, 2) = HRVstdev_second_file(4);
            completeSetSD(8, 2) = HRVstdev_second_file(5);
            completeSetSD(9, 2) = NaN;              

        elseif strcmp(session{i_session}, 'ECG_2014_10_20') && strcmp(effects{i_effects}, 'Yoga')
            
            completeSetMean = zeros(length(first_file.Freq1HRV), 2);
            %
            completeSetMean(:, 1) = HRVmean_first_file;
            %
            completeSetMean(1, 2) = HRVmean_second_file(1);
            completeSetMean(2, 2) = HRVmean_second_file(2);
            completeSetMean(3, 2) = HRVmean_second_file(3);
            completeSetMean(4, 2) = NaN;
            completeSetMean(5, 2) = HRVmean_second_file(4);
            completeSetMean(6, 2) = NaN;
            completeSetMean(7, 2) = HRVmean_second_file(5);
            completeSetMean(8, 2) = HRVmean_second_file(6);
            completeSetMean(9, 2) = NaN;            
            %
            %
            completeSetSD = zeros(length(first_file.Freq1HRV), 2);
            %
            completeSetSD(:, 1) = HRVstdev_first_file;
            %
            completeSetSD(1, 2) = HRVstdev_second_file(1);
            completeSetSD(2, 2) = HRVstdev_second_file(2);
            completeSetSD(3, 2) = HRVstdev_second_file(3);
            completeSetSD(4, 2) = NaN;
            completeSetSD(5, 2) = HRVstdev_second_file(4);
            completeSetSD(6, 2) = NaN;
            completeSetSD(7, 2) = HRVstdev_second_file(5);
            completeSetSD(8, 2) = HRVstdev_second_file(6);
            completeSetSD(9, 2) = NaN;            
        
        elseif strcmp(session{i_session}, 'ECG_2014_10_21') && strcmp(effects{i_effects}, 'PM2_alt')
            
            completeSetMean = zeros(8, 2);
            %
            completeSetMean(1, 1) = HRVmean_first_file(1);
            completeSetMean(2, 1) = HRVmean_first_file(2);
            completeSetMean(3, 1) = HRVmean_first_file(3);
            completeSetMean(4, 1) = NaN;
            completeSetMean(5, 1) = HRVmean_first_file(4);
            completeSetMean(6, 1) = HRVmean_first_file(5);
            completeSetMean(7, 1) = HRVmean_first_file(6);
            completeSetMean(8, 1) = HRVmean_first_file(7);             
            %
            completeSetMean(1, 2) = HRVmean_second_file(1);
            completeSetMean(2, 2) = HRVmean_second_file(2);
            completeSetMean(3, 2) = HRVmean_second_file(3);
            completeSetMean(4, 2) = NaN;
            completeSetMean(5, 2) = NaN;
            completeSetMean(6, 2) = HRVmean_second_file(4);
            completeSetMean(7, 2) = HRVmean_second_file(5);
            completeSetMean(8, 2) = HRVmean_second_file(6);           
            %
            %
            completeSetSD = zeros(8, 2);
            %
            completeSetSD(1, 1) = HRVstdev_first_file(1);
            completeSetSD(2, 1) = HRVstdev_first_file(2);
            completeSetSD(3, 1) = HRVstdev_first_file(3);
            completeSetSD(4, 1) = NaN;
            completeSetSD(5, 1) = HRVstdev_first_file(4);
            completeSetSD(6, 1) = HRVstdev_first_file(5);
            completeSetSD(7, 1) = HRVstdev_first_file(6);
            completeSetSD(8, 1) = HRVstdev_first_file(7);
            %
            completeSetSD(1, 2) = HRVstdev_second_file(1);
            completeSetSD(2, 2) = HRVstdev_second_file(2);
            completeSetSD(3, 2) = HRVstdev_second_file(3);
            completeSetSD(4, 2) = NaN;
            completeSetSD(5, 2) = NaN;
            completeSetSD(6, 2) = HRVstdev_second_file(4);
            completeSetSD(7, 2) = HRVstdev_second_file(5);
            completeSetSD(8, 2) = HRVstdev_second_file(6);
            
        elseif strcmp(session{i_session}, 'ECG_2014_10_21') && strcmp(effects{i_effects}, 'Yoga')
            
            completeSetMean = zeros(length(first_file.Freq1HRV), 2);
            %
            completeSetMean(:, 1) = HRVmean_first_file;
            %
            completeSetMean(1, 2) = HRVmean_second_file(1);
            completeSetMean(2, 2) = HRVmean_second_file(2);
            completeSetMean(3, 2) = HRVmean_second_file(3);
            completeSetMean(4, 2) = HRVmean_second_file(4);
            completeSetMean(5, 2) = HRVmean_second_file(5);
            completeSetMean(6, 2) = HRVmean_second_file(6);
            completeSetMean(7, 2) = NaN;
            completeSetMean(8, 2) = NaN;
            completeSetMean(9, 2) = NaN;
            completeSetMean(10, 2) = HRVmean_second_file(7);
            %
            %
            completeSetSD = zeros(length(first_file.Freq1HRV), 2);
            %
            completeSetSD(:, 1) = HRVstdev_first_file;
            %
            completeSetSD(1, 2) = HRVstdev_second_file(1);
            completeSetSD(2, 2) = HRVstdev_second_file(2);
            completeSetSD(3, 2) = HRVstdev_second_file(3);
            completeSetSD(4, 2) = HRVstdev_second_file(4);
            completeSetSD(5, 2) = HRVstdev_second_file(5);
            completeSetSD(6, 2) = HRVstdev_second_file(6);
            completeSetSD(7, 2) = NaN;
            completeSetSD(8, 2) = NaN;
            completeSetSD(9, 2) = NaN; 
            completeSetSD(10, 2) = HRVstdev_second_file(7);

        else % regular case
            
            completeSetMean = [HRVmean_first_file HRVmean_second_file];
            completeSetSD = [HRVstdev_first_file HRVstdev_second_file];
            
        end
        
        %% Saving
        
        ouputFolder = sprintf('../%s', destinyFolder);
        cd (ouputFolder)
        
        %varText = 
        nameFileMean = sprintf('%s_%s_Means_HRV.txt', session{i_session}, effects{i_effects});
        nameFileSD = sprintf('%s_%s_SD_HRV.txt', session{i_session}, effects{i_effects});
        
        %save
        csvwrite(nameFileMean, completeSetMean)
        csvwrite(nameFileSD, completeSetSD)
        
        cd (sourcePath)
        
    end
end

%END