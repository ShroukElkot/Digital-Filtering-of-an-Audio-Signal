# Digital Filtering of an Audio Signal

A MATLAB-based project for FIR filter design and practical audio filtering.  
The project provides implementations of windowed-sinc, least-squares (LS), and weighted-LS filter design methods. It demonstrates their use in an audio filtering workflow (upsampling, interference injection, filter design iterations, spectral analysis, and listening tests).

---

## Project Info
**Date:** December 2024  

---

## Features

### FIR Filter Design Tool
- Windowed-sinc FIR filter design with adjustable filter length.  
- Support for four windows: Rectangular, Blackman, Chebyshev, Kaiser.  
- Least Squares (LS) FIR filter design.  
- Weighted Least Squares (WLS) FIR filter design with user-defined weights.  
- Magnitude spectrum visualization in both linear and log scales.  

### Practical Audio Filtering
- Read and upsample audio signals.  
- Plot the frequency spectrum before and after upsampling.  
- Add sinusoidal interference and visualize its effect in time and frequency domains.  
- Design FIR filters to attenuate interference while preserving useful audio content.  
- Filter corrupted audio, compare frequency spectra, and perform listening tests.  

---

## Tech Stack
- **Language:** MATLAB  
- **Focus:** Digital Signal Processing  
