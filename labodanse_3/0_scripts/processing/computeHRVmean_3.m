
% computeHRVmean_3.m (ex computeHRVmean.m)
% compute mean of the HRV data
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3

% created by JLUF 12/08/2015

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
        
        completeSetMean = zeros(length(first_file.Freq1HRV), 2);
        completeSetMean(:, 1) = HRVmean_first_file;       
        completeSetSD = zeros(length(first_file.Freq1HRV), 2);
        completeSetSD(:, 1) = HRVstdev_first_file;
        
        if strcmp(session{i_session}, 'ECG_2015_05_12') && strcmp(effects{i_effects}, 'A_alt') 
            for i_mean = 1:length(HRVmean_first_file)
                i_mean_b = i_mean;
                if i_mean==2
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                elseif i_mean>2
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean_b);
                else
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean);
                end    
            end
        elseif strcmp(session{i_session}, 'ECG_2015_05_12') && strcmp(effects{i_effects}, 'B_alt')
            for i_mean = 1:length(HRVmean_first_file)
                i_mean_b = i_mean;
                if i_mean==1
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                elseif i_mean>1
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean_b);
                else
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean);
                end    
            end            
        elseif strcmp(session{i_session}, 'ECG_2015_05_14') && strcmp(effects{i_effects}, 'A_alt')
            for i_mean = 1:length(HRVmean_first_file)
                i_mean_b = i_mean;
                if i_mean==7 || i_mean==8
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                elseif i_mean>8
                    i_mean_b = i_mean-2;
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean_b);
                else
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean);
                end    
            end             
        elseif strcmp(session{i_session}, 'ECG_2015_05_14') && strcmp(effects{i_effects}, 'Yoga')
            for i_mean = 1:length(HRVmean_first_file)
                i_mean_b = i_mean;
                if i_mean==7
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                elseif i_mean>7
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean_b);
                else
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean);
                end    
            end             
        elseif strcmp(session{i_session}, 'ECG_2015_05_15') && strcmp(effects{i_effects}, 'B_alt')
            for i_mean = 1:length(HRVmean_first_file)
                i_mean_b = i_mean;
                if i_mean==4
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                elseif i_mean>4
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean_b);
                else
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean);
                end    
            end             
        elseif strcmp(session{i_session}, 'ECG_2015_05_15') && strcmp(effects{i_effects}, 'Yoga')
            for i_mean = 1:length(HRVmean_first_file)
                i_mean_b = i_mean;
                if i_mean==4
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                elseif i_mean>4
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean_b);
                else
                    completeSetMean(i_mean, 2) = HRVmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRVstdev_second_file(i_mean);
                end    
            end  
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