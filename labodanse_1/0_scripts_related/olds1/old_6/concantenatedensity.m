% concatenate.m

correlationsMeasures = {'MC1' 'MC2'};
sessions = 1:4;
dataType = {'HR' 'BR'};
markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};

for i_measures = 1:length(correlationsMeasures)
    for i_dataType = 1:length(dataType)
        
        allMeasuresDance = zeros(length(sessions)*length(markersOfInterest), 9);
        counter = 1;
        for i_dance = 1:length(markersOfInterest)
            for i_sessions = 1:length(sessions)
                
                file = sprintf('dens_%s_ses%d_%s_wholeW_%sdata.mat', ...
                    correlationsMeasures{i_measures}, i_sessions, markersOfInterest{i_dance}, dataType{i_dataType});
                % open file
                load(file);
                selectedData = allDensities(:, 1); % might not be all the data
                allMeasuresDance(counter,:) = selectedData';
                counter = counter + 1;
                
            end
        end
        
        %save
        nameData = sprintf('allD_%s_wholeW_%sdata', ...
        correlationsMeasures{i_measures}, dataType{i_dataType});
        save(nameData, 'allMeasuresDance');
             
    end
end