
% addmarkers.m
% USE: add markers 1D to structures
% INPUT: structures + csv files with markers
% OUPUT: structures (with 2 extra field markers 1D)
% ROOTS: folder containing the structures

% so far, to run in 2_data_analysis/

% created: YF 31/11/2014; modified: JLUF 01/12/2014
% last update: 28/01/2015

%% Defining the destiny folder 

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_2
sourcePath = pwd;

%% Define marker type

markerType = 'danceType';

%% Get the names of the structures

files = dir('*_PM*'); % e.g. '*20_PM*' or '*21_PM1*' '*HRBR*21_PM2*'
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    %% Load structures
    load(filesNames{i_struct});
    
    %% Get markers files
    
    structName = FileStruct.name;
    %markersFileName = sprintf('%s_%s.csv', markerType, char(structName(6:19))); % HRBR
    markersFileName = sprintf('%s_%s.csv', markerType, char(structName(12:25))); % engagement
    %markersFileName = sprintf('%s_%s.csv', markerType, char(structName(6:19)));
    markerLocation = sprintf('../../../1_data_markers/%s', markerType);
    markerPath = fullfile(markerLocation, markersFileName);
    
    % open files
    fid = fopen(markerPath);
    timeMarkersFile = textscan(fid,'%f%s','Delimiter',';');
    
    timeMarkersInfo = timeMarkersFile{1}; % e.g. [69435;69856;69893;70319;70287;70770;70802;71227]
    timeMarkersNames = timeMarkersFile{2}; % e.g. {'solo_1' 'interlude_1' 'duo_1' 'interlude_2' 'solo_2' 'interlude_3' 'duo_2' 'fin'}
    
    % correction applied to files 10_21
    
%    PM1
%    timeMarkersInfo = timeMarkersInfo - 60;
%    PM2
%    timeMarkersInfo = timeMarkersInfo - 60;
%    timeMarkersInfo(4) = 70255;
%    timeMarkersInfo(5) = 70285;
    
    %% 4. define temporal index
    
    lastIndex = FileStruct.commonSeconds(end);
    timeMarkersIndex = zeros(1, length(FileStruct.commonSeconds)); 
    timeMarkersCell = cell(1, length(FileStruct.commonSeconds));
    timeMarkersCell(:) = {'empty_marker'}; % preallocate for the no markers zone,
    
    for i_mark = 1:length(timeMarkersInfo) % e.g. 8
        
        if timeMarkersInfo(i_mark) < lastIndex % check if markeInfo index is within the length of the structure timeline
            timeMarkersIndex(i_mark) = find(FileStruct.commonSeconds >= timeMarkersInfo(i_mark),1,'first'); % create an index
            
            if i_mark ~= length(timeMarkersInfo) % e.g. ~= 8 % if i_mark is not the last one ...
                if timeMarkersInfo(i_mark +1) < lastIndex % if the next i_mark is within the length of the structure timeline
                    timeMarkersIndex(i_mark +1) = find(FileStruct.commonSeconds >= timeMarkersInfo(i_mark +1), 1, 'first'); % create the next index
                else
                    timeMarkersIndex(i_mark +1) = find(FileStruct.commonSeconds == lastIndex); %% if is the last, then, set it up as the index                    
                end
            else
                %
            end
            %% doing the time_markers_cell
            if i_mark ~= length(timeMarkersInfo) % i_mark < 8 % if i_mark is not the last one ...
                if timeMarkersInfo(i_mark) < lastIndex && timeMarkersInfo(i_mark + 1) < lastIndex % if both i_marks are within the length of the structure timeline
                    timeMarkersCell(timeMarkersIndex(i_mark):timeMarkersIndex(i_mark +1)) = timeMarkersNames(i_mark); % create the markers within that boundary

                elseif timeMarkersInfo(i_mark) < lastIndex &&  FileStruct.commonSeconds(timeMarkersIndex(i_mark +1)) == lastIndex; % if one mark is the last
                    timeMarkersCell(timeMarkersIndex(i_mark):timeMarkersIndex(i_mark +1)) = timeMarkersNames(i_mark); % create the markers it until there
                end
            else % i_mark = 8, if is the last
                if timeMarkersInfo(i_mark) < lastIndex % if is within the length of the structure timeline
                    timeMarkersCell(timeMarkersIndex(i_mark):find(FileStruct.commonSeconds == lastIndex)) = timeMarkersNames(i_mark); % create the markers it until there
                else
                    %
                end
            end
        else
            timeMarkersIndex(i_mark) = find(FileStruct.commonSeconds == lastIndex,1,'first'); % that is the index
        end
    end
    
    %% Generate fields

    FileStruct.mrkTime = timeMarkersCell';
    FileStruct.mrkTimeNames = cellstr(markerType);
    FileStruct.processingSteps{size(FileStruct.processingSteps,1)+1, 1} = [markerType, ' markers added on ', date, ' with addmarkers.m'];
    
    %% Save to the structure
    
    % change directory
    ouputFolder = sprintf('../%s', destinyFolder);
    cd (ouputFolder)
    
    name = sprintf('%s_2', FileStruct.name);
    save(name,'FileStruct');
    
    % change directory
    cd (sourcePath)
    
end

% END