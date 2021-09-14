# DynamicSpeckleModel




Our dynamic speckle model simulates the evolution of the speckle intensity pattern by calculating the superposition of the light fields scattered from multiple locations.


To run the code:
1) Download all the .m files in one folder
2) Run demo.m
  - To modify the scattering properties and the detector properties, change the corresponding parameters in ModelSettings.m

Notes:

Calculate the speckle size from sSize_Calculator.m and input the sSize value in the DSM.m code.


The demo.m outputs the speckle contrast as a function of exposure time, speckle pattern measured at exposure time 1 and 100 mus and sigma(K) for 10 configurations:

![fig1](https://user-images.githubusercontent.com/55467463/133275393-efddd1a5-9005-4a1f-aa60-de84e2d6dccc.png)
![fig2](https://user-images.githubusercontent.com/55467463/133275405-88ea8415-0280-4a77-868a-04f1d125855a.png)
![fig3](https://user-images.githubusercontent.com/55467463/133275649-1cbc9278-62d0-4500-9d92-8eaca08d54be.png)

The sigma(K) is improved by increasing Nconfig.


For any issue reporting or suggestions, please contact Sharvari Zilpelwar, sharz@bu.edu

Updated 01/09/2021
