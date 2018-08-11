
% selectgooddata.m
% exclude subjects whose means are above or below 2SD of the grand mean
% apply in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_8
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_new/bioharness_8
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_2/2_data_analysis/bioharness_new/bioharness_8

% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness_reloaded/bioharness_4

% created by JLUF 14/08/2015

%%

% get the content of the main folder
files = dir('*Means*.txt');

for i_dataset = 1:length(files)
    groupData = importdata(files(i_dataset).name);
    meanGroupData1 = nanmean(groupData(:,1));
    meanGroupData2 = nanmean(groupData(:,2));
    SDGroupData1 = nanstd(groupData(:,1));
    SDGroupData2 = nanstd(groupData(:,2));
    alpha_1_inf = meanGroupData1 - 2*SDGroupData1;
    alpha_1_sup = meanGroupData1 + 2*SDGroupData1;
    alpha_2_inf = meanGroupData2 - 2*SDGroupData2;
    alpha_2_sup = meanGroupData2 + 2*SDGroupData2;
    
    groupDataGood = groupData;
    
    for i_rowdatapoint = 1:length(groupData)
        for i_columndatapoint = 1:size(groupData, 2)
            if i_columndatapoint == 1
                Threshold_inf = alpha_1_inf;
                Threshold_sup = alpha_1_sup;
            elseif i_columndatapoint == 2;
                Threshold_inf = alpha_2_inf;
                Threshold_sup = alpha_2_sup;
            end
            if groupData(i_rowdatapoint, i_columndatapoint) < Threshold_inf || groupData(i_rowdatapoint, i_columndatapoint) > Threshold_sup
                groupDataGood(i_rowdatapoint, i_columndatapoint) = NaN;
            end
        end
    end
 
    %% Saving 
    
    [pathstr,fileNameClean,ext] = fileparts(files(i_dataset).name);
    nameFileMean = sprintf('%s_Good.txt', fileNameClean);
    %save
    csvwrite(nameFileMean, groupDataGood)
    
end

% END