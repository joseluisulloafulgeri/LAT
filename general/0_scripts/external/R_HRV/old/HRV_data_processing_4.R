# pipeline to perform HRV analyses on IBI data

library(RHRV) # importing the library
library(R.matlab) # importing the library

setwd("~/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/bioharness_3") # set folder where the data is
homeDirectory <- getwd() # save the home directory

folderNames = dir()
for( i in 1:length(folderNames) )
{
setwd(folderNames[i])

print("hello")
hrv.data <- CreateHRVData() # create HRV data structure
hrv.data <- SetVerbose(hrv.data, TRUE) # allows see comments

hrv.data <- LoadBeatAscii(hrv.data, "test2", RecordPath = ".") # load data
hrv.data <- BuildNIHR(hrv.data) # calculate the instantaneous HR
PlotNIHR(hrv.data) # plot instantaneous HR
hrv.data <- FilterNIHR(hrv.data) # automatic correction
PlotNIHR(hrv.data) # plot automatically-corrected HR
hrv.data <- EditNIHR(hrv.data) # manual correction
PlotNIHR(hrv.data) # plot manually-corrected HR
hrv.data <- InterpolateNIHR(hrv.data, freqhr = 4) # interpolation to get timeseries
PlotHR(hrv.data) # plot interpolated HR
interpolatedHR <- hrv.data$HR
writeMat('~/Documents/DataAnalysis/transfering_files_labodanse_3/2_data_analysis/bioharness/heartrates_1/HRdata.mat', HRdata = interpolatedHR)

#  -- SPECTRAL ANALYSIS -- 

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

PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 5)

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

PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 10)

}
# END