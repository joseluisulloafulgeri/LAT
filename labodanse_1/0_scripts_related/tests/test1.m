
time_markers_list = []; time_marker_cell = {};

    for i_index = 1:length(time_markers_info) % 8
        
        if time_markers_info(i_index) < fileStruct.common_seconds(end)
            time_markers_list(i_index) = find(fileStruct.common_seconds >= (time_markers_info(i_index))-1,1,'first');
            
            if i_index < length(time_markers_info) % index < 8
                if time_markers_info(i_index +1) < fileStruct.common_seconds(end)
                    time_markers_list(i_index +1) = find(fileStruct.common_seconds >= (time_markers_info(i_index +1))-1,1,'first');
                end
            else
                if time_markers_info(i_index +1) < fileStruct.common_seconds(end)
                    time_markers_list(i_index +1) = length(fileStruct.common_seconds);
                end
            end
            time_marker_cell(time_markers_list(i_index):time_markers_list(i_index+1)) = time_markers_names(i_index);
        end
    end