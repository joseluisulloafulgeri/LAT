
% computeHRBRmeans.m
% inspired from visualizeHRBR.m & computeHRmean_1.m

% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_reloaded/bioharness_2
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_2/2_data_analysis/bioharness_reloaded/bioharness_2

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
            %first_data = first_data';
            % second file - after effect
            logicDataSecond = strcmp(FileStruct.mrkTime, effect2);
            second_data = squeeze(FileStruct.data(logicDataSecond, i_dataType, :));
            %second_data = second_data';           
            
            %% Average
            
            % average
            mean_first_file = zeros(size(first_data, 2), 1);
            stdev_first_file = zeros(size(first_data, 2), 1);
            alpha_first_file_inf = zeros(size(first_data, 2), 1);
            alpha_first_file_sup = zeros(size(first_data, 2), 1);
            for i_mean = 1:length(mean_first_file)
                mean_first_file(i_mean) = mean(first_data(:, i_mean));
                stdev_first_file(i_mean) = std(first_data(:, i_mean));
                alpha_first_file_inf(i_mean) = mean_first_file(i_mean) - 2*stdev_first_file(i_mean);
                alpha_first_file_sup(i_mean) = mean_first_file(i_mean) + 2*stdev_first_file(i_mean);
            end
            
            % average
            mean_second_file = zeros(size(second_data, 2), 1);
            stdev_second_file = zeros(size(second_data, 2), 1);
            alpha_second_file_inf = zeros(size(first_data, 2), 1);
            alpha_second_file_sup = zeros(size(first_data, 2), 1);
            for i_mean = 1:length(mean_second_file)
                mean_second_file(i_mean) = mean(second_data(:, i_mean));
                stdev_second_file(i_mean) = std(second_data(:, i_mean));
                alpha_second_file_inf(i_mean) = mean_second_file(i_mean) - 2*stdev_second_file(i_mean);
                alpha_second_file_sup(i_mean) = mean_second_file(i_mean) + 2*stdev_second_file(i_mean);
            end
            
            %% Alternative Average
            
            % average
            meanAlt_first_file = zeros(size(first_data, 2), 1);
            stdevAlt_first_file = zeros(size(first_data, 2), 1);
            for i_mean = 1:length(meanAlt_first_file)
                length_now = size(first_data, 1); % length of the current individual dataset
                logic_good_data = true(1, length_now); % create logical vector
                for i_data = 1:length_now
                    if first_data(i_data, i_mean) < alpha_first_file_inf(i_mean) || first_data(i_data, i_mean) > alpha_first_file_sup(i_mean)
                        logic_good_data(i_data) = false;
                    end
                end
                data = first_data(:,i_mean);
                meanAlt_first_file(i_mean) = mean(data(logic_good_data));
                stdevAlt_first_file(i_mean) = std(data(logic_good_data));
            end
            
            % average
            meanAlt_second_file = zeros(size(second_data, 2), 1);
            stdevAlt_second_file = zeros(size(second_data, 2), 1);
            for i_mean = 1:length(meanAlt_second_file)
                length_now = size(second_data, 1); % length of the current individual dataset
                logic_good_data = true(1, length_now); % create logical vector
                for i_data = 1:length_now
                    if second_data(i_data, i_mean) < alpha_second_file_inf(i_mean) || second_data(i_data, i_mean) > alpha_second_file_sup(i_mean)
                        logic_good_data(i_data) = false;
                    end
                end
                data = second_data(:,i_mean);
                meanAlt_second_file(i_mean) = mean(data(logic_good_data));
                stdevAlt_second_file(i_mean) = std(data(logic_good_data));
            end
            
            %% Putting data together
                
            completeSetMean = [mean_first_file mean_second_file];
            completeSetSD = [stdev_first_file stdev_second_file];
            completeSetMeanAlt = [meanAlt_first_file meanAlt_second_file];
            completeSetSDAlt = [stdevAlt_first_file stdevAlt_second_file];
            
            %% Saving
            
            ouputFolder = sprintf('../%s', destinyFolder);
            cd (ouputFolder)
            
            %varText =
            nameFileMean = sprintf('%s_%s_Means_%s.txt', session{i_session}, section{i_section}, dataType{i_dataType});
            nameFileSD = sprintf('%s_%s_SD_%s.txt', session{i_session}, section{i_section}, dataType{i_dataType});
            nameFileMeanAlt = sprintf('%s_%s_MeansAlt_%s.txt', session{i_session}, section{i_section}, dataType{i_dataType});
            nameFileSDAlt = sprintf('%s_%s_SDAlt_%s.txt', session{i_session}, section{i_section}, dataType{i_dataType});
            
            %save
            csvwrite(nameFileMean, completeSetMean)
            csvwrite(nameFileSD, completeSetSD)
            csvwrite(nameFileMeanAlt, completeSetMeanAlt)
            csvwrite(nameFileSDAlt, completeSetSDAlt)
            
            cd (sourcePath)
            
        end
    end
end
