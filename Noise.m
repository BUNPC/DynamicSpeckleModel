%% K and sigmaK calculation

ff= pi/4;   % fill factor
Ip = I_DSM*flux/(ff*sp^2); 


for term=1:Nconfig

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
semilogx(delta_t*(1:Nt), sigmaKall)
xlabel('T_{exp} (μs)'); ylabel('\sigma(K_{all})')
