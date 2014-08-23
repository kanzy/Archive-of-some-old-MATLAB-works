%%%2011-05-31 pepsim.m:
%%%2010-01-14 pepinfo.m: modify pepinfo.m to include considering N, C and S isotopes; replace maxC with maxND
%%%2010-01-06 modify to include maxC & maxD calculation
%%%2009-12-10 pepinfo.m:

function [simPeaks, simData] = oct06_pepsim(pepSeq, Charge, Darray, XN, simMZ, resolution, ifPlot)

% XN=2; %exclude N-terminal 1 or 2 residues

%%%check:
if size(pepSeq,2)~=size(Darray,2)
    error('Size of the input peptide and "D array" not match!')
end
for i=1:size(pepSeq,2)
    if pepSeq(i)=='P' && Darray(i)~=0
        disp(['Warning: Residue number ',num2str(i),' is Proline but D>0, reset D=0!'])
        Darray(i)=0;
    end
end
   

AAshort  =    ['A','C','D','E','F','G','H','I','K','L','M','N','O','P','Q','R','S','T','U','V','W','Y'];

AAcarbonNum=  [ 3,  3,  4,  5,  9,  2,  6,  6,  6,  6,  5,  4,  12, 5,  5,  6,  3,  4,  3,  5,  11, 9 ];
AAnitrogenNum=[ 1,  1,  1,  1,  1,  1,  3,  1,  2,  1,  1,  2,   3, 1,  2,  4,  1,  1,  1,  1,   2, 1 ];
AAoxygenNum=  [ 1,  1,  3,  3,  1,  1,  1,  1,  1,  1,  1,  2,   3, 1,  2,  1,  2,  2,  1,  1,   1, 2 ];
AAsulferNum=  [ 0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,   0, 0,  0,  0,  0,  0,  0,  0,   0, 0 ];

AAmonoMass=[71.037110
    103.009190
    115.026940
    129.042590
    147.068410
    57.021460
    137.058910
    113.084060
    128.094960
    113.084060
    131.040490
    114.042930
    255.158290
    97.052760
    128.058580
    156.101110
    87.032030
    101.047680
    168.964200
    99.068410
    186.079310
    163.063330]; %above values from http://en.wikipedia.org/wiki/Proteinogenic_amino_acid


peptideMass=0;
C=0; N=0; O=0; S=0;

for i=1:size(pepSeq,2)
    index=find(pepSeq(i)==AAshort);
    peptideMass=peptideMass+AAmonoMass(index);
    C=C+AAcarbonNum(index);
    N=N+AAnitrogenNum(index);
    O=O+AAoxygenNum(index);
    S=S+AAsulferNum(index);
end

peptideMass=peptideMass + (1.007825*2+15.994915); %peptide's mass is the sum of the residue masses plus the mass of water.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%calculate maxND:
obsThreshold=1e-3; %set threshold

pC13=0.0111; %natural richness of C13
distC=binopdf(0:C,C,pC13); %call MATLAB function binopdf()

pN15=0.00364; %natural richness of N15
distN=binopdf(0:N,N,pN15);

pO18=0.00205; %natural richness of O18
dist=binopdf(0:O,O,pO18);
distO=zeros(1,2*O+1);
for i=1:(O+1)
    distO(i*2-1)=dist(i);
end

% pS33=0.00762; %natural richness of S33 [ignored here]
pS34=0.04293; %natural richness of S34
if S>0
    dist=binopdf(0:S,S,pS34);
    distS=zeros(1,2*S+1);
    for i=1:(S+1)
        distS(i*2-1)=dist(i);
    end
else
    distS=1;
end

distD=1;
for i=1:size(Darray,2)-XN
    distD=conv(distD, [1-Darray(i+XN), Darray(i+XN)]);
end

deltaC=1.00335484; %the delta mass between C13(13.0033548378 u) and C12
deltaN=0.99703489; %the delta mass between N15 atom(15.0001088982 u) and N14 atom(14.0030740048 u)
deltaO=2.00424638; %the delta mass between O18 atom(17.9991610 u) and O16 atom(15.99491461956 u)
deltaS=1.99579590;%the delta mass between S34 atom(33.96786690 u) and S32 atom(31.97207100 u)
deltaD=1.00627675; %the delta mass between D atom(2.0141017778 u) and H atom(1.00782503207 u)


simPeaks=[];
n=1;
for i=1:size(distC,2)
    if distC(i)>=obsThreshold*max(distC)
        simPeaks(n,1)=0+(i-1)*deltaC;
        simPeaks(n,2)=distC(i);
        n=n+1;
    end
end
maxND=n;

simPeaks_old=simPeaks;
simPeaks=[];
n=1;
for i=1:size(simPeaks_old,1)
    for j=1:size(distN,2)
        amp=simPeaks_old(i,2)*distN(j);
        if amp>=obsThreshold*max(simPeaks_old(:,2))
            simPeaks(n,1)=simPeaks_old(i,1)+(j-1)*deltaN;
            simPeaks(n,2)=amp;
            n=n+1;
        end
    end
end

simPeaks_old=simPeaks;
simPeaks=[];
n=1;
for i=1:size(simPeaks_old,1)
    for j=1:size(distO,2)
        amp=simPeaks_old(i,2)*distO(j);
        if amp>=obsThreshold*max(simPeaks_old(:,2))
            simPeaks(n,1)=simPeaks_old(i,1)+(j-1)*deltaO;
            simPeaks(n,2)=amp;
            n=n+1;
        end
    end
end

simPeaks_old=simPeaks;
simPeaks=[];
n=1;
for i=1:size(simPeaks_old,1)
    for j=1:size(distS,2)
        amp=simPeaks_old(i,2)*distS(j);
        if amp>=obsThreshold*max(simPeaks_old(:,2))
            simPeaks(n,1)=simPeaks_old(i,1)+(j-1)*deltaS;
            simPeaks(n,2)=amp;
            n=n+1;
        end
    end
end

simPeaks_old=simPeaks;
simPeaks=[];
n=1;
for i=1:size(simPeaks_old,1)
    for j=1:size(distD,2)
        amp=simPeaks_old(i,2)*distD(j);
        if amp>=obsThreshold*max(simPeaks_old(:,2))
            simPeaks(n,1)=simPeaks_old(i,1)+(j-1)*deltaD;
            simPeaks(n,2)=amp;
            n=n+1;
        end
    end
end

simPeaks=[zeros(size(simPeaks,1),1), sortrows(simPeaks,1)];
sumInten=sum(simPeaks(:,3));
for i=1:size(simPeaks,1)
    simPeaks(i,1)=simPeaks(i,2);
    simPeaks(i,2)=(peptideMass+simPeaks(i,2))/Charge+1.007276; %1.007276 is the mass of proton
    simPeaks(i,3)=simPeaks(i,3)/sumInten;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%from pepsim2.m:
const=2*(-log(0.5))^0.5;

Y=zeros(size(simMZ));
for i=1:size(simPeaks,1)
    fwhh=simPeaks(i,2)/resolution;
    c=fwhh/const;
    a=simPeaks(i,3)/c;
    xx=find(simMZ>simPeaks(i,2)-3*c & simMZ<simPeaks(i,2)+3*c);
    Y(xx)=Y(xx)+a.*exp(-((simMZ(xx)-simPeaks(i,2))./c).^2);
end

simData=[simMZ', Y'/sum(Y)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ifPlot==1
        maxD=size(pepSeq,2)-XN;
    for m=(XN+1):size(pepSeq,2)
        if pepSeq(m)=='P'  %exclude Proline
            maxD=maxD-1;
        end
    end
% %     
% %     figure
% %     subplot(2,1,1)
% %     stem(simPeaks(:,1),simPeaks(:,3))
% %     axis([-0.5, maxND+maxD+0.5, 0, max(simPeaks(:,3)*1.1)])
% %     xlabel('Delta Mass above Monoisotopic')
% %     ylabel('Percentage of Total Amount')
% %     subplot(2,1,2)


%     stem(simPeaks(:,2),simPeaks(:,3)/sum(simPeaks(:,3)))
%     hold on
    
    plot(simData(:,1),simData(:,2)/sum(simData(:,2)),'r.-')
    axis([(peptideMass-0.5)/Charge+1.007276, (peptideMass+maxND+maxD+0.5)/Charge+1.007276, 0, 1.1*max(simData(:,2))])
    xlabel('m/z')
    ylabel('Fraction')
end
