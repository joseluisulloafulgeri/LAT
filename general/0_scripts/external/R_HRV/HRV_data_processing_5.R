# pipeline to perform HRV analyses on IBI data

library(RHRV) # importing the library
library(R.matlab) # importing the library

group = "A"

#newDirMain = sprintf("~/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3_%s", group) # set folder where is the data
newDirMain = sprintf("~/Documents/DataAnalysis/transfering_files_labodanse_2/2_data_analysis/bioharness_new/bioharness_3") # set folder where is the data

setwd(newDirMain) # change directory
homeDirectory <- getwd() # save the home directory

folderNames = dir() # loop through folders
#for ( i_folder in 1:length(folderNames) )
for ( i_folder in 3:3 )
#for ( i_folder in 32:32 )  
  
{
  #newDir = sprintf("~/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3_%s/%s", group, folderNames[i_folder])
  newDir = sprintf("~/Documents/DataAnalysis/transfering_files_labodanse_2/2_data_analysis/bioharness_new/bioharness_3/%s", folderNames[i_folder])
  setwd(newDir) # change directory
  
  filenames = dir(pattern="*.txt")
  for( i_file in 1:length(filenames) ) # loop through files
  #for( i_file in 1:1 ) # loop through files
  #for( i_file in 2:2 ) # loop through files  
  {
    
  # GET DATA
  hrv.data <- CreateHRVData() # create HRV data structure
  hrv.data <- SetVerbose(hrv.data, TRUE) # allows see comments
  hrv.data <- LoadBeatAscii(hrv.data, filenames[i_file], RecordPath = ".") # load data
  
  # DATA TREATMENT 
  hrv.data <- BuildNIHR(hrv.data) # calculate the instantaneous HR
  #PlotNIHR(hrv.data) # plot instantaneous HR
  
  BeatsOrigi <- hrv.data$Beat$Time
  HRNoInterpOrigi <- hrv.data$Beat$niHR
  RROrigi <- hrv.data$Beat$RR
  currentLocationAndName1 = sprintf("%s/HRVdata_BeatsOrigi_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName2 = sprintf("%s/HRVdata_HRNoInterpOrigi_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName3 = sprintf("%s/HRVdata_RROrigi_%0.3d.mat", newDir, i_file) # location & name to save data
  writeMat(currentLocationAndName1, BeatsOrigi = BeatsOrigi) # write the .mat file
  writeMat(currentLocationAndName2, HRNoInterpOrigi = HRNoInterpOrigi) # write the .mat file
  writeMat(currentLocationAndName3, RROrigi = RROrigi) # write the .mat file

  #hrv.data <- FilterNIHR(hrv.data) # automatic correction
  hrv.data <- FilterNIHR(hrv.data, long=50, last=13, minbpm=25, maxbpm=200) # automatic correction
  # hrv.data <- FilterNIHR(hrv.data, long=50, last=13, minbpm=30, maxbpm=130, ) # automatic correction to try later
  #PlotNIHR(hrv.data) # plot automatically-corrected HR
  
  BeatsProc <- hrv.data$Beat$Time
  HRNoInterpProc <- hrv.data$Beat$niHR
  RRProc <- hrv.data$Beat$RR
  currentLocationAndName1 = sprintf("%s/HRVdata_BeatsProc_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName2 = sprintf("%s/HRVdata_HRNoInterpProc_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName3 = sprintf("%s/HRVdata_RRProc_%0.3d.mat", newDir, i_file) # location & name to save data
  writeMat(currentLocationAndName1, BeatsProc = BeatsProc) # write the .mat file
  writeMat(currentLocationAndName2, HRNoInterpProc = HRNoInterpProc) # write the .mat file
  writeMat(currentLocationAndName3, RRProc = RRProc) # write the .mat file
  
  hrv.data <- InterpolateNIHR(hrv.data, freqhr = 10) # interpolation to get timeseries
  
  #PlotHR(hrv.data) # plot interpolated HR
  
  HRInterp <- hrv.data$HR
  currentLocationAndName1 = sprintf("%s/HRVdata_HRInterp_%0.3d.mat", newDir, i_file) # location & name to save data
  writeMat(currentLocationAndName1, HRInterp = HRInterp) # write the .mat file
  
  # SPECTRAL ANALYSIS
  # TF power analysis - Fourier
  hrv.data <- CreateFreqAnalysis(hrv.data) # create TF variable
  hrv.data <- CalculatePowerBand(hrv.data,
                                 indexFreqAnalysis = 1, 
                                 size = 300,
                                 shift = 30,
                                 type = "fourier",
                                 ULFmin = 0,
                                 ULFmax = 0.03,
                                 VLFmin = 0.03,
                                 VLFmax = 0.05,
                                 LFmin = 0.05,
                                 LFmax = 0.15,
                                 HFmin = 0.15,
                                 HFmax = 0.4)
  
  # 'size' is the size of the analysis window (5 min)
  # 'sizeesp' is to indicate the # of points to calculate the FT
  # 'sizesp' is correction term, omittted cause it is calculated by itself
  
  #PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 5)
  
  Freq1HRV <- hrv.data$FreqAnalysis[[1]]$LFHF
  Freq1HF <- hrv.data$FreqAnalysis[[1]]$HF
  Freq1LF <- hrv.data$FreqAnalysis[[1]]$LF
  currentLocationAndName1 = sprintf("%s/HRVdata_Freq1HRV_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName2 = sprintf("%s/HRVdata_Freq1HF_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName3 = sprintf("%s/HRVdata_Freq1LF_%0.3d.mat", newDir, i_file) # location & name to save data
  writeMat(currentLocationAndName1, Freq1HRV = Freq1HRV) # write the .mat file
  writeMat(currentLocationAndName2, Freq1HF = Freq1HF) # write the .mat file
  writeMat(currentLocationAndName3, Freq1LF = Freq1LF) # write the .mat file
  
  # TF power analysis - Wavelet
  hrv.data <- CreateFreqAnalysis(hrv.data)
  hrv.data <- CalculatePowerBand(hrv.data,
                                 indexFreqAnalysis = 2,
                                 type = "wavelet",
                                 wavelet = "la8",
                                 bandtolerance = 0.01,
                                 relative = FALSE,
                                 ULFmin = 0,
                                 ULFmax = 0.03,
                                 VLFmin = 0.03,
                                 VLFmax = 0.05,
                                 LFmin = 0.05,
                                 LFmax = 0.15,
                                 HFmin = 0.15,
                                 HFmax = 0.4)
  
  #PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 10)
  
  Freq2HRV <- hrv.data$FreqAnalysis[[2]]$LFHF
  Freq2HF <- hrv.data$FreqAnalysis[[2]]$HF
  Freq2LF <- hrv.data$FreqAnalysis[[2]]$LF
  currentLocationAndName1 = sprintf("%s/HRVdata_Freq2HRV_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName2 = sprintf("%s/HRVdata_Freq2HF_%0.3d.mat", newDir, i_file) # location & name to save data
  currentLocationAndName3 = sprintf("%s/HRVdata_Freq2LF_%0.3d.mat", newDir, i_file) # location & name to save data
  writeMat(currentLocationAndName1, Freq2HRV = Freq2HRV) # write the .mat file
  writeMat(currentLocationAndName2, Freq2HF = Freq2HF) # write the .mat file
  writeMat(currentLocationAndName3, Freq2LF = Freq2LF) # write the .mat file
  
  }
}
# END