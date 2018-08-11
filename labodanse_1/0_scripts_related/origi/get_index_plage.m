%% get_useful_time_index

% file to use : 
% struct_2open =
% 'bioharness_2014-10-20-AM_9-45-56_smpFreq.mat'
% 'bioharness_2014-10-21-AM_9-44-48_smpFreq.mat'



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

% To run in ./2_data_analysis
% struct_2open =  input('Extraire périodes temporelles de quelle structure ?')

% struct_2open =  'bioharness_2014-10-21-AM_9-44-48_smpFreq.mat'

struct_2open = 'bioharness_2014-10-20-AM_9-45-56_smpFreq.mat'

load (struct_2open)

%% afficher les différents types de marqueurs temporels
which_marker = {};
newMarker = 0

for ii = 1 : length(fileStruct.marker_tab{1})-1
    
    if isempty(fileStruct.marker_tab{1}{ii})==1
        fileStruct.marker_tab{1}{ii}='empty'; % mettre des {''} dans les cases vides des markers
    end
    if isempty(fileStruct.marker_tab{1}{ii+1})==1
        fileStruct.marker_tab{1}{ii+1}='empty'; % mettre des {''} dans les cases vides des markers
    end
    
    mark_inf= textscan(fileStruct.marker_tab{1}{ii},'%s');
    mark_sup= textscan(fileStruct.marker_tab{1}{ii+1},'%s');
    
    if strcmp(fileStruct.marker_tab{1}{ii},fileStruct.marker_tab{1}{ii+1})==0
        newMarker = newMarker + 1
       which_marker{newMarker}= fileStruct.marker_tab{1}{ii+1};
%         fileStruct.marker_tab{1}{ii}
%         fileStruct.marker_tab{1}{ii+1}
    end
end

which_marker{:}


%% choisir le type de marqueurs à utiliser

marker_2keep = input('Which marker do you want to keep ?')

%% choisir quelle périodes marquées sont à étudier

index2keep = find(ismember(fileStruct.marker_tab{1},marker_2keep))

%% choisir le type de données à conserver 

data_2keep_4bioh = [1 2 3 5];

mat2keep = fileStruct.data(index2keep,data_2keep_4bioh,:)

filName = input('name of the saved file ? ')

save(filName, 'mat2keep')



%% créer autant de cells que de périodes à étudier, afin de recevoir les
%% plages de matrices

%% déterminer les indexs de début et de fin de ces plages de matrice

% créer une fonction
%%
