library(RHRV)
# create HRV data structure
hrv.data <- CreateHRVData()
hrv.data <- SetVerbose(hrv.data, TRUE) # allows see comments

# Load data
setwd("~/Documents/R_HRV")
hrv.data <- LoadBeatAscii(hrv.data, "test_3", RecordPath = ".")
# plot(hrv.data$Beat$Time) # almost useless

# calculate the instantaneous HR
hrv.data <- BuildNIHR(hrv.data)
PlotNIHR(hrv.data)

# automatic correction
hrv.data <- FilterNIHR(hrv.data)
PlotNIHR(hrv.data)

# manual correction
hrv.data <- EditNIHR(hrv.data)
PlotNIHR(hrv.data)

# interpolation to obtain a timeseries
hrv.data <- InterpolateNIHR(hrv.data, freqhr = 4)
PlotHR(hrv.data)

#  -- SPECTRAL ANALYSIS -- 
# create TF variable
hrv.data <- CreateFreqAnalysis(hrv.data)

# TF power analysis - Fourier
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
# 'size' is the size of the window (5 min)
# sizeesp is to indicate the # of points to calculate the FT
# sizesp = 2048, dropped

PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 5)

hrv.data <- CreateFreqAnalysis(hrv.data)
# TF power analysis - Wavelet
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

# END