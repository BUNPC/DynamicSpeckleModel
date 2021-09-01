# DynamicSpeckleModel




Our dynamic speckle model simulates the evolution of the speckle intensity pattern by calculating the superposition of the light fields scattered from multiple locations.


To run the code:
1) Download all the .m files in one folder
2) Run demo.m
  - To modify the scattering properties of the biological medium and the detector properties, change the corresponding parameters in ModelSettings.m

Notes:

Calculate the speckle size from sSize_Calculator.m and input the sSize value in the DSM.m code.


The demo.m outputs the speckle contrast as a function of exposure time, speckle pattern measured at exposure time 1 and 1000 mus and the noise in the speckle contrast sigma(K):

![KvsTexp](https://user-images.githubusercontent.com/55467463/131615693-29d2eb84-53ce-4a2d-b4d1-a07c05f1dc57.png)





For any issue reporting or suggestions, please contact Sharvari Zilpelwar, sharz@bu.edu

Updated 01/09/2021
