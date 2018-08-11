
% makevideo.m
% make video from png images
% appy in:
% /Users/labodance/Documents/DataAnalysis/transfering_files_labodanse/2_data_analysis/bioharness/bioharness_4/Each10seconds

% created by JLUF 00/10/2014

% 1. get names of current directory
files = dir;
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...

for iDir = 1:length(directoryNames)
    
    cd (directoryNames{iDir})
    files2 = dir;
    directoryNames2 = {files2([files2.isdir]).name};
    directoryNames2 = directoryNames2(~ismember(directoryNames2,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
    
    for iDir2 = 1:length(directoryNames2)
        
        cd (directoryNames2{iDir2})
        files3 = dir;
        directoryNames3 = {files3([files3.isdir]).name};
        directoryNames3 = directoryNames3(~ismember(directoryNames3,{'.','..'})); % e.g. '2014_10_20_AM', '2014_10_20_PM1'...
        
        for iDir3 = 1:length(directoryNames3)
            
            cd (directoryNames3{iDir3})
            %delete ('video2.avi')
            workingDir = pwd;
            
            %get the data
            files4 = dir('*Rdata.png');
            filesNames = {files4.name};
            %filesNames{end} = []; when there was the wholeWindow file
            %filesNames = filesNames(:,1:length(filesNames)-1); % I eliminate the last one,
            
            %Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
            outputVideo = VideoWriter(fullfile(workingDir,'video.avi'));
            outputVideo.FrameRate = 4;
            open(outputVideo)
            
            %Loop through the image sequence, load each image, and then write it to the video.
            for ii = 1:length(filesNames)
                img = imread(fullfile(workingDir,filesNames{ii}));
                writeVideo(outputVideo,img)
            end
            close(outputVideo)
            
            cd ..
        end
        cd ..
    end
    cd ..
end