function [intraDensityA, intraDensityB, interDensityAB] = computedensitySSD2(data, subjectNo, session)
% computedensitySDD2.m
% A == spectators A + dancers,
% B == spectators B + dancers,
% dancers are always the two last individuals

dataMax = ones(length(data), length(data));

if session == 1 && subjectNo == 8
    
    % intradensity for A
    intraDensityA = (nansum (nansum (data([1:3 7:8], [1:3 7:8]), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax([1:3 7:8],[1:3 7:8]), 1), 2) ) /2;
    intraDensityA = intraDensityA/intraDensitySmax;
    
    % intradensity for B
    intraDensityB = (nansum (nansum (data([4:6 7:8], [4:6 7:8]), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax([4:6 7:8], [4:6 7:8]), 1), 2) ) /2;
    intraDensityB = intraDensityB/intraDensityDmax;
    
    % for the interdensity AB
    interDensityAB = nansum (nansum (data([1:3 7:8], [4:6 7:8]), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax([1:3 7:8], [4:6 7:8]), 1), 2);
    interDensityAB = interDensityAB/interDensitySDmax;
    
elseif session == 2 && subjectNo == 11

    % intradensity for A
    intraDensityA = (nansum (nansum (data([1:4 10:11], [1:4 10:11]), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax([1:4 10:11], [1:4 10:11]), 1), 2) ) /2;
    intraDensityA = intraDensityA/intraDensitySmax;
    
    % intradensity for B
    intraDensityB = (nansum (nansum (data([5:9 10:11], [5:9 10:11]), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax([5:9 10:11], [5:9 10:11]), 1), 2) ) /2;
    intraDensityB = intraDensityB/intraDensityDmax;
    
    % for the interdensity AB
    interDensityAB = nansum (nansum (data([1:4 10:11], [5:9 10:11]), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax([1:4 10:11], [5:9 10:11]), 1), 2);
    interDensityAB = interDensityAB/interDensitySDmax;
       
elseif session == 3 && subjectNo == 9

    % intradensity for A
    intraDensityA = (nansum (nansum (data([1:5 8:9], [1:5 8:9]), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax([1:5 8:9], [1:5 8:9]), 1), 2) ) /2;
    intraDensityA = intraDensityA/intraDensitySmax;
    
    % intradensity for B
    intraDensityB = (nansum (nansum (data([6:7 8:9], [6:7 8:9]), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax([6:7 8:9], [6:7 8:9]), 1), 2) ) /2;
    intraDensityB = intraDensityB/intraDensityDmax;
    
    % for the interdensity AB
    interDensityAB = nansum (nansum (data([1:5 8:9], [6:7 8:9]), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax([1:5 8:9], [6:7 8:9]), 1), 2);
    interDensityAB = interDensityAB/interDensitySDmax;
    
elseif session == 4 && subjectNo == 10

    % intradensity for A
    intraDensityA = (nansum (nansum (data([1:4 9:10], [1:4 9:10]), 1), 2) ) /2;
    intraDensitySmax = (nansum (nansum (dataMax([1:4 9:10], [1:4 9:10]), 1), 2) ) /2;
    intraDensityA = intraDensityA/intraDensitySmax;
    
    % intradensity for B
    intraDensityB = (nansum (nansum (data([5:8 9:10], [5:8 9:10]), 1), 2) ) /2;
    intraDensityDmax = (nansum (nansum (dataMax([5:8 9:10], [5:8 9:10]), 1), 2) ) /2;
    intraDensityB = intraDensityB/intraDensityDmax;
    
    % for the interdensity AB
    interDensityAB = nansum (nansum (data([1:4 9:10], [5:8 9:10]), 1), 2);
    interDensitySDmax = nansum (nansum (dataMax([1:4 9:10], [5:8 9:10]), 1), 2);
    interDensityAB = interDensityAB/interDensitySDmax;
        
end

% END