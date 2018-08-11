
% makevideo2.m
% make video from png images
% apply in:
% locally

% created by JLUF 00/10/2014

%%

%delete ('video2.avi')
workingDir = pwd;

%get the data
files4 = dir('*.png');
filesNames = {files4.name};
%filesNames{end} = []; when there was the wholeWindow file
%filesNames = filesNames(:,1:length(filesNames)-1); % I eliminate the last one,

%Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
outputVideo = VideoWriter(fullfile(workingDir,'video2.avi'));
outputVideo.FrameRate = 1;
open(outputVideo)

%Loop through the image sequence, load each image, and then write it to the video.
for ii = 1:length(filesNames)
    img = imread(fullfile(workingDir,filesNames{ii}));
    writeVideo(outputVideo,img)
end
close(outputVideo)
           