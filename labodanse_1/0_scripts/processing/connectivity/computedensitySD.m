function [intraDensityS, intraDensityD, interDensitySD] = computedensitySD(data, subjectNo)
% computedensitySD.m
% S == spectators, D == dancers,
% dancers are always the two last individuals

dataMax = ones(length(data), length(data));

if subjectNo == 8
    
    % intradensity for A
    intraDensityS = (nansum (nansum (data(1:6, 1:6), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax(1:6, 1:6), 1), 2) ) /2;
    intraDensityS = intraDensityS/intraDensitySmax;
    
    % intradensity for B
    intraDensityD = (nansum (nansum (data(7:8, 7:8), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax(7:8, 7:8), 1), 2) ) /2;
    intraDensityD = intraDensityD/intraDensityDmax;
    
    % for the interdensity AB
    interDensitySD = nansum (nansum (data(1:6, 7:8), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax(1:6, 7:8), 1), 2);
    interDensitySD = interDensitySD/interDensitySDmax;

elseif subjectNo == 9
    
    % intradensity for A
    intraDensityS = (nansum (nansum (data(1:7, 1:7), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax(1:7, 1:7), 1), 2) ) /2;
    intraDensityS = intraDensityS/intraDensitySmax;
    
    % intradensity for B
    intraDensityD = (nansum (nansum (data(8:9, 8:9), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax(8:9, 8:9), 1), 2) ) /2;
    intraDensityD = intraDensityD/intraDensityDmax;
    
    % for the interdensity AB
    interDensitySD = nansum (nansum (data(1:7, 8:9), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax(1:7, 8:9), 1), 2);
    interDensitySD = interDensitySD/interDensitySDmax;
    
elseif subjectNo == 10

    % intradensity for A
    intraDensityS = (nansum (nansum (data(1:8, 1:8), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax(1:8, 1:8), 1), 2) ) /2;
    intraDensityS = intraDensityS/intraDensitySmax;
    
    % intradensity for B
    intraDensityD = (nansum (nansum (data(9:10, 9:10), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax(9:10, 9:10), 1), 2) ) /2;
    intraDensityD = intraDensityD/intraDensityDmax;
    
    % for the interdensity AB
    interDensitySD = nansum (nansum (data(1:8, 9:10), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax(1:8, 9:10), 1), 2);
    interDensitySD = interDensitySD/interDensitySDmax;
       
elseif subjectNo == 11

    % intradensity for A
    intraDensityS = (nansum (nansum (data(1:9, 1:9), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax(1:9, 1:9), 1), 2) ) /2;
    intraDensityS = intraDensityS/intraDensitySmax;
    
    % intradensity for B
    intraDensityD = (nansum (nansum (data(10:11, 10:11), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax(10:11, 10:11), 1), 2) ) /2;
    intraDensityD = intraDensityD/intraDensityDmax;
    
    % for the interdensity AB
    interDensitySD = nansum (nansum (data(1:9, 10:11), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax(1:9, 10:11), 1), 2);
    interDensitySD = interDensitySD/interDensitySDmax;
end

% END