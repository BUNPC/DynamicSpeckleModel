% Speckle Size Calculator
% The output of this code should be used as sSize value in the DSM.m


Nt = 1; % number of time steps
Nparticles = 1000;
lambda = 0.785; %wavelength in um
k = 2*pi/lambda;  
tauc = 10; %decay time in us
D = 1/(tauc*k^2); % Diffusion coefficient in um^2/us
delta_t = 1; %time step in us
dr = sqrt(2*D*delta_t); % random walk step length 

% Scattering Volume 
xmax = 1000; % um
ymax = 1000; % um
zmax = 1000; % um

% Camera Location
xcam = xmax/2; % center of camera in x in um
ycam = ymax/2; % center of camera in y in um
zcam = zmax*3; % position of camera in z in um

% Camera Parameters
Npixels = 100; % number of pixels in x and y
dpixel = 1; % camera pixel size in um
NsampPerSpeckle = 2;  
NsampPerPixel = ceil(NsampPerSpeckle);
Nsamp = Npixels*NsampPerPixel; % total samples in um


% Camera Pixel Coordinates
xx = xcam + ones(Nsamp,1) * ( (([1:Nsamp] - 0.5*Nsamp)*dpixel/NsampPerPixel ) );
yy = ycam + ( (([1:Nsamp]' - 0.5*Nsamp)*dpixel/NsampPerPixel ) ) * ones(1,Nsamp);

for iter= 1:20
    iter
% Initial Particle Position
xp = rand(Nparticles,1)*xmax;
yp = rand(Nparticles,1)*ymax;
zp = rand(Nparticles,1)*zmax;


% Temporal Evolution
Esamp = zeros(Nsamp,Nsamp,Nt);
I = zeros(Npixels,Npixels,Nt);

for tt=1:Nt

    for nn=1:Nparticles
        
        r1 = sqrt((xp(nn)-xx).^2+(yp(nn)-yy).^2+(zp(nn)-zcam).^2);
        Esamp(:,:,tt)=Esamp(:,:,tt)+exp(sqrt(-1)*k*r1)./r1;
    
    end

    xp = xp + randn(Nparticles,1)*dr;
    yp = yp + randn(Nparticles,1)*dr;
    zp = zp + randn(Nparticles,1)*dr;
    
    xp = mod(xp,xmax);
    yp = mod(yp,xmax);
    zp = mod(zp,xmax);

end

% Intensity Calculation
Isamp = Esamp.*conj(Esamp);


% Integrate over Pixels 
for xp=NsampPerPixel:NsampPerPixel:Nsamp
    
    for yp=NsampPerPixel:NsampPerPixel:Nsamp
        
    I(xp/NsampPerPixel,yp/NsampPerPixel,:)= sum(Isamp(xp-NsampPerPixel+1:xp,yp-NsampPerPixel+1:yp,:),[1,2]);
    
    end
    
end

I = I / mean(I(:));

s(iter) = getSpeckleSize(I,10);

end


sSize=  mean(s)


