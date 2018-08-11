
% archiveunnecessary2.m
% script for re-organize files in a folder
% to launch in
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse_3/2015_05_12_14_15/Bioharness

% JLUF 04/10/2014

%% get the content of the main folder
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

tabletNames = {'476' '573' '719' '749' '804' '810' '812' '819' '825' '828' '846'};

% get into each main folder
% for i_folder = 1:length(directoryNames)
%     
%     cd (directoryNames{i_folder})
    
    for i_tablet = 1:length(tabletNames)
        
        cd (tabletNames{i_tablet})
        
        files2 = dir;
        directoryNames2 = {files2([files2.isdir]).name};
        directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..','File_1' 'No Team Assigned' 'extra_file'}));
        
        for i_folder2 = 1:length(directoryNames2)
            
            cd (directoryNames2{i_folder2})
            
            mkdir no_scv_files
            movefile('*.dat', 'no_scv_files')
            movefile('*.hed', 'no_scv_files')
            movefile('*.txt', 'no_scv_files')
            
            cd ..
        end
        
        cd ..
    end
%     
%     cd ..
% end

% END