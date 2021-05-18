# Vandenberg AFB Falcon 9 Launches
![Falcon 9 Picture](/RADARSAT_Vandenberg.jpg)
This is the repository for codes relating to the Falcon 9 Launches measured at
Vandenberg AFB, CA.
## Scripts
* **Autocorrelation_Analysis.m**
  * Performs an autocorrelation analysis on a selected dataset and plots normalized autocorrelation as a function of lag (tau).
* **Coherence_Analysis.m**
  * Performs a coherence analysis between two selected datasets and plots the coherence between the two signals.
* **Cole_Fig_6.m**
  * Reproduces Fig. 6 from Cole et al. (1957) paper.
* **Crosscorrelation_Analysis**
  * Performs a cross-correlation analysis between two selected datasets and plots normalized cross-correlation coefficient as a function of lag (tau).
  * Option to use the Hilbert transform to produce and plot envelope function of the autocorrelation coefficient. Plots on a logarithmic y axis. See Harker et al. JASA (2013).
* **csvTrajectoryRead.m**
  * Script used to load in *.xlsx* trajectory files and output them as *.mat* files. Not particularly useful now.
* **Double_Soundspeed_Profile_Plot.m**
  * Produces Mathews et al. (2021) Fig 5.
* **dSkMultiplot.m**
  * Produces an overlaid plot of dSk values over time from different launches and from different locations. Uses .mat files for dSk created by `Falcon_9_Analysis.m` code.
* **Dual_Spec_Plot.m**
  * Produces a plot like Mathews et al. (2021) Fig. 11 in conjunction with `Spectrum_Analysis.m` script.
* **Elevation_Profiles.m**
  * Contains rough elevation profiles from SLC-4E to North/West field, East Field, and Miguelito sites. Uses pchip method 1-D interpolation to place the data on a 1 m resolution grid.
* **falcon9Directivity.m**
  * Plots the OASPL directivity of the Falcon 8 rocket using trajectory data.
* **falcon9LaunchParameters**
  * This script saves launch parameter data to the various *.mat* parameter files.
* **falcon9PeakFrequency**
  * This script plots the peak frequency over time of the Falcon 9 launch data at one location. It breaks up the waveform into blocks, finds the autospectrum of each block, and finds the peak frequency values of each autospectral chunk.
* **falcon9SoundPowerEst**
  * Uses the OASPL directivity combined with plane wave assumption to estimate the sound power of a rocket, following similar methods as Matoza et al. (2013).
* **falcon9SpectrumGenerator**
  * Script that can generate an autospectrum and OTO spectrum for a Falcon 9 measurement and save the result as a .mat file.
* **Falcon_9_Analysis.m**
  * A fairly comprehensive code that is partially automatic. Draws information
    about launches from `f9AltAndDRD.mat`, `f9IntParams.mat`, `f9NameParams.mat`, and `f9Trajectory.mat`.
  * Will produce singular plots of waveforms, OASPL, Distance-corrected OASPL, OASPL vs Distance-corrected OASPL, OASPL Plot of 3 dB down period, Narrowband Spectrum of 3 dB down period, OTO spectrum of 3 dB down period, OTO spectra from different times during the launch, SNR spectra from different times during the launch, dSk plot vs. time, dSk plot vs. time for first 150 s of launch, Spectrogram, and plot of trajectory.
    Will save plots automatically if specified as *.png*, *.fig*, and *.svg*.
  * Finds corrected distances with distCalc.m function.
  * Will save spectra, dSk, and OASPL values as *.mat* files.
* **greskaModel.m**
  * Reproduces Greska et al. (2008) Fig. 2, adds data points for Falcon 9, RSRM.
* **MakeElevationProfiles.m**
  * Script that reproduces elevation profile plot from Mathews et al. (2021) Fig. 4.
* **merlin1D_Analysis**
  * Basic convective Mach number, fully-expanded calculations for Merlin 1D engine. Data contained is not correct, as it is not fully expanded. Probably best just to use NASA CEA2.
* **metricsHeader.m**
  * I'm really not sure why I wrote this script.
* **Miguelito_Spec_Shielding.m**
  * Script used in conjunction with *Spectrum_Analysis.m* to reproduce Mathews et al. (2021) Fig. 12.
* **OASPL_Comparison.m**
  * Will produce a comparison of running OASPL's from any selected launches and locations and plot them in a tiled figure.
  * Uses *tiledlayout* function available in **MATLAB R2019b** or later versions.
* **OASPL_Distance_Correcting_Analysis.m**
  * Plots OASPL, similar functioning to `OASPL_Comparison.m`, but also uses distance correcting measures to "correct" for spherical spreading to a common distance.
  * TODO: Add functionality to plot directivity (angle re plume) and different trajectory for SAOCOM 1A and RADARSAT Constellation Launches.
* **OASPL_Spec_Dual_Plot.m**
  * Script that produces a two part plot of OASPL and spectra, reproduces Mathews et al. (2021) Fig. 7.
* **OASPLComp.m**
  * **OBSOLETE - Replaced by** `OASPL_Comparison.m` **function**
  * Produces an overlaid plot of OASPL values over time from different launches and from different locations. Uses .mat files for OASPL created by `Falcon_9_Analysis.m` code.
* **plotDirectivities.m**
  * Script that plots OASPL directivities for Falcon 9 launches. Also produces mean/median/sd plot in Mathews et al. (2021) Fig. 8.
* **Power_Radiation_Efficiency.m**
  * Reproduces acoustic radiation efficiency plot (without data points) from Eldred NASA SP-8072 (1971).
* **Radiosonde_Data_Analysis.m**
  * Reads in data from *.txt* logs of radiosonde (weather balloon) data and plots atmospheric profiles of temperature, dewpoint depression, windspeed, wind direction, and a tiled plot of N-S and E-W windspeeds.
  * Uses pchip (preserves shape) 1-D interpolation to interpolate profiles for rough or non-evenly spaced data.
  * Combines directional windspeed and temperature profiles to produce a general atmospheric sound speed profile.
  * Uses *tiledlayout* function available in **MATLAB R2019b** or later versions.
* **Rocket_Trajectory_Plot.m**
  * Just plots the trajectory (altitude and downrange distance) for a single Falcon 8 launch. Reproduces Mathews et al. (2021) Fig. 2.
* **rocketDirectivityCurves.m**
  * Plots estimated rocket directivity from James et. al Directivity Curves POMA (2012).
* **RocketTrajectory.m**
  * Loads in and plots trajectory of rocket with observer time.
* **SoundspeedProfiles.m**
  * Produces interpolated soundspeed profiles. Just a stripped down version of `Radiosonde_Data_Analysis.m`.
* **Spectrum_Analysis.m**
  * Will produce and plot spectra for any launch and measurement location, either overlaid or on separate subplots. Other scripts rely upon this script.
* **Temperature_Profile_Models.m**
  * Super basic atmospheric temperature profile from NASA website. Not very accurate, but nice to compare better data to for general sanity checks.
* **TimeWaveform.m**
  * Not sure why this script exists. Looks like it loads in a file and just plots part of it. So, if you find that useful, great!
* **Waveform_Comparison.m**
  * Will produce a comparison of waveforms from any selected launches and locations and plot them in a tiled figure.
  * Uses *tiledlayout* function available in **MATLAB R2019b** or later versions.
* **Waveform_Multiplot.m**
  * **OBSOLETE - Replaced by** `Waveform_Comparison.m` **function**
  * Produces a tiled comparison plot of waveform sections from different portions of the launch sequence.
  * Also will produce OTO spectra from different times during the launch and will high-pass the data for the spectrum and waveforms.
  * Uses `tiledlayout` function available in **MATLAB R2019b** or later versions.
* **WeatherAnalysis.m**
  * Produces animated plots from different *.csv* weather files. Still a work in progress, and runs slowly on regular computers. (never ended up using this for anything).
* **Falcon_9_Audio.m**
  * Possibly the coolest script in this folder, this code will produce a stereo *.wav* file of a Falcon 9 Launch of your choosing. It requires a location that had at least two operating microphones and will use them as a right and left channel. (not in the folder anymore, but I can probably dig it up somewhere).

## Functions
* **distCalc.m**
  * This function calculates the actual distance to source of a rocket launch where trajectory information is known. Used a lot in analyses.
* **filterData.m**
  * This function filters data using different implementations of a Butterworth filter design. Proably will end up making its way out of this and into GeneralSignalProcessing at some point.
* **finddBDownRange.m**
  * This function finds the indices and spread of a specified x-dB down range of a x-y dataset (y must be in dB). Useful for McInerny type analyses using the 3- and 6-dB down range.
* **fracOctMarkerIndices.m**
  * Function to get indices for prop. band indices for markers in a plot. Also will probably end up in GeneralSignalProcessing.
* **getRocketTrajectory.m**
  * This function is the best way to get trajectory information loaded in, specific to launch annd location. Calls `distCalc.m` function to give observer-time correlated distances, etc.
* **loadFalcon9Data.m**
  ```
  [data] = loadFalcon9Data(launch,site,data_type,data_path)
  ```
  * This script contains a function that will retrieve datasets output from `Falcon_9_Analysis.m` script that have been saved as structured variables in a *.mat* file. Currently works with waveforms, running OASPL, and dSk. Requires input character arrays specifying launch and location.
* **tenthToQuarter.m**
  * I wrote this before I learned about the resample() function. Pretty much useless now.
