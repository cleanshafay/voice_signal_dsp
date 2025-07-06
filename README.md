# Audio Signal Processing in MATLAB

This project demonstrates various signal processing techniques on an audio file using MATLAB, including:

- Frequency domain energy analysis
- Modulation and resampling
- Impulse sampling
- Signal retrieval using sinc interpolation
- Final signal reconstruction and audio playback

## Requirements
- MATLAB (Tested on R2022b)
- Audio file (`Recording.m4a`) placed in the `/recordings` folder

## How to Run
1. Open `signal_processing.m` in MATLAB.
2. Make sure the audio path is correct or update it if needed.
3. Run the script to see all visualizations and hear the reconstructed audio.

## Notes
- The modulation frequency is 1 MHz and the resampling frequency is 4 MHz.
- Uses `sinc` function for signal reconstruction after impulse sampling.
- You can replace the audio file with your own `.m4a` or `.wav` file (remember to adjust the path).
