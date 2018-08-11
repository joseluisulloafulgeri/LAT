function [intraDensityS1, intraDensityS2, intraDensityS3, interDensityS1S2, interDensityS2S3, interDensityS1S3] = computedensitySSDnormaliz(data, subjectNo, session)
% computedensitySSD.m
% S1 and S2 == spectators, S3 == dancers,
% dancers are always the two last individuals

dataMax = ones(length(data), length(data));

if session == 1 && subjectNo == 8
    
    % intradensity for S1
    intraDensityS1 = (nansum (nansum (data(1:3, 1:3), 1), 2) ) /2;
    intraDensityS1max = (nansum (nansum (dataMax(1:3, 1:3), 1), 2) ) /2;
    intraDensityS1 = intraDensityS1/intraDensityS1max;
    
    % intradensity for S2
    intraDensityS2 = (nansum (nansum (data(4:6, 4:6), 1), 2) ) /2;
    intraDensityS2max = (nansum (nansum (dataMax(4:6, 4:6), 1), 2) ) /2;
    intraDensityS2 = intraDensityS2/intraDensityS2max;
    
    % intradensity for S3
    intraDensityS3 = (nansum (nansum (data(7:8, 7:8), 1), 2) ) /2;  
    intraDensityS3max = (nansum (nansum (dataMax(7:8, 7:8), 1), 2) ) /2;
    intraDensityS3 = intraDensityS3/intraDensityS3max;
    
    % for the interdensity S1S2
    interDensityS1S2 = nansum (nansum (data(1:3, 4:6), 1), 2);
    interDensityS1S2max = nansum (nansum (dataMax(1:3, 4:6), 1), 2);
    interDensityS1S2 = interDensityS1S2/interDensityS1S2max;
    interDensityS1S2 = interDensityS1S2*2/(intraDensityS1 + intraDensityS2); %% new
    
    % for the interdensity S2S3
    interDensityS2S3 = nansum (nansum (data(4:6, 7:8), 1), 2);
    interDensityS2S3max = nansum (nansum (dataMax(4:6, 7:8), 1), 2);
    interDensityS2S3 = interDensityS2S3/interDensityS2S3max;
    interDensityS2S3 = interDensityS2S3*2/(intraDensityS2 + intraDensityS3); %% new
    
    % for the interdensity S1S3
    interDensityS1S3 = nansum (nansum (data(1:3, 7:8), 1), 2);
    interDensityS1S3max = nansum (nansum (dataMax(1:3, 7:8), 1), 2);
    interDensityS1S3 = interDensityS1S3/interDensityS1S3max;
    interDensityS1S3 = interDensityS1S3*2/(intraDensityS1 + intraDensityS3); %% new

elseif session == 2 && subjectNo == 11
    
    % intradensity for S1
    intraDensityS1 = (nansum (nansum (data(1:4, 1:4), 1), 2) ) /2;
    intraDensityS1max = (nansum (nansum (dataMax(1:4, 1:4), 1), 2) ) /2;
    intraDensityS1 = intraDensityS1/intraDensityS1max;
    
    % intradensity for S2
    intraDensityS2 = (nansum (nansum (data(5:9, 5:9), 1), 2) ) /2;
    intraDensityS2max = (nansum (nansum (dataMax(5:9, 5:9), 1), 2) ) /2;
    intraDensityS2 = intraDensityS2/intraDensityS2max;
    
    % intradensity for D
    intraDensityS3 = (nansum (nansum (data(10:11, 10:11), 1), 2) ) /2;
    intraDensityS3max = (nansum (nansum (dataMax(10:11, 10:11), 1), 2) ) /2;
    intraDensityS3 = intraDensityS3/intraDensityS3max;
    
    % for the interdensity S1S2
    interDensityS1S2 = nansum (nansum (data(1:4, 5:9), 1), 2);
    interDensityS1S2max = nansum (nansum (dataMax(1:4, 5:9), 1), 2);
    interDensityS1S2 = interDensityS1S2/interDensityS1S2max;
    interDensityS1S2 = interDensityS1S2*2/(intraDensityS1 + intraDensityS2); %% new
    
    % for the interdensity S1S2
    interDensityS2S3 = nansum (nansum (data(5:9, 10:11), 1), 2);
    interDensityS2S3max = nansum (nansum (dataMax(5:9, 10:11), 1), 2);
    interDensityS2S3 = interDensityS2S3/interDensityS2S3max;
    interDensityS2S3 = interDensityS2S3*2/(intraDensityS2 + intraDensityS3); %% new
    
    % for the interdensity S1S3
    interDensityS1S3 = nansum (nansum (data(1:4, 10:11), 1), 2);
    interDensityS1S3max = nansum (nansum (dataMax(1:4, 10:11), 1), 2);
    interDensityS1S3 = interDensityS1S3/interDensityS1S3max;
    interDensityS1S3 = interDensityS1S3*2/(intraDensityS1 + intraDensityS3); %% new
    
elseif session == 3 && subjectNo == 9
    
    % intradensity for S1
    intraDensityS1 = (nansum (nansum (data(1:5, 1:5), 1), 2) ) /2;
    intraDensityS1max = (nansum (nansum (dataMax(1:5, 1:5), 1), 2) ) /2;
    intraDensityS1 = intraDensityS1/intraDensityS1max;
    
    % intradensity for S2
    intraDensityS2 = (nansum (nansum (data(6:7, 6:7), 1), 2) ) /2;
    intraDensityS2max = (nansum (nansum (dataMax(6:7, 6:7), 1), 2) ) /2;
    intraDensityS2 = intraDensityS2/intraDensityS2max;
    
    % intradensity for D
    intraDensityS3 = (nansum (nansum (data(8:9, 8:9), 1), 2) ) /2; 
    intraDensityS3max = (nansum (nansum (dataMax(8:9, 8:9), 1), 2) ) /2; 
    intraDensityS3 = intraDensityS3/intraDensityS3max;

    % for the interdensity S1S2
    interDensityS1S2 = nansum (nansum (data(1:5, 6:7), 1), 2);
    interDensityS1S2max = nansum (nansum (dataMax(1:5, 6:7), 1), 2);
    interDensityS1S2 = interDensityS1S2/interDensityS1S2max;
    interDensityS1S2 = interDensityS1S2*2/(intraDensityS1 + intraDensityS2); %% new
    
    % for the interdensity S1S2
    interDensityS2S3 = nansum (nansum (data(6:7, 8:9), 1), 2); 
    interDensityS2S3max = nansum (nansum (dataMax(6:7, 8:9), 1), 2); 
    interDensityS2S3 = interDensityS2S3/interDensityS2S3max;
    interDensityS2S3 = interDensityS2S3*2/(intraDensityS2 + intraDensityS3); %% new
    
    % for the interdensity S1S3
    interDensityS1S3 = nansum (nansum (data(1:5, 8:9), 1), 2);
    interDensityS1S3max = nansum (nansum (dataMax(1:5, 8:9), 1), 2);
    interDensityS1S3 = interDensityS1S3/interDensityS1S3max;
    interDensityS1S3 = interDensityS1S3*2/(intraDensityS1 + intraDensityS3); %% new
    
elseif session == 4 && subjectNo == 10
    
    % intradensity for S1
    intraDensityS1 = (nansum (nansum (data(1:4, 1:4), 1), 2) ) /2;
    intraDensityS1max = (nansum (nansum (dataMax(1:4, 1:4), 1), 2) ) /2;
    intraDensityS1 = intraDensityS1/intraDensityS1max;
    
    % intradensity for S2
    intraDensityS2 = (nansum (nansum (data(5:8, 5:8), 1), 2) ) /2;
    intraDensityS2max = (nansum (nansum (dataMax(5:8, 5:8), 1), 2) ) /2;
    intraDensityS2 = intraDensityS2/intraDensityS2max;
    
    % intradensity for D
    intraDensityS3 = (nansum (nansum (data(9:10, 9:10), 1), 2) ) /2; 
    intraDensityS3max = (nansum (nansum (dataMax(9:10, 9:10), 1), 2) ) /2; 
    intraDensityS3 = intraDensityS3/intraDensityS3max;
    
    % for the interdensity S1S2
    interDensityS1S2 = nansum (nansum (data(1:4, 5:8), 1), 2);
    interDensityS1S2max = nansum (nansum (dataMax(1:4, 5:8), 1), 2);
    interDensityS1S2 = interDensityS1S2/interDensityS1S2max;
    interDensityS1S2 = interDensityS1S2*2/(intraDensityS1 + intraDensityS2); %% new
    
    % for the interdensity S1S2
    interDensityS2S3 = nansum (nansum (data(5:8, 9:10), 1), 2);
    interDensityS2S3max = nansum (nansum (dataMax(5:8, 9:10), 1), 2);
    interDensityS2S3 = interDensityS2S3/interDensityS2S3max;
    interDensityS2S3 = interDensityS2S3*2/(intraDensityS2 + intraDensityS3); %% new
    
    % for the interdensity S1S3
    interDensityS1S3 = nansum (nansum (data(1:4, 9:10), 1), 2);
    interDensityS1S3max = nansum (nansum (dataMax(1:4, 9:10), 1), 2);
    interDensityS1S3 = interDensityS1S3/interDensityS1S3max;
    interDensityS1S3 = interDensityS1S3*2/(intraDensityS1 + intraDensityS3); %% new
    
end

% END