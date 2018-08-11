library(RHRV)
CreateHRVData
hrv.data = CreateHRVData()
hrv.data = SetVerbose(hrv.data, TRUE)
hrv.data = LoadBeatAscii(hrv.data, "IBI2", RecordPath = ".")
plot(hrv.data$Beat$Time)

# calculate the instantaneous HR
hrv.data = BuildNIHR(hrv.data)
PlotNIHR(hrv.data)

# automatic correction
hrv.data = FilterNIHR(hrv.data)
PlotNIHR(hrv.data)

# manual correction
hrv.data = EditNIHR(hrv.data)
PlotNIHR(hrv.data)

# interpolation to obtain a timeseries
hrv.data = InterpolateNIHR(hrv.data, freqhr = 4)
PlotHR(hrv.data)

# create TF variable
hrv.data = CreateFreqAnalysis(hrv.data)

# TF power analysis - Fourier
hrv.data = CalculatePowerBand(hrv.data, indexFreqAnalysis = 1, size = 300, shift = 30, sizesp = 2048, type = "fourier", ULFmin = 0, ULFmax = 0.03, VLFmin = 0.03, VLFmax = 0.05, LFmin = 0.05, LFmax = 0.15, HFmin = 0.15, HFmax = 0.4)

#
#hrv.data = PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 1.4)
hrv.data = PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 5)

# TF power analysis - Wavelet
hrv.data = CalculatePowerBand(hrv.data, indexFreqAnalysis = 1, type = "wavelet", wavelet = "la8", bandtolerance = 0.01, relative = FALSE, ULFmin = 0, ULFmax = 0.03, VLFmin = 0.03, VLFmax = 0.05, LFmin = 0.05, LFmax = 0.15, HFmin = 0.15, HFmax = 0.4)

#
#hrv.data = PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 1.4)
hrv.data = PlotPowerBand(hrv.data, indexFreqAnalysis = 1, ymax = 2500, ymaxratio = 5)


