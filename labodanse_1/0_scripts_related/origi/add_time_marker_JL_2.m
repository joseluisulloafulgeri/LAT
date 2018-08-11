% file to use :



%% add time marker (version JL - 1)

% 19/11/14 : l.48 / l.28 ! ! / l. 62 / l.82


clear all
close all

% script to run in ./2_data_analysis

file_in_folder = dir;
file_in_folder = file_in_folder(3:end); % so as not to take into account the /. and /..

n_file = length(file_in_folder)

% afficher les dossiers

for ii = 1 : n_file
    sentence_choice = [num2str(ii),') ',file_in_folder(ii).name];
    disp(sentence_choice)
end

% choisir la structure à marquer

choice = input('In which structure do you want to add time markers ?')

var_1 = load (file_in_folder(choice).name) % the number 5 is 2101014_PM2 : because all 
structName=fieldnames(var_1)
fileStruct = getfield(var_1,structName{1}) % voir comment automatiser / gérer le nom du fichier 

% entrer le tableau de découpage

% './../../1_data_organized_to_send/2014_10_21_PM2/9_film/timing.csv'   
timing_tab_dir = input ('Enter the full directory of the ''timing tab'' : ')
fid = fopen(timing_tab_dir)
timing_tab = textscan(fid,'%f%s','Delimiter',';')

% créer les marqueurs 

%% déterminer les indexs temporels limites

for oi = 1 : length(timing_tab{1})
    timing_tab_2index(oi) = find(fileStruct.data(:,1,1)>= timing_tab{1}(oi),1,'first'); 
    if oi ~= length(timing_tab{1})
        timing_tab_2index(oi+1) = find(fileStruct.data(:,1,1)>= timing_tab{1}(oi+1),1,'first');
    else
        timing_tab_2index(oi+1) = length(fileStruct.data(:,1,1));
    end
    time_marker_cell (timing_tab_2index(oi):timing_tab_2index(oi+1)) = timing_tab{2}(oi); % voir -1 pour ne pas se marcher dessus.......
end

% if timing_tab_2index(1)~= 1
%      time_marker_cell (1:timing_tab_2index(1)) = 'before'; % voir -1 pour ne pas se marcher dessus......  
% end


%% fill the MARK fields

if isfield(fileStruct,'marker_tab')==0
    fileStruct.marker_tab{1}= time_marker_cell;
    fileStruct.marker_type{1} = timing_tab;
else
    fileStruct.marker_tab{size(fileStruct.marker_tab,1)+1} = time_marker_cell;
    fileStruct.marker_type{size(fileStruct.marker_type,1)+1,1} = timing_tab;  
end


%% Delete cells in the mark fields...


fileStruct

% enregistrer ou ne pas enregistrer

sav = input('Do you want to save the freshly marked structure ? Y=1 / N=0')

if sav ==1
    % var_1 = load (file_in_folder(choice).name) % the number 5 is 2101014_PM2 : because all
    % structName=fieldnames(var_1)
    % fileStruct = getfield(var_1,structName{1})
    
    save(fileStruct.name,'fileStruct') % enregistre dans le fichier qui a pour nom le champ fileStruct.name ! ! 
end



