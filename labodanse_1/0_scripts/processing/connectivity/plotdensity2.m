
correlationsMeasures = {'MC1'};
dataType = {'HR' 'BR'};
%dataType = {'y'};

% % setting variables
% lengthWindow = 105; % in seconds, e.g. 60 sec for 1 Hz data / or in centiseconds, e.g. 600 csec for 10 Hz data
% lengthStep = 105; % in seconds, e.g. 60 sec for 1 Hz data / or in centiseconds, e.g. 600 csec for 10 Hz data
% lengthOverlap = lengthWindow - lengthStep; % degree of overlap given the lengthStep
% 
% if lengthWindow == lengthStep % no overlap
%     nFullWindows = floor( length(data)/(lengthWindow - lengthOverlap) ); % e.g. 430/(60 - 0) = ~7 [each min & no overlap]
% else
%     nFullWindows = floor( (length(data) - lengthWindow) / (lengthWindow - lengthOverlap) );
% end

nFullWindows = 4;
comparisonsOfInterest = {'intraD_YpvsYm' 'interD_YmDvsYpD' 'interD_YmDvsYpD2'};

for i_measures = 1:length(correlationsMeasures)
    for i_dataType = 1:length(dataType)
        for i_lag = 1:nFullWindows
        
            file = sprintf('EachD_%s_lag00%d_%sdata.mat', ...
                correlationsMeasures{i_measures}, i_lag, dataType{i_dataType});
            % open file
            load(file);

            for i_comparisson = 1:length(comparisonsOfInterest)

                if i_comparisson == 1;

                    data1 = eachMeasuresDance(:,1);
                    data2 = eachMeasuresDance(:,2);

                elseif i_comparisson == 2;

                    data1 = eachMeasuresDance(:,5);
                    data2 = eachMeasuresDance(:,6);

                elseif i_comparisson == 3;

                    data1 = eachMeasuresDance(:,8);
                    data2 = eachMeasuresDance(:,9);

                end

                mean1 = mean(data1);
                mean2 = mean(data2);

                data1b = [data1; mean1];
                data2b = [data2; mean2];
                data3 = [data1b data2b];

                figure,
                set(gcf, 'units', 'normalized', 'position', [0 0 .8 .7]);
                bar(data3)

                % adding axis labels and title
                xlabel('Samples (+ mean (last))', 'FontSize', 20)

                if i_comparisson == 1;
                    ylabel('Connectivity index (IntraDensity)', 'FontSize', 20)
                else
                    ylabel('Connectivity index (InterDensity)', 'FontSize', 20)
                end

                title(horzcat('Connectivity measures for ', dataType{i_dataType}, '-', correlationsMeasures{i_measures}), 'FontSize', 20)

                if i_comparisson == 1;
                    h_legend = legend({'yoga +'; 'yoga -'}); % add legend
                else
                    h_legend = legend({'yoga -'; 'yoga +'}); % add legend
                end

                set(h_legend,'FontSize',20); % make legend smaller
                set(h_legend,'color','none'); % make legend background transparent
                set(gca,'xtick',[])

                tightfig;

                pvalue = ranksum(data1, data2);

                statsText = sprintf('stats, p = %.3f', pvalue);

                ylim = get(gca,'ylim');
                xlim = get(gca,'xlim');
                text(xlim(1),ylim(2)-0.03,statsText)

                % save
                nameFigure = sprintf('D_%s_%sdata_lag00%d_%s.png', ...
                    correlationsMeasures{i_measures}, dataType{i_dataType}, i_lag, comparisonsOfInterest{i_comparisson});
                saveas(gcf, nameFigure);
                close(gcf);
            end
            
        end
    end
end

% END