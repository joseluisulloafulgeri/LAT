
% script for re-organize files in a folder
% JLUF 04/10/2014
% to launch in /home/joseluis/Documents/transfering_files_labodanse/watchs

%% 1. get the content of the main folder
first_level = dir;

first_level_2 = {}; zet = 1;
for i_val = 1:length(first_level)
    first_level_2{zet} = first_level(i_val).name;
    zet = zet + 1;
end
first_level_2 = first_level_2(3:end); % first two are useless (. and ..) first two are useless (. and ..)

%% 2. get into each folder
for i_folder = 1:length(first_level_2)
    
    cd (first_level_2{i_folder})
    
    second_level = dir;
    second_level_2 = {}; zet = 1;
    for x_val = 1:length(second_level)
        second_level_2{zet} = second_level(x_val).name;
        zet = zet + 1;
    end
    
    second_level_2 = second_level_2(3:end); % first two are useless (. and ..) first two are useless (. and ..)
    
    for y_folder = 1:length(second_level_2)
        
        cd (second_level_2{y_folder})
        
        third_level = dir;
        third_level_2 = {}; zet = 1;
        for w_val = 1:length(third_level)
            third_level_2{zet} = third_level(w_val).name;
            zet = zet + 1;
        end
        
        third_level_2 = third_level_2(3:end); % first two are useless (. and ..) first two are useless (. and ..)
        
        for yx_folder = 1:length(third_level_2)
            
            cd (third_level_2{yx_folder})
            
            fourth_level = dir;
            fourth_level_2 = fourth_level(3:end); % first two are useless (. and ..) first two are useless (. and ..)
            
            %% 3. get the bytes
            fourth_level_bytes = {}; counter = 1;
            for c_val = 1:length(fourth_level_2)
                fourth_level_bytes{counter} = fourth_level_2(c_val).bytes;
                counter = counter + 1;
            end
            
            %% 4. check for low bytes files, set threshold
            
            if regexp(third_level_2{i_folder},'bh') > 0;
                % BH files 124 bytes (one line labels)
                threshold = 124;
                
            elseif regexp(third_level_2{i_folder},'eng') > 0;
                % ENG files 1400 bytes
                threshold = 1400;
                
            elseif regexp(third_level_2{i_folder},'mp') > 0;
                % MP files 200000 bytes
                threshold = 200000;
                
            elseif regexp(third_level_2{i_folder},'ppt_am') > 0;
                threshold = 500;
                
            elseif regexp(third_level_2{i_folder},'ppt_pm') > 0;
                threshold = 500;
                
            elseif regexp(third_level_2{i_folder},'tap_am') > 0;
                threshold = 500;
                
            elseif regexp(third_level_2{i_folder},'tap_pm') > 0;
                threshold = 500;
                
            end
            
            bytes_good = cell2mat(fourth_level_bytes) >threshold;
            
            %% 5. create list of files to export
            names_export = {}; counter = 1;
            for x_bytes = 1:length(fourth_level_2)
                if bytes_good(x_bytes) == 1;
                    % ok
                else
                    names_export{counter} = fourth_level_2(x_bytes).name;
                    counter = counter + 1;
                end
            end
            
            %% 6. create the folder with low bytes files
            
            
            % check folder existence
            if exist('low_bytes_files', 'dir') == 0;
                mkdir low_bytes_files
            else
                % nothing
            end
            
            if isempty(names_export) == 0 % check if there are files to export
                
                %% 7. move the files there
                for i_export = 1:length(names_export)
                    movefile(names_export{i_export}, 'low_bytes_files')
                end
                
            else
                % nothing
            end
        cd ..    
        end
    cd ..
    end
cd ..
end
%% END