proSeq='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';

XN=2;

START=1;
END=10;
Charge=1;

pepSeq=proSeq(START:END);
[peptideMass, distND, maxND, maxD]=pepinfo(pepSeq, XN); %call pepinfo.m

monoMZ=peptideMass/Charge+1.007276; %m/z of mono; 1.007276 is the mass of proton;;

pepDarrays=[  0,   0,   0,   0,   1,   1,   1,   1;
    0.1, 0.1, 0.1, 0.1, 0.9, 0.9, 0.9, 0.9;
      0, 0.1, 0.3, 0.4, 0.6, 0.7, 0.9,   1;
    0.25, 0.25, 0.25, 0.25, 0.75, 0.75, 0.75, 0.75;
    0.4, 0.4, 0.4, 0.4, 0.6, 0.6, 0.6, 0.6;
    0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];

sampleInterv=0.002;
simMZ=floor(monoMZ-1):sampleInterv:ceil(monoMZ+(maxND+maxD)/Charge+1);

simResolutionBase=2e5;
simResolution=simResolutionBase*(400/monoMZ).^0.5; %just for Orbitrap data: the resolution decreases with square root of mass (FT-ICR MS resolution decreases linearly with mass; TOF diff ...)

figure
for i=1:6
    subplot(2,3,i)
    pepDarray=pepDarrays(i,:);
    [simPeaks, msData] = oct06_pepsim(pepSeq, Charge, [zeros(1,XN) pepDarray], XN, simMZ, simResolution, 1); %call pepsim.m
end











