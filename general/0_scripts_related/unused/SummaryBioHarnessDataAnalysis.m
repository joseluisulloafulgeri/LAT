%********************************************************************************************%
% FileName:     BioHarnessDataAnalysis.m
% Author:       Ben Morris
% Company:      Zephyr Tecnology
% Date:         8/30/2012
% Description:  This file requests the user to input an ECG, a Summary
%               Packet, a Breathing, and a RR csv file for the BioHarness.Upon providing them, it plots the signed
%               ECG data and the Heart & Breathing Rate along with the
%               Acceleration, HRV etc. information in three graphs for the user to
%               analyze.
%**********************************************************************************************%

clear all
close all
%Getting the ECG File******************************************************

[filename, pathname] = uigetfile('*.csv', ' Please select the ECG Input file');
valid_filename=0;
% Searching for the ECG String in the filename
ECG_StrinG_Search = strfind(filename, 'ECG');
if(~(isempty(ECG_StrinG_Search)))
    valid_filename=1;
    disp('Invalid File or No File Selected ');
end
%Do if a file with validname has been found
if(valid_filename)
    %concatenate the pathname with the filename
    CompletePathwFilename = strcat(pathname,filename);
    %Open the file & extract the data
    fid = fopen(CompletePathwFilename);
    data = textscan(fid,'%s %f','HeaderLines',1,'Delimiter',',','CollectOutput',1);
    fclose(fid);
    ADC_Resolution =12;
    Fs_ECG = 250;

    %Obtain the actual ECG data from the cell of arrays and set figure
    %properties
    Actual_ECG_Data = data{1,2};
    time = transpose(0:1/Fs_ECG:length(Actual_ECG_Data)/Fs_ECG-1/Fs_ECG); 
    Actual_ECG_Data_Signed = (Actual_ECG_Data-(2^(ADC_Resolution-1)))*(-1);
     figure('Name','ECG Data','NumberTitle','off')
    plot(time,Actual_ECG_Data_Signed);
    title('Plot of Signed ECG Data');ylabel('Signed ECG Data');xlabel('Time in seconds');
    grid on
end
pause(1);
%Getting the Summary Packet File******************************************************
[filename, pathname] = uigetfile('*.csv', ' Please select the Summary Packet Input file');
valid_filename=0;
% Searching for the 'Summary' String in the filename
SP_StrinG_Search = strfind(filename, 'Summary');

if(~(isempty(SP_StrinG_Search)))
    valid_filename=1;
    disp('Invalid File or No File Selected File or No File Selected');
end

%Do if a file with validname has been found
if(valid_filename)
    %concatenate the pathname with the filename
    CompleteSPPathwFilename = strcat(pathname,filename);
    %Open the file & extract the data
    fid = fopen(CompleteSPPathwFilename);
    SP_Data = textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','HeaderLines',1,'Delimiter',',','CollectOutput',1);
    fclose(fid);
      %Obtain the actual SP data from the cell of arrays
    global Actual_SP_Data;
    Actual_SP_Data = SP_Data{1,2};
    matrixSize = size(Actual_SP_Data);
    nRows = matrixSize(1,1);
    nCols = matrixSize(1,2);
    
    for i= 1:nRows
        for j = 1:nCols
            if ((Actual_SP_Data(i,j) == 65535)||(Actual_SP_Data(i,j) == 6553.5)||(Actual_SP_Data(i,j) == -3276.8)||(Actual_SP_Data(i,j) == -3276.8))
               Actual_SP_Data(i,j)=0;
            end
        end
    end
    % Get the Heart Rate data from the extracted data&&
    HeartRate = Actual_SP_Data(:,1);
    timeSP = 1:1:length(Actual_SP_Data);
    % Set figure properties for the HR and Breathing data
     figure('Name','Heart, Breathing Rate, and HRV','NumberTitle','off')
    subplot(3,1,1);
    plot(timeSP,HeartRate);
    grid on;
    ylabel('Heart Rate (bpm)');xlabel('Time (seconds)');
    legend('Heart Rate');
    title('Heart and Breathing Rate');
  
    % Get the Breathing Rate data from the extracted data
    BreathingRate = Actual_SP_Data(:,2);
    subplot(3,1,2);
    plot(timeSP,BreathingRate);
    grid on;
    ylabel('Breathing Rate (bpm)');xlabel('Time (seconds)');
    legend('Breathing Rate');


    
    % Get the HRV data from the extracted data
    HRV = Actual_SP_Data(:,15);
    subplot(3,1,3);
    plot(timeSP,HRV);
    grid on;
    ylabel('HRV (milliseconds)');xlabel('Time (seconds)');
    legend('HRV');
    
    % Set figure properties for the Acceleration data
    figure('Name','Accel Data','NumberTitle','off')
    title('Acceleration Data');
    
    % Get the Peak Accelertion data from the extracted data
    % Then plotting the Peak Accelertion data
    Acc_Data = Actual_SP_Data(:,6);
    subplot(4,1,1);
    plot(timeSP,Acc_Data);
    grid on;
    ylabel('Acceleration (g)');xlabel('Time (seconds)');
    legend('Peak Acceleration');
    title('Acceleration Data');
    
    % Get the X-axis Accelertion data from the extracted data
    X_axis_Min_Acc_Data = Actual_SP_Data(:,20);
    X_axis_Peak_Acc_Data= Actual_SP_Data(:,21);
    
    % Then plotting the Peak/Min X-axis Accelertion data
    subplot(4,1,2);
    plot(timeSP,X_axis_Min_Acc_Data,'b',timeSP,X_axis_Peak_Acc_Data,'r');
    grid on;
    ylabel('X-axis Min/Peak Acc.(g)');xlabel('Time (seconds)');
    legend('X-axis Min Acceleration','X-axis Peak Acceleration');
 
       % Get the Y-axis Accelertion data from the extracted data
    Y_axis_Min_Acc_Data = Actual_SP_Data(:,22);
    Y_axis_Peak_Acc_Data= Actual_SP_Data(:,23);
    
    
    % Then plotting the Peak/Min Y-axis Accelertion data
    subplot(4,1,3);
    plot(timeSP,Y_axis_Min_Acc_Data,'b',timeSP,Y_axis_Peak_Acc_Data,'r');
    grid on;
    ylabel('Y-axis Min/Peak Acc.(g)');xlabel('Time (seconds)');
    legend('Y-axis Min Acceleration','Y-axis Peak Acceleration');
    
    

    % Get the Z-axis Accelertion data from the extracted data
    Z_axis_Min_Acc_Data = Actual_SP_Data(:,24);
    Z_axis_Peak_Acc_Data= Actual_SP_Data(:,25);
    % Then plotting the Peak/Min Z-axis Accelertion data
    subplot(4,1,4);
    plot(timeSP,Z_axis_Min_Acc_Data,'b',timeSP,Z_axis_Peak_Acc_Data,'r');
    grid on;
    ylabel('Z-axis Min/Peak Acc.(g)');xlabel('Time (seconds)');
    legend('Z-axis Min Acceleration','Z-axis Peak Acceleration');
end

[filename, pathname] = uigetfile('*.csv', ' Please select the R-R Input file');
valid_filename=0;
% Searching for the RR String in the filename
RR_StrinG_Search = strfind(filename, 'RR');
if(~(isempty(RR_StrinG_Search)))
    valid_filename=1;
    disp('Invalid File or No File Selected File or No File Selected');
end
%Do if a file with validname has been found
if(valid_filename)
    %concatenate the pathname with the filename
    CompletePathwFilename = strcat(pathname,filename);
    %Open the file & extract the data
    fid = fopen(CompletePathwFilename);
    RR_data = textscan(fid,'%s %f','HeaderLines',1,'Delimiter',',','CollectOutput',1);
    fclose(fid);
    
    Actual_RR_Data = RR_data{:,2};
    %narrows to the second column only which contains the RR values
    
    nRows=length(Actual_RR_Data);
    %defines the time axis array by cummulation of RR intervals
    for i=1:nRows
        if i==1
            timeRR(i,1) = (Actual_RR_Data(i,1));
        else
            timeRR(i,1) = (Actual_RR_Data(i,1) + timeRR(i-1,1));
        end
    end
    %convert from milliseconds to seconds
    timeRR=timeRR/1000;
    
    % Set figure properties for the R to R data
    figure('Name','R to R Data','NumberTitle','off')
    title('RR Data - Time Domain');    
    R_R_Data = Actual_RR_Data(:,1);
    plot(timeRR,R_R_Data,'R');
    ylabel('R to R Data');xlabel('Time (seconds)');
    legend('R to R');
    grid on
    
    
    
    %NumMins =5; SecPerMin =60;
    %SecsForRollingAverage =30;
    %SamplesforHRV = round(SecsForRollingAverage*Fs_BR_RR);
    %FirstHRVTime = NumMins*SecPerMin;
    %NumSamplesOverFirstHRV = round(FirstHRVTime*Fs_BR_RR);
    %HRV = zeros(1,(length(R_R_Data)-SamplesforHRV-NumSamplesOverFirstHRV)+1);
    %if(length(R_R_Data)>NumSamplesOverFirstHRV)
        %Calculate the first HRV for 5 min of data
    %    for i=0:(length(R_R_Data)-SamplesforHRV-NumSamplesOverFirstHRV);
    %        HRVMean = sum(R_R_Data(NumSamplesOverFirstHRV+i+3-SamplesforHRV:i+NumSamplesOverFirstHRV))/(SamplesforHRV-1);
    %        HRV(i+NumSamplesOverFirstHRV) = sqrt(sum((R_R_Data(NumSamplesOverFirstHRV+i+3-SamplesforHRV:i+NumSamplesOverFirstHRV)-HRVMean).^2)/(SamplesforHRV-2));
            
    %    end
    %subplot(3,1,3);
    %timeHRV = transpose(0:1/Fs_BR_RR:length(HRV)/Fs_BR_RR-1/Fs_BR_RR);
    %plot(timeHRV(1:NumSamplesOverFirstHRV),HRV(1:NumSamplesOverFirstHRV),'r');hold on;
    %plot(timeHRV(NumSamplesOverFirstHRV+1:length(timeHRV)),HRV(NumSamplesOverFirstHRV+1:length(HRV)),'b');
    %ylabel('HRV Data');xlabel('Time (seconds)');
    %legend('HRV Invalid Data','HRV Valid Data');
    %grid on
    
    %end
%else
    % Need > 5min of data for HRV
%    disp('Data Length too small for HRV');
end
    
