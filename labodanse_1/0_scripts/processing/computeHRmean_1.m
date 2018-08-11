
% computeHRmean_1.m
% inspired from computeHRmean_3.m
% compute mean of the HR data
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_new/bioharness_3

% created by JLUF 14/08/2015

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% variables

session = {'ECG_2014_10_20' 'ECG_2014_10_21'};
effects = {'PM1_alt' 'PM2_alt' 'Yoga'};

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
        
        if strcmp(session{i_session}, 'ECG_2014_10_20') && strcmp(effects{i_effects}, 'PM2_alt')
            
            completeSetMean = zeros(length(first_file.HRInterp), 2);
            %
            completeSetMean(:, 1) = HRmean_first_file;
            %
            completeSetMean(1, 2) = HRmean_second_file(1);
            completeSetMean(2, 2) = NaN;
            completeSetMean(3, 2) = NaN;
            completeSetMean(4, 2) = NaN;
            completeSetMean(5, 2) = HRmean_second_file(2);
            completeSetMean(6, 2) = HRmean_second_file(3);
            completeSetMean(7, 2) = HRmean_second_file(4);
            completeSetMean(8, 2) = HRmean_second_file(5);
            completeSetMean(9, 2) = NaN;
            %
            %
            completeSetSD = zeros(length(first_file.HRInterp), 2);
            %
            completeSetSD(:, 1) = HRstdev_first_file;
            %
            completeSetSD(1, 2) = HRstdev_second_file(1);
            completeSetSD(2, 2) = NaN;
            completeSetSD(3, 2) = NaN;
            completeSetSD(4, 2) = NaN;
            completeSetSD(5, 2) = HRstdev_second_file(2);
            completeSetSD(6, 2) = HRstdev_second_file(3);
            completeSetSD(7, 2) = HRstdev_second_file(4);
            completeSetSD(8, 2) = HRstdev_second_file(5);
            completeSetSD(9, 2) = NaN;
            
            %%%
            
            completeSetMeanAlt = zeros(length(first_file.HRInterp), 2);
            %
            completeSetMeanAlt(:, 1) = HRmeanAlt_first_file;
            %
            completeSetMeanAlt(1, 2) = HRmeanAlt_second_file(1);
            completeSetMeanAlt(2, 2) = NaN;
            completeSetMeanAlt(3, 2) = NaN;
            completeSetMeanAlt(4, 2) = NaN;
            completeSetMeanAlt(5, 2) = HRmeanAlt_second_file(2);
            completeSetMeanAlt(6, 2) = HRmeanAlt_second_file(3);
            completeSetMeanAlt(7, 2) = HRmeanAlt_second_file(4);
            completeSetMeanAlt(8, 2) = HRmeanAlt_second_file(5);
            completeSetMeanAlt(9, 2) = NaN;            
            %
            %
            completeSetSDAlt = zeros(length(first_file.HRInterp), 2);
            %
            completeSetSDAlt(:, 1) = HRstdevAlt_first_file;
            %
            completeSetSDAlt(1, 2) = HRstdevAlt_second_file(1);
            completeSetSDAlt(2, 2) = NaN;
            completeSetSDAlt(3, 2) = NaN;
            completeSetSDAlt(4, 2) = NaN;
            completeSetSDAlt(5, 2) = HRstdevAlt_second_file(2);
            completeSetSDAlt(6, 2) = HRstdevAlt_second_file(3);
            completeSetSDAlt(7, 2) = HRstdevAlt_second_file(4);
            completeSetSDAlt(8, 2) = HRstdevAlt_second_file(5);
            completeSetSDAlt(9, 2) = NaN; 
            
        elseif strcmp(session{i_session}, 'ECG_2014_10_20') && strcmp(effects{i_effects}, 'Yoga')
            
            completeSetMean = zeros(length(first_file.HRInterp), 2);
            %
            completeSetMean(:, 1) = HRmean_first_file;
            %
            completeSetMean(1, 2) = HRmean_second_file(1);
            completeSetMean(2, 2) = HRmean_second_file(2);
            completeSetMean(3, 2) = HRmean_second_file(3);
            completeSetMean(4, 2) = NaN;
            completeSetMean(5, 2) = HRmean_second_file(4);
            completeSetMean(6, 2) = NaN;
            completeSetMean(7, 2) = HRmean_second_file(5);
            completeSetMean(8, 2) = HRmean_second_file(6);
            completeSetMean(9, 2) = NaN;
            %
            %
            completeSetSD = zeros(length(first_file.HRInterp), 2);
            %
            completeSetSD(:, 1) = HRstdev_first_file;
            %
            completeSetSD(1, 2) = HRstdev_second_file(1);
            completeSetSD(2, 2) = HRstdev_second_file(2);
            completeSetSD(3, 2) = HRstdev_second_file(3);
            completeSetSD(4, 2) = NaN;
            completeSetSD(5, 2) = HRstdev_second_file(4);
            completeSetSD(6, 2) = NaN;
            completeSetSD(7, 2) = HRstdev_second_file(5);
            completeSetSD(8, 2) = HRstdev_second_file(6);
            completeSetSD(9, 2) = NaN;
            
            %%%
            
            completeSetMeanAlt = zeros(length(first_file.HRInterp), 2);
            %
            completeSetMeanAlt(:, 1) = HRmeanAlt_first_file;
            %
            completeSetMeanAlt(1, 2) = HRmeanAlt_second_file(1);
            completeSetMeanAlt(2, 2) = HRmeanAlt_second_file(2);
            completeSetMeanAlt(3, 2) = HRmeanAlt_second_file(3);
            completeSetMeanAlt(4, 2) = NaN;
            completeSetMeanAlt(5, 2) = HRmeanAlt_second_file(4);
            completeSetMeanAlt(6, 2) = NaN;
            completeSetMeanAlt(7, 2) = HRmeanAlt_second_file(5);
            completeSetMeanAlt(8, 2) = HRmeanAlt_second_file(6);
            completeSetMeanAlt(9, 2) = NaN;            
            %
            %
            completeSetSDAlt = zeros(length(first_file.HRInterp), 2);
            %
            completeSetSDAlt(:, 1) = HRstdevAlt_first_file;
            %
            completeSetSDAlt(1, 2) = HRstdevAlt_second_file(1);
            completeSetSDAlt(2, 2) = HRstdevAlt_second_file(2);
            completeSetSDAlt(3, 2) = HRstdevAlt_second_file(3);
            completeSetSDAlt(4, 2) = NaN;
            completeSetSDAlt(5, 2) = HRstdevAlt_second_file(4);
            completeSetSDAlt(6, 2) = NaN;
            completeSetSDAlt(7, 2) = HRstdevAlt_second_file(5);
            completeSetSDAlt(8, 2) = HRstdevAlt_second_file(6);
            completeSetSDAlt(9, 2) = NaN;              
            
        elseif strcmp(session{i_session}, 'ECG_2014_10_21') && strcmp(effects{i_effects}, 'PM2_alt')
            
            completeSetMean = zeros(8, 2);
            %
            completeSetMean(1, 1) = HRmean_first_file(1);
            completeSetMean(2, 1) = HRmean_first_file(2);
            completeSetMean(3, 1) = HRmean_first_file(3);
            completeSetMean(4, 1) = NaN;
            completeSetMean(5, 1) = HRmean_first_file(4);
            completeSetMean(6, 1) = HRmean_first_file(5);
            completeSetMean(7, 1) = HRmean_first_file(6);
            completeSetMean(8, 1) = HRmean_first_file(7);
            %
            completeSetMean(1, 2) = HRmean_second_file(1);
            completeSetMean(2, 2) = HRmean_second_file(2);
            completeSetMean(3, 2) = HRmean_second_file(3);
            completeSetMean(4, 2) = NaN;
            completeSetMean(5, 2) = NaN;
            completeSetMean(6, 2) = HRmean_second_file(4);
            completeSetMean(7, 2) = HRmean_second_file(5);
            completeSetMean(8, 2) = HRmean_second_file(6);
            %
            %
            completeSetSD = zeros(8, 2);
            %
            completeSetSD(1, 1) = HRstdev_first_file(1);
            completeSetSD(2, 1) = HRstdev_first_file(2);
            completeSetSD(3, 1) = HRstdev_first_file(3);
            completeSetSD(4, 1) = NaN;
            completeSetSD(5, 1) = HRstdev_first_file(4);
            completeSetSD(6, 1) = HRstdev_first_file(5);
            completeSetSD(7, 1) = HRstdev_first_file(6);
            completeSetSD(8, 1) = HRstdev_first_file(7);
            %
            completeSetSD(1, 2) = HRstdev_second_file(1);
            completeSetSD(2, 2) = HRstdev_second_file(2);
            completeSetSD(3, 2) = HRstdev_second_file(3);
            completeSetSD(4, 2) = NaN;
            completeSetSD(5, 2) = NaN;
            completeSetSD(6, 2) = HRstdev_second_file(4);
            completeSetSD(7, 2) = HRstdev_second_file(5);
            completeSetSD(8, 2) = HRstdev_second_file(6);
            
            %%%
            
            completeSetMeanAlt = zeros(8, 2);
            %
            completeSetMeanAlt(1, 1) = HRmeanAlt_first_file(1);
            completeSetMeanAlt(2, 1) = HRmeanAlt_first_file(2);
            completeSetMeanAlt(3, 1) = HRmeanAlt_first_file(3);
            completeSetMeanAlt(4, 1) = NaN;
            completeSetMeanAlt(5, 1) = HRmeanAlt_first_file(4);
            completeSetMeanAlt(6, 1) = HRmeanAlt_first_file(5);
            completeSetMeanAlt(7, 1) = HRmeanAlt_first_file(6);
            completeSetMeanAlt(8, 1) = HRmeanAlt_first_file(7);             
            %
            completeSetMeanAlt(1, 2) = HRmeanAlt_second_file(1);
            completeSetMeanAlt(2, 2) = HRmeanAlt_second_file(2);
            completeSetMeanAlt(3, 2) = HRmeanAlt_second_file(3);
            completeSetMeanAlt(4, 2) = NaN;
            completeSetMeanAlt(5, 2) = NaN;
            completeSetMeanAlt(6, 2) = HRmeanAlt_second_file(4);
            completeSetMeanAlt(7, 2) = HRmeanAlt_second_file(5);
            completeSetMeanAlt(8, 2) = HRmeanAlt_second_file(6);           
            %
            %
            completeSetSDAlt = zeros(8, 2);
            %
            completeSetSDAlt(1, 1) = HRstdevAlt_first_file(1);
            completeSetSDAlt(2, 1) = HRstdevAlt_first_file(2);
            completeSetSDAlt(3, 1) = HRstdevAlt_first_file(3);
            completeSetSDAlt(4, 1) = NaN;
            completeSetSDAlt(5, 1) = HRstdevAlt_first_file(4);
            completeSetSDAlt(6, 1) = HRstdevAlt_first_file(5);
            completeSetSDAlt(7, 1) = HRstdevAlt_first_file(6);
            completeSetSDAlt(8, 1) = HRstdevAlt_first_file(7);
            %
            completeSetSDAlt(1, 2) = HRstdevAlt_second_file(1);
            completeSetSDAlt(2, 2) = HRstdevAlt_second_file(2);
            completeSetSDAlt(3, 2) = HRstdevAlt_second_file(3);
            completeSetSDAlt(4, 2) = NaN;
            completeSetSDAlt(5, 2) = NaN;
            completeSetSDAlt(6, 2) = HRstdevAlt_second_file(4);
            completeSetSDAlt(7, 2) = HRstdevAlt_second_file(5);
            completeSetSDAlt(8, 2) = HRstdevAlt_second_file(6);            
            
        elseif strcmp(session{i_session}, 'ECG_2014_10_21') && strcmp(effects{i_effects}, 'Yoga')
            
            completeSetMean = zeros(length(first_file.HRInterp), 2);
            %
            completeSetMean(:, 1) = HRmean_first_file;
            %
            completeSetMean(1, 2) = HRmean_second_file(1);
            completeSetMean(2, 2) = HRmean_second_file(2);
            completeSetMean(3, 2) = HRmean_second_file(3);
            completeSetMean(4, 2) = HRmean_second_file(4);
            completeSetMean(5, 2) = HRmean_second_file(5);
            completeSetMean(6, 2) = HRmean_second_file(6);
            completeSetMean(7, 2) = NaN;
            completeSetMean(8, 2) = NaN;
            completeSetMean(9, 2) = NaN;
            completeSetMean(10, 2) = HRmean_second_file(7);
            %
            %
            completeSetSD = zeros(length(first_file.HRInterp), 2);
            %
            completeSetSD(:, 1) = HRstdev_first_file;
            %
            completeSetSD(1, 2) = HRstdev_second_file(1);
            completeSetSD(2, 2) = HRstdev_second_file(2);
            completeSetSD(3, 2) = HRstdev_second_file(3);
            completeSetSD(4, 2) = HRstdev_second_file(4);
            completeSetSD(5, 2) = HRstdev_second_file(5);
            completeSetSD(6, 2) = HRstdev_second_file(6);
            completeSetSD(7, 2) = NaN;
            completeSetSD(8, 2) = NaN;
            completeSetSD(9, 2) = NaN;
            completeSetSD(10, 2) = HRstdev_second_file(7);
            
            %%%
            
            completeSetMeanAlt = zeros(length(first_file.HRInterp), 2);
            %
            completeSetMeanAlt(:, 1) = HRmeanAlt_first_file;
            %
            completeSetMeanAlt(1, 2) = HRmeanAlt_second_file(1);
            completeSetMeanAlt(2, 2) = HRmeanAlt_second_file(2);
            completeSetMeanAlt(3, 2) = HRmeanAlt_second_file(3);
            completeSetMeanAlt(4, 2) = HRmeanAlt_second_file(4);
            completeSetMeanAlt(5, 2) = HRmeanAlt_second_file(5);
            completeSetMeanAlt(6, 2) = HRmeanAlt_second_file(6);
            completeSetMeanAlt(7, 2) = NaN;
            completeSetMeanAlt(8, 2) = NaN;
            completeSetMeanAlt(9, 2) = NaN;
            completeSetMeanAlt(10, 2) = HRmeanAlt_second_file(7);
            %
            %
            completeSetSDAlt = zeros(length(first_file.HRInterp), 2);
            %
            completeSetSDAlt(:, 1) = HRstdevAlt_first_file;
            %
            completeSetSDAlt(1, 2) = HRstdevAlt_second_file(1);
            completeSetSDAlt(2, 2) = HRstdevAlt_second_file(2);
            completeSetSDAlt(3, 2) = HRstdevAlt_second_file(3);
            completeSetSDAlt(4, 2) = HRstdevAlt_second_file(4);
            completeSetSDAlt(5, 2) = HRstdevAlt_second_file(5);
            completeSetSDAlt(6, 2) = HRstdevAlt_second_file(6);
            completeSetSDAlt(7, 2) = NaN;
            completeSetSDAlt(8, 2) = NaN;
            completeSetSDAlt(9, 2) = NaN; 
            completeSetSDAlt(10, 2) = HRstdevAlt_second_file(7);            
            
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