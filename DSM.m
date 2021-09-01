
% DSM Code

clear all
tic
Nt = 1000; % number of time steps
Nparticles = 1000;
lambda = 0.785; %wavelength in um
k = 2*pi/lambda;  
tauc = 10; %decay time in us
D = 1/(tauc*k^2); % Diffusion coefficient in um^2/us
delta_t = 1; %time step in us
dr = sqrt(2*D*delta_t); % random walk step length
sSize = 1.74; % in um   

% Scattering Volume 
xmax = 1000; % um
ymax = 1000; % um
zmax = 1000; % um

% Camera Location
xcam = xmax/2; % center of camera in x in um
ycam = ymax/2; % center of camera in y in um
zcam = zmax*3; % position of camera in z in um

% Camera Parameters
Npixels = 20; % number of pixels in x and y
dpixel = 1; % camera pixel size in um
sp= sSize/dpixel;
NsampPerSpeckle = ceil(sp);  
NsampPerPixel = ceil(NsampPerSpeckle/sp);
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

I = reshape(I,[Npixels*Npixels Nt]);

I_DSM(:,:,iter)= cumsum(I,2); % time integrated intensity

K(:,iter)= std(I_DSM(:,:,iter),[],1)./mean(I_DSM(:,:,iter),1); % intrinsic signal contrast 

end


figure(1);semilogx(delta_t*(1:Nt),mean(K,2))
xlabel('T_{exp} (μs)'); ylabel('K')
Iframe1=reshape(I_DSM(:,1,1),Npixels,Npixels);
Iframe2=reshape(I_DSM(:,Nt,1),Npixels,Npixels);
figure(2); 
subplot(1,2,1)
imagesc(Iframe1); colorbar
title(sprintf('T_{exp}= %d μs',delta_t*1));
subplot(1,2,2)
imagesc(Iframe2); colorbar
title(sprintf('T_{exp}= %d μs',delta_t*Nt));

%% K and sigmaK calculation

flux = 1;      % photons/speckle/us
B = 0;          % bias in e-
sigmar = 1.5;   % in e-
QE = 1;         
ff= pi/4;   % fill factor
Ip = I_DSM*flux/(ff*sp^2); 
Id= 1e-6;   % in us


for term=1:iter 

Idark = Id*ones([Npixels*Npixels Nt]);
Idark = cumsum(Idark,2);

Iread = normrnd(B,sigmar,[Npixels*Npixels 1]);
Iread = repmat(Iread,[1 Nt]);

% Total Intensity

Zp = poissrnd(QE*squeeze(Ip(:,:,term)))+round(Iread)+poissrnd(Idark);

% Contrast 

Kall(:,term) = std(Zp,[],1)./mean(Zp,1);

end

% Noise in Contrast

sigmaKall = std(Kall',1);

figure(3);
semilogx(delta_t*Nt, sigmaKall)
xlabel('T_{exp} (μs)'); ylabel('\sigma(K_{all})')
toc
