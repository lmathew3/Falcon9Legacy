# Vandenberg AFB Falcon 9 Launches
![Falcon 9 Picture](/RADARSAT_Vandenberg.jpg)
This is the repository for codes relating to the Falcon 9 Launches measured at
Vandenberg AFB, CA.
## Codes in this repository
* **Falcon_9_Analysis.m**
  * A fairly comprehensive code that is partially automatic. Draws information
  about launches from `f9AltAndDRD.mat`, `f9IntParams.mat`, `f9NameParams.mat`, and `f9Trajectory.mat`.
  * Will produce singular plots of waveforms, OASPL, Distance-corrected OASPL, OASPL vs Distance-corrected OASPL, OASPL Plot of 3 dB down period, Narrowband Spectrum of 3 dB down period, OTO spectrum of 3 dB down period, OTO spectra from different times during the launch, SNR spectra from different times during the launch, dSk plot vs. time, dSk plot vs. time for first 150 s of launch, Spectrogram, and plot of trajectory.
  Will save plots automatically if specified as *.png*, *.fig*, and *.svg*.
  * Finds corrected distances with distCalc.m function.
  * Will save spectra, dSk, and OASPL values as *.mat* files.
* **Waveform_Multiplot.m**
  * **OBSOLETE - Replaced by** `Waveform_Comparison.m` **function**
  * Produces a tiled comparison plot of waveform sections from different portions of the launch sequence.
  * Also will produce OTO spectra from different times during the launch and will high-pass the data for the spectrum and waveforms.
  * Uses `tiledlayout` function available in **MATLAB R2019b** or later versions.
* **dSkMultiplot.m**
  * Produces an overlaid plot of dSk values over time from different launches and from different locations. Uses .mat files for dSk created by `Falcon_9_Analysis.m` code.
* **OASPLComp.m**
  * **OBSOLETE - Replaced by** `OASPL_Comparison.m` **function**
  * Produces an overlaid plot of OASPL values over time from different launches and from different locations. Uses .mat files for OASPL created by `Falcon_9_Analysis.m` code.
* **WeatherAnalysis.m**
  * Produces animated plots from different *.csv* weather files. Still a work in progress, and runs slowly on regular computers.
* **Falcon_9_Audio.m**
  * Possibly the coolest script in this folder, this code will produce a stereo *.wav* file of a Falcon 9 Launch of your choosing. It requires a location that had at least two operating microphones and will use them as a right and left channel.
* **loadFalcon9Data.m**
  ```
  [data] = loadFalcon9Data(launch,site,data_type,data_path)
  ```
  * This script contains a function that will retrieve datasets output from `Falcon_9_Analysis.m` script that have been saved as structured variables in a *.mat* file. Currently works with waveforms, running OASPL, and dSk. Requires input character arrays specifying launch and location.
* **Waveform_Comparison.m**
  * Will produce a comparison of waveforms from any selected launches and locations and plot them in a tiled figure.
  * Uses *tiledlayout* function available in **MATLAB R2019b** or later versions.
* **OASPL_Comparison.m**
  * Will produce a comparison of running OASPL's from any selected launches and locations and plot them in a tiled figure.
  * Uses *tiledlayout* function available in **MATLAB R2019b** or later versions.
* **Autocorrelation_Analysis.m**
  * Performs an autocorrelation analysis on a selected dataset and plots normalized autocorrelation as a function of lag (tau).
* **Crosscorrelation_Analysis**
  * Performs a cross-correlation analysis between two selected datasets and plots normalized cross-correlation coefficient as a function of lag (tau).
  * Option to use the Hilbert transform to produce and plot envelope function of the autocorrelation coefficient. Plots on a logarithmic y axis. See Harker et al. JASA (2013).
* **Coherence_Analysis.m**
  * Performs a coherence analysis between two selected datasets and plots the coherence between the two signals.
* **Radiosonde_Data_Analysis.m**
  * Reads in data from *.txt* logs of radiosonde (weather balloon) data and plots atmospheric profiles of temperature, dewpoint depression, windspeed, wind direction, and a tiled plot of N-S and E-W windspeeds.
  * Uses pchip (preserves shape) 1-D interpolation to interpolate profiles for rough or non-evenly spaced data.
  * Combines directional windspeed and temperature profiles to produce a general atmospheric sound speed profile.
  * Uses *tiledlayout* function available in **MATLAB R2019b** or later versions.
* **Elevation_Profiles.m**
  * Contains rough elevation profiles from SLC-4E to North/West field, East Field, and Miguelito sites. Uses pchip method 1-D interpolation to place the data on a 1 m resolution grid.
* **OASPL_Distance_Correcting_Analysis.m**
  * Plots OASPL, similar functioning to `OASPL_Comparison.m`, but also uses distance correcting measures to "correct" for spherical spreading to a common distance.
  * TODO: Add functionality to plot directivity (angle re plume) and different trajectory for SAOCOM 1A and RADARSAT Constellation Launches.
