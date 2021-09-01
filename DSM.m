% DSM

dr = sqrt(2*D*delta_t); % random walk step length
sp= sSize/dpixel;
NsampPerSpeckle = ceil(sp);  
NsampPerPixel = ceil(NsampPerSpeckle/sp);
Nsamp = Npixels*NsampPerPixel; % total samples in um


% Camera Pixel Coordinates
xx = xcam + ones(Nsamp,1) * ( (([1:Nsamp] - 0.5*Nsamp)*dpixel/NsampPerPixel ) );
yy = ycam + ( (([1:Nsamp]' - 0.5*Nsamp)*dpixel/NsampPerPixel ) ) * ones(1,Nsamp);

for iter= 1:config
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

