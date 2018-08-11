
% computeHRmean_3.m (ex computeHRmean.m)
% compute mean of the HR data
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3

% created by JLUF 14/08/2015

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
        
        structureName = sprintf('first_file.HRInterp'); % before data
        eval(['lenghtData = length(' structureName ');']);
        
        %% Average
        
        % average
        HRmean_first_file = zeros(length(first_file.HRInterp), 1);
        HRstdev_first_file = zeros(length(first_file.HRInterp), 1);
        HRalpha_first_file_inf = zeros(length(first_file.HRInterp), 1);
        HRalpha_first_file_sup = zeros(length(first_file.HRInterp), 1);
        for i_mean = 1:length(HRmean_first_file)
            HRmean_first_file(i_mean) = mean(cell2mat(first_file.HRInterp(i_mean)));
            HRstdev_first_file(i_mean) = std(cell2mat(first_file.HRInterp(i_mean)));
            HRalpha_first_file_inf(i_mean) = HRmean_first_file(i_mean) - 2*HRstdev_first_file(i_mean);
            HRalpha_first_file_sup(i_mean) = HRmean_first_file(i_mean) + 2*HRstdev_first_file(i_mean);
        end
        
        % average
        HRmean_second_file = zeros(length(second_file.HRInterp), 1);
        HRstdev_second_file = zeros(length(second_file.HRInterp), 1);
        HRalpha_second_file_inf = zeros(length(first_file.HRInterp), 1);
        HRalpha_second_file_sup = zeros(length(first_file.HRInterp), 1);        
        for i_mean = 1:length(HRmean_second_file)
            HRmean_second_file(i_mean) = mean(cell2mat(second_file.HRInterp(i_mean)));
            HRstdev_second_file(i_mean) = std(cell2mat(second_file.HRInterp(i_mean)));
            HRalpha_second_file_inf(i_mean) = HRmean_second_file(i_mean) - 2*HRstdev_second_file(i_mean);
            HRalpha_second_file_sup(i_mean) = HRmean_second_file(i_mean) + 2*HRstdev_second_file(i_mean);
        end
        
        %% Alternative Average
        
        % average
        HRmeanAlt_first_file = zeros(length(first_file.HRInterp), 1);
        HRstdevAlt_first_file = zeros(length(first_file.HRInterp), 1);
        for i_mean = 1:length(HRmeanAlt_first_file)
            length_now = length(cell2mat(first_file.HRInterp(i_mean))); % length of the current individual dataset
            logic_good_data = true(1, length_now); % create logical vector
            for i_data = 1:length_now
                if first_file.HRInterp{i_mean}(i_data) < HRalpha_first_file_inf(i_mean) || first_file.HRInterp{i_mean}(i_data) > HRalpha_first_file_sup(i_mean)
                    logic_good_data(i_data) = false;
                end
            end
            data = cell2mat(first_file.HRInterp(i_mean));
            HRmeanAlt_first_file(i_mean) = mean(data(logic_good_data));
            HRstdevAlt_first_file(i_mean) = std(data(logic_good_data));                        
        end
        
        % average
        HRmeanAlt_second_file = zeros(length(second_file.HRInterp), 1);
        HRstdevAlt_second_file = zeros(length(second_file.HRInterp), 1);
        for i_mean = 1:length(HRmeanAlt_second_file)
            length_now = length(cell2mat(second_file.HRInterp(i_mean))); % length of the current individual dataset
            logic_good_data = true(1, length_now); % create logical vector
            for i_data = 1:length_now
                if second_file.HRInterp{i_mean}(i_data) < HRalpha_second_file_inf(i_mean) || second_file.HRInterp{i_mean}(i_data) > HRalpha_second_file_sup(i_mean)
                    logic_good_data(i_data) = false;
                end
            end
            data = cell2mat(second_file.HRInterp(i_mean));
            HRmeanAlt_second_file(i_mean) = mean(data(logic_good_data));
            HRstdevAlt_second_file(i_mean) = std(data(logic_good_data));            
        end    
        
        %% Putting data together
        
        completeSetMean = zeros(length(first_file.HRInterp), 2);
        completeSetMean(:, 1) = HRmean_first_file;       
        completeSetSD = zeros(length(first_file.HRInterp), 2);
        completeSetSD(:, 1) = HRstdev_first_file;
        
        completeSetMeanAlt = zeros(length(first_file.HRInterp), 2);
        completeSetMeanAlt(:, 1) = HRmeanAlt_first_file;       
        completeSetSDAlt = zeros(length(first_file.HRInterp), 2);
        completeSetSDAlt(:, 1) = HRstdevAlt_first_file;
        
        if strcmp(session{i_session}, 'ECG_2015_05_12') && strcmp(effects{i_effects}, 'A_alt') 
            for i_mean = 1:length(HRmean_first_file)
                i_mean_b = i_mean;
                if i_mean==2
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                    completeSetMeanAlt(i_mean, 2) = NaN;
                    completeSetSDAlt(i_mean, 2) = NaN;                    
                elseif i_mean>2
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean_b);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean_b);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean_b);                    
                else
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean);                    
                end    
            end
        elseif strcmp(session{i_session}, 'ECG_2015_05_12') && strcmp(effects{i_effects}, 'B_alt')
            for i_mean = 1:length(HRmean_first_file)
                i_mean_b = i_mean;
                if i_mean==1
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                    completeSetMeanAlt(i_mean, 2) = NaN;
                    completeSetSDAlt(i_mean, 2) = NaN;                     
                elseif i_mean>1
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean_b);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean_b);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean_b);                     
                else
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean);                     
                end    
            end            
        elseif strcmp(session{i_session}, 'ECG_2015_05_14') && strcmp(effects{i_effects}, 'A_alt')
            for i_mean = 1:length(HRmean_first_file)
                i_mean_b = i_mean;
                if i_mean==7 || i_mean==8
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                    completeSetMeanAlt(i_mean, 2) = NaN;
                    completeSetSDAlt(i_mean, 2) = NaN;                     
                elseif i_mean>8
                    i_mean_b = i_mean-2;
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean_b);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean_b);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean_b);                     
                else
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean);                     
                end    
            end             
        elseif strcmp(session{i_session}, 'ECG_2015_05_14') && strcmp(effects{i_effects}, 'Yoga')
            for i_mean = 1:length(HRmean_first_file)
                i_mean_b = i_mean;
                if i_mean==7
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                    completeSetMeanAlt(i_mean, 2) = NaN;
                    completeSetSDAlt(i_mean, 2) = NaN;                     
                elseif i_mean>7
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean_b);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean_b);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean_b);                     
                else
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean);                     
                end    
            end             
        elseif strcmp(session{i_session}, 'ECG_2015_05_15') && strcmp(effects{i_effects}, 'B_alt')
            for i_mean = 1:length(HRmean_first_file)
                i_mean_b = i_mean;
                if i_mean==4
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                    completeSetMeanAlt(i_mean, 2) = NaN;
                    completeSetSDAlt(i_mean, 2) = NaN;                   
                elseif i_mean>4
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean_b);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean_b);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean_b);                     
                else
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean);                     
                end    
            end             
        elseif strcmp(session{i_session}, 'ECG_2015_05_15') && strcmp(effects{i_effects}, 'Yoga')
            for i_mean = 1:length(HRmean_first_file)
                i_mean_b = i_mean;
                if i_mean==4
                    completeSetMean(i_mean, 2) = NaN;
                    completeSetSD(i_mean, 2) = NaN;
                    completeSetMeanAlt(i_mean, 2) = NaN;
                    completeSetSDAlt(i_mean, 2) = NaN;                    
                elseif i_mean>4
                    i_mean_b = i_mean-1;
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean_b);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean_b);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean_b);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean_b);                     
                else
                    completeSetMean(i_mean, 2) = HRmean_second_file(i_mean);
                    completeSetSD(i_mean, 2) = HRstdev_second_file(i_mean);
                    completeSetMeanAlt(i_mean, 2) = HRmeanAlt_second_file(i_mean);
                    completeSetSDAlt(i_mean, 2) = HRstdevAlt_second_file(i_mean);                     
                end    
            end  
        else % regular case
            completeSetMean = [HRmean_first_file HRmean_second_file];
            completeSetSD = [HRstdev_first_file HRstdev_second_file];
            completeSetMeanAlt = [HRmeanAlt_first_file HRmeanAlt_second_file];
            completeSetSDAlt = [HRstdevAlt_first_file HRstdevAlt_second_file];            
        end
        
        %% Saving
        
        ouputFolder = sprintf('../%s', destinyFolder);
        cd (ouputFolder)
        
        %varText = 
        nameFileMean = sprintf('%s_%s_Means_HR.txt', session{i_session}, effects{i_effects});
        nameFileSD = sprintf('%s_%s_SD_HR.txt', session{i_session}, effects{i_effects});
        nameFileMeanAlt = sprintf('%s_%s_MeansAlt_HR.txt', session{i_session}, effects{i_effects});
        nameFileSDAlt = sprintf('%s_%s_SDAlt_HR.txt', session{i_session}, effects{i_effects});        
        
        %save
        csvwrite(nameFileMean, completeSetMean)
        csvwrite(nameFileSD, completeSetSD)
        csvwrite(nameFileMeanAlt, completeSetMeanAlt)
        csvwrite(nameFileSDAlt, completeSetSDAlt)
        
        cd (sourcePath)
        
    end
end

%END