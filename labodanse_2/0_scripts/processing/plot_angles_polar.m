% inspired from plot_angles.m

% JLUF 08/09/2016

%% Defining the destiny folder

destinyFolder = input('Folder name to save the data? > ', 's');
% example: > bioharness_3
sourcePath = pwd;

%% Variables of interest

markersOfInterest = {'solo_1' 'duo_1' 'solo_2' 'duo_2'};
markersOfInterestNames = {'solo 1' 'duo 1' 'solo 2' 'duo 2'};

%% Get the names of the structures

cd C:\Users\jose\Documents\OtherProjects\Labodanse\transfering_files_labodanse_2\2_data_analysis\bioharness_2016\bioharness_2

files = dir('*.mat');
filesNames = {files.name}; % e.g. 'Bioharness_2014_10_20_PM1.mat' ...

for i_struct = 1:length(filesNames)
    
    session = i_struct;
    
    %% Load structures
    load(filesNames{i_struct});
    dataType = FileStruct.dataList;
    [pathstr,fileNameClean,ext] = fileparts(filesNames{i_struct});
    freqList = FileStruct.freqs;
    
    nameSubj = FileStruct.subjectList;
    nameSubj = cellfun (@(x) x(1:3), nameSubj, 'UniformOutput', false);
    
    for i_freq = 1:length(freqList)
        for iDanceType = 1:length(markersOfInterest)
            
            % set the values of interest according to the dance type
            indexMarkersLogic = ismember(FileStruct.mrkTime, markersOfInterest{iDanceType});
            
            % getting the data
            Values = FileStruct.data(indexMarkersLogic, i_freq, :);
            Values = squeeze(Values); % e.g. 430x8
            
            TOI = 15;
            samplesOfInt = TOI*FileStruct.samplingFrequency;
            Interval = floor(length(Values)/samplesOfInt);
            intervalTaken = 1;
            
            for i_time = 1:Interval
                
                Values2 = Values(intervalTaken : intervalTaken+samplesOfInt-1,:);
                
                % plot for all angles
                for i_subject = 1:size(Values2, 2)
                    subjValue = Values2(:,i_subject);
                    subjValue = subjValue';
                    
                    figure,
                    set(gcf,'Visible','off');
                    set(gcf, 'units', 'normalized', 'position', [0 0 .5 .7]);
                    h1 = polar(...
                        [zeros(1, size(subjValue, 2)); subjValue], ... % angle (vector phase)
                        [zeros(1, size(subjValue, 2)); ones(1, size(subjValue, 2))]); % absoulte(vector length) --> here setted to 1
                    title(nameSubj{i_subject})
                    
                    %%%save
                    inputFolder = sourcePath;
                    outputFolder = sprintf('../%s', destinyFolder);
                    cd (outputFolder)
                    nameFigure = sprintf('PP_sess%d_%s_T%d_%s_%0.2fHz.png', session, markersOfInterest{iDanceType}, i_time, nameSubj{i_subject}, FileStruct.freqs(i_freq));
                    saveas(gcf, nameFigure);
                    close(gcf);
                end
                
                % plot for the mean angle for each subject and dance part
                figure,
                t = 0:.01:2*pi;
                P = polar(t, 0.2 * ones(size(t)));
                set(P, 'Visible', 'off')
                hold on
                angleMeans = zeros(1, size(Values2, 2));
                for i_subject = 1:size(Values2, 2)
                    subjValue = Values2(:,i_subject);
                    subjValue = subjValue';
                    angleMeans(i_subject) = mean(exp(1i*subjValue));
                    set(gcf,'Visible','off');
                    h3 = polar(...
                        [0 angle(angleMeans(i_subject))],...
                        [0 abs(angleMeans(i_subject))]);
                    set(h3, 'linewidth', 3, 'linestyle', '-')
                    hold on
                end
                titleFigure = sprintf('sess%d %s T%d %0.2fHz', session, markersOfInterest{iDanceType}, i_time, FileStruct.freqs(i_freq));
                title(titleFigure)
                hold off
                nameSubj2 = nameSubj;
                nameSubj2{9} = '--';
                nameSubj2 = circshift(nameSubj2, 1);
                legendDat = (char(nameSubj2));
                legend1 = legend(legendDat);
                
                %%%save
                nameFigure = sprintf('PPAvg_sess%d_%s_T%d_%0.2fHz.png', session, markersOfInterest{iDanceType}, i_time, FileStruct.freqs(i_freq));
                saveas(gcf, nameFigure);
                close(gcf);
                
                cd (inputFolder)
                
                intervalTaken = intervalTaken+samplesOfInt;
            end
        end
    end
end

% END