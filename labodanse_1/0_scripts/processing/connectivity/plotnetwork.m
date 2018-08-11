function plotnetwork(data, subjectNo, statsOption, statsPvalue, statsThreshold, statsThresholdName, corrMethod, dataType, danceType, danceTypeName, TOI, subjectList, session, inputFolder, outputFolder)

% transform data if is engagement
if strcmp(dataType, 'HR') || strcmp(dataType, 'BR')
    % nothing

elseif strcmp(dataType, 'x') || strcmp(dataType, 'y')
    data = padarray(data, [2 2], NaN, 'post'); % add to more vectors -- the absent dancers
    statsPvalue = padarray(statsPvalue, [2 2], NaN, 'post'); % add to more vectors -- the absent dancers
    subjectNo = subjectNo + 2;
    subjectList{length(subjectList)+1} = 'C01_fake.csv';
    subjectList{length(subjectList)+1} = 'C02_fake.csv';
end

%% get the coordinates

if subjectNo == 8;

    coordinates = [
        180 200
        180 160
        140 120
        60 120
        20 160
        20 200
        80 260
        120 260];
    
elseif subjectNo == 9;

    coordinates = [
        180 200
        180 160
        140 120
        100 110
        60 120
        20 160
        20 200
        80 260
        120 260];    

elseif subjectNo == 10;

    coordinates = [
        180 220
        180 180
        160 140
        120 120
        80 120
        40 140
        20 180
        20 220
        80 280
        120 280];

elseif  subjectNo == 11;

    coordinates = [
        220 260
        220 200
        210 160
        170 120
        120 100
        70 120
        30 160
        20 200
        20 260
        100 300
        140 300];

end

% define the x and y coordinates of the plot
xcoord = coordinates(:,1);
ycoord = coordinates(:,2);

%% plot the figure

figure,
scatter(xcoord,ycoord);
set(gcf,'Visible','off');
set(gcf, 'units', 'normalized', 'position', [0 0 .5 .7]);
hold on

% axis
if subjectNo == 8 || subjectNo == 9
    axis([ 0 200 60 270 ])
    
elseif  subjectNo == 10;
    axis([ 0 200 50 310 ])
    
elseif  subjectNo == 11;
    axis([ 0 240 30 310 ])
end

% get ride of axis ticks
set(gca,'xtick',[],'ytick',[])
% set title
title([corrMethod ' ' TOI ' ' danceTypeName ], 'FontSize', 20)
tightfig;

%% stats processing

if statsOption == 0 || statsOption == 1 % stats 1 at data level I leave all
    data2 = data;
    
elseif statsOption == 2 % stats 2 at data level I leave only significant data
    
    dataB = NaN(length(data), length(data));
    % which values are below my threshold
    statsLogic = logical(statsPvalue < statsThreshold);
    % I leave only them
    dataB(statsLogic) = data(statsLogic);
    data2 = dataB;
end

% get the values of the matrix
value = abs(data2.*10);
%value(logical(eye(length(value)))) = 1;

% setting a threshold
%     for i_val = 1:size(value, 1)
%         for y_val = 1:size(value, 2)
%
%             if value(i_val, y_val) > 4;
%                 value(i_val, y_val) = value(i_val, y_val);
%             else
%                 value(i_val, y_val) = 0;
%             end
%         end
%     end
% end

%% drawing the lines that connect the vertices

link_default = [0 0 0]; % [0.2 0.2 0.2];
link_nonsignif = [0 1 1];
link_bigvalue = [1 0 0];

for centroid = 1:length(ycoord)-1 % 1 2 3 4 ... 11
    for changing = centroid + 1:length(xcoord) % 1+1 1+2
        if value(centroid, changing)~=0
            if ~isnan(value(centroid, changing))
                
                if statsOption == 0
                    
                    line([xcoord(centroid) xcoord(changing)], [ycoord(centroid) ycoord(changing)], ...
                        'LineWidth',  value(centroid, changing)/2, 'Color', link_default);
                    
                elseif statsOption == 1
                    
                    if statsPvalue(centroid, changing) < statsThreshold
                        line([xcoord(centroid) xcoord(changing)], [ycoord(centroid) ycoord(changing)], ...
                            'LineWidth',  value(centroid, changing)/2, 'Color', link_default);
                    else
                        line([xcoord(centroid) xcoord(changing)], [ycoord(centroid) ycoord(changing)], ...
                            'LineWidth',  value(centroid, changing)/2, 'Color', link_nonsignif);
                    end
                    
                elseif statsOption == 2
                    
                    if value(centroid, changing)>4
                        line([xcoord(centroid) xcoord(changing)], [ycoord(centroid) ycoord(changing)], ...
                            'LineWidth',  value(centroid, changing)/2, 'Color', link_bigvalue);
                    else
                        line([xcoord(centroid) xcoord(changing)], [ycoord(centroid) ycoord(changing)], ...
                            'LineWidth',  value(centroid, changing)/2, 'Color', link_default);
                    end
                end
            else
                % nothing
            end
        end
    end
end

%% parameters for scatter
% size of the vertices

% %all same values
% repetitionSize = subjectNo; % e.g. 8
% valueToRepeat = 300;
% size = valueToRepeat(ones(1, repetitionSize),:); % repeat value,
% size = size(:).';

% size of the vertices
%if statsOption == 0
    %sizeVertices = (nansum(value, 2))*20;
    
%elseif statsOption == 1 || statsOption == 2
    sizeVertices = (nansum(value, 2))*10;
    sizeVertices(sizeVertices == 0) = 1;
    
%end

if strcmp(dataType, 'HR') || strcmp(dataType, 'BR')
    % nothing

elseif strcmp(dataType, 'x') || strcmp(dataType, 'y')
    sizeVertices(end-1) = 50;
    sizeVertices(end) = 50;

end

sizeVertices(isnan(sizeVertices)) = 1;

% color of the vertices

% spectators
color_1 = [.2 .6 1]; % light blue
% dancers
color_2 = [1 .6 .2]; % orange

%[.6 .2 1]; % purple
%[1 .2 .6]; % rose
%[.2 1 .6]; % green
%[.2 .6 1]; % light blue
%[1 .6 .2]; % orange

if subjectNo == 8;
    colorVertex = [color_1; color_1; color_1; color_1; color_1; color_1; color_2; color_2];
elseif subjectNo == 9;
    colorVertex = [color_1; color_1; color_1; color_1; color_1; color_1; color_1; color_2; color_2];      
elseif subjectNo == 10;
    colorVertex = [color_1; color_1; color_1; color_1; color_1; color_1; color_1; color_1; color_2; color_2];
elseif  subjectNo == 11;
    colorVertex = [color_1; color_1; color_1; color_1; color_1; color_1; color_1; color_1; color_1; color_2; color_2];
end

% label of the vertices
newLabel = char(subjectList);
newLabel = newLabel(:,1:3);
labels = newLabel;
% space between the labels and the vertices
dx = 5; dy = 5;
% add the labels of the spectators and dancers
text(xcoord + dx, ycoord + dy, labels);

%% figure itself

scatter(xcoord,ycoord, sizeVertices, colorVertex, 'filled');

%% density measures

if statsOption == 0
    data3 = abs(data2);
    
elseif statsOption == 1 % stats 1 at density measures level I select significant  (but previouly there was no selection)
    
    dataB = zeros(length(data2), length(data2));
    dataB(isnan(data2)) = NaN; % NaN where there should be
    % which values are below my threshold
    statsLogic = logical(statsPvalue < statsThreshold);
    % I leave only them
    dataB(statsLogic) = data2(statsLogic);
    data3 = abs(dataB);
    
elseif statsOption == 2 % stats 2 at density measures level I select significant data (but I need a different step)
    
    dataB = zeros(length(data), length(data));
    dataB(isnan(data)) = NaN; % NaN where there should be
    % which values are below my threshold
    statsLogic = logical(statsPvalue < statsThreshold);
    % I leave only them
    dataB(statsLogic) = data(statsLogic);
    data3 = abs(dataB);
    
end

[intraDensityS, intraDensityD, interDensitySD] = computedensitySD(data3, subjectNo);
[intraDensityS1, intraDensityS2, intraDensityS3, interDensityS1S2, interDensityS2S3, interDensityS1S3] = computedensitySSD(data3, subjectNo, session);
[intraDensityA, intraDensityB, interDensityAB] = computedensitySSD2(data3, subjectNo, session);

% locating density measures text

% code to avoid "Warning: RGB color data not yet supported in Painter's mode"
set(gcf, 'Renderer', 'zbuffer')
drawnow();

% position
if subjectNo == 8
    
    x1 = 20; y1 = 90;
    x2 = 80;
    x3 = 130;
    
elseif  subjectNo == 9
    
    x1 = 20; y1 = 80;
    x2 = 80;
    x3 = 130;    
    
elseif subjectNo == 10;
    
    x1 = 20; y1 = 80;
    x2 = 80;
    x3 = 130;
    
elseif subjectNo == 11;
    
    x1 = 20; y1 = 60;
    x2 = 100;
    x3 = 160;
end

stringDensity = sprintf('intraDensity.Spec =%.3f\nintraDensity.Danc =%.3f\ninterDensity.Sp-Dn =%.3f', ...
    intraDensityS, intraDensityD, interDensitySD);
text(x1,y1,stringDensity);

stringDensity2 = sprintf('intraDensity.A =%.3f\nintraDensity.B =%.3f\nintraDensity.C =%.3f\ninterDensity.AB =%.3f\ninterDensity.BC =%.3f\ninterDensity.AC =%.3f ', ...
    intraDensityS1, intraDensityS2, intraDensityS3, interDensityS1S2, interDensityS2S3, interDensityS1S3);
text(x2,y1,stringDensity2);

stringDensity3 = sprintf('intraDensity.gA =%.3f\nintraDensity.gB =%.3f\ninterDensity.gAgB =%.3f', ...
    intraDensityA, intraDensityB, interDensityAB);
text(x3,y1,stringDensity3);

%% save
% change directory
cd (outputFolder)

% set name
if statsOption == 0
    if strcmp(corrMethod, 'corrcoef')
        nameFigure = sprintf('nMC1_session%d_%s_%s_%sdata.png', session, danceType, TOI, char(dataType));
    elseif strcmp(corrMethod, 'partialcorr')
        nameFigure = sprintf('nMC2_session%d_%s_%s_%sdata.png', session, danceType, TOI, char(dataType));
    end
    
elseif statsOption == 1
    if strcmp(corrMethod, 'corrcoef')
        nameFigure = sprintf('nMC1_session%d_%s_%s_%sdata_stats1thr%s.png', session, danceType, TOI, char(dataType), statsThresholdName);
    elseif strcmp(corrMethod, 'partialcorr')
        nameFigure = sprintf('nMC2_session%d_%s_%s_%sdata_stats1thr%s.png', session, danceType, TOI, char(dataType), statsThresholdName);
    end
    
elseif statsOption == 2
    if strcmp(corrMethod, 'corrcoef')
        nameFigure = sprintf('nMC1_session%d_%s_%s_%sdata_stats2thr%s.png', session, danceType, TOI, char(dataType), statsThresholdName);
    elseif strcmp(corrMethod, 'partialcorr')
        nameFigure = sprintf('nMC2_session%d_%s_%s_%sdata_stats2thr%s.png', session, danceType, TOI, char(dataType), statsThresholdName);
    end
end

saveas(gcf, nameFigure);
close(gcf);

cd (inputFolder)

% END