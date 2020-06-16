# Vandenberg AFB Falcon 9 Launches
![Falcon 9 Picture](/RADARSAT_Vandenberg.jpg)
This is the repository for codes relating to the Falcon 9 Launches measured at
Vandenberg AFB, CA.
## Codes in this repository
* **Falcon_9_Analysis.m**
  * A fairly comprehensive code that is partially automatic. Draws information
  about launches from f9AltAndDRD.mat, f9IntParams.mat, f9NameParams.mat, and f9Trajectory.mat.
  * Will produce singular plots of waveforms, OASPL, Distance-corrected OASPL, OASPL vs Distance-corrected OASPL, OASPL Plot of 3 dB down period, Narrowband Spectrum of 3 dB down period, OTO spectrum of 3 dB down period, OTO spectra from different times during the launch, SNR spectra from different times during the launch, dSk plot vs. time, dSk plot vs. time for first 150 s of launch, Spectrogram, and plot of trajectory.
  Will save plots automatically if specified as .png, .fig, and .svg.
  * Finds corrected distances with distCalc.m function.
  * Will save spectra, dSk, and OASPL values as .mat files.
* **Waveform_Multiplot.m**
  * Produces a tiled comparison plot of waveform sections from different portions of the launch sequence.
  * Also will produce OTO spectra from different times during the launch and will high-pass the data for the spectrum and waveforms.
  * Uses *tiledlayout* function avaliable in **MATLAB R2019b** or later versions.
* **dSkMultiplot.m**
  * Produces an overlaid plot of dSk values over time from different launches and from different locations. Uses .mat files for dSk created by *Falcon_9_Analysis.m* code.
* **OASPLComp.m**
  * Produces an overlaid plot of OASPL values over time from different launches and from different locations. Uses .mat files for OASPL created by *Falcon_9_Analysis.m* code.
* **WeatherAnalysis.m**
  * Produces animated plots from different .csv weather files. Still a work in progress, and runs slowly on regular computers.
* **Falcon_9_Audio**
  * Possibly the coolest script in this folder, this code will produce a stereo *.wav* file of a Falcon 9 Launch of your choosing. It requires a location that had at least two operating microphones and will use them as a right and left channel.
