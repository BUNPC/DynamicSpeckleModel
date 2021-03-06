% DSM Parameters

clear all

Nt = 100; % number of time steps
Nparticles = 5000;
lambda = 0.785; %wavelength in um
k = 2*pi/lambda;  
tauc = 10; %decay time in us
D = 1/(tauc*k^2); % Diffusion coefficient in um^2/us
delta_t = 1; %time step in us
sSize = 1.724; % in um   
Nconfig = 10; 
sp=2;
NsampPerSpeckle = 4;  

% Camera Parameters
Npixels = 10; % number of pixels in x and y

% Scattering Volume 
xmax = 1000; % um
ymax = 1000; % um
zmax = 1000; % um

% Camera Location
xcam = xmax/2; % center of camera in x in um
ycam = ymax/2; % center of camera in y in um
zcam = zmax*3; % position of camera in z in um

% Noise Parameters
flux = 100; % photons/speckle/us
B = 0;  % bias in e-
sigmar = 1.4; % in e-
QE = 1;         
Id= 1e-6; % photons/speckle/us
