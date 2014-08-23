%%%2011-05-24 revision: consider peak FWHH; also in msdfit should use Algo 4
%%%2011-05-09 may09.m:

clear
clear data textdata
close all

pepSeq='HHHHHHIIKIIK';
proSeq=pepSeq;

CS=input('Input the charge state of the peptide data: ');

[peptideMass, distND, maxND, maxD]=pepinfo(pepSeq, 2); %call pepinfo.m

monoMZ=peptideMass/CS+1.007276; %m/z of mono; 1.007276 is the mass of proton;

disp(' ')
disp('Now import the .csv simulated data file...')
uiimport
void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
AnalyName=input('Input the name of this analysis: ','s');

x=find(data(:,1)>=monoMZ-2 & data(:,1)<=monoMZ+(maxND+maxD)/CS+2);
subdata=data(x,:);

[expPeaks, PFWHH, PExt]=mspeaks(subdata(:,1), subdata(:,2), 'PeakLocation', 0); %call mspeaks

expPeaks_origin=expPeaks;
flagFWHH=input('Want to use FWHH correction? (1=yes,0=no)');
if flagFWHH==1
    expPeaks(:,2)=expPeaks(:,2).*(PFWHH(:,2)-PFWHH(:,1));
end

selectPeaks=zeros((1+maxND+maxD),2); %pre-allocate
for i=0:(maxND+maxD)
    selectPeaks(i+1,1)=monoMZ+deltamass(i)/CS;
end

mzThresholdAbs=0.02;
[selectPeaksRawMZ, selectPeaks(:,2)]=may09_peakselect(selectPeaks(:,1), expPeaks, mzThresholdAbs); %call peakselect.m

h=figure;
plot(subdata(:,1),subdata(:,2)/max(subdata(:,2)))
hold on
stem(expPeaks_origin(:,1),expPeaks_origin(:,2)/max(expPeaks_origin(:,2)),'m')
hold on
stem(selectPeaks(:,1),selectPeaks(:,2)/max(selectPeaks(:,2)),'r:')
hold on
for i=1:size(PFWHH,1)
    fwhh=expPeaks(i,2)/(2*max(expPeaks(:,2)));
    plot(PFWHH(i,:),[fwhh,fwhh],'r:')
    hold on
end
SaveFigureName=['(',AnalyName,')_MSDFIT_raw data figure.fig'];
saveas(figure(h),SaveFigureName)

finalTable=[];
finalTable(1,1)=1;
finalTable(1,2)=size(pepSeq,2);
finalTable(1,3)=CS;
finalTable(1,4)=monoMZ;
finalTable(1,11)=maxD;
finalTable(1,12)=1;
finalTable(1,20:19+size(selectPeaks,1))=selectPeaks(:,2);

may30_msdfit

DFit_Sort=sort(DFit)
FinalRecord=[DFit_Sort, tElapsed, resNorm];


