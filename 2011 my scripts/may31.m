%%%2011-05-24 revision: consider peak FWHH; also in msdfit should use Algo 4
%%%2011-05-09 may09.m:

% clear
close all

pepSeq='ALKDAQTRITK';
% pepSeq='QTRITK';
pepSeq='HHHHHHIIKIIK';
proSeq=pepSeq;

[peptideMass, distND, maxND, maxD]=pepinfo(pepSeq, 2); %call pepinfo.m
Charge=input('Input the charge state of the peptide: ');
monoMZ=peptideMass/Charge+1.007276; %1.007276 is the mass of proton;

% disp(' ')
% disp('Now import the .csv simulated data file...')
% uiimport
% void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
% data_origin=data;
% data(:,1)=monoMZ+data_origin(:,1)/Charge;

% data=subdata; %for model peptide HHHHHHIIKIIK use

data=simData; %for direct simulated data use (by pepsim.m)

AnalyName=input('Input the name of this analysis: ','s');


[expPeaks, PFWHH, PExt]=mspeaks(data(:,1), data(:,2), 'PeakLocation', 0); %call mspeaks


selectPeaks=zeros((1+maxND+maxD),2); %pre-allocate
for i=0:(maxND+maxD)
    selectPeaks(i+1,1)=monoMZ+deltamass(i)/Charge;
end

mzThresholdAbs=0.02;
[selectPeaksRawMZ, selectPeaks(:,2)]=may31_peakselect(selectPeaks(:,1), expPeaks, mzThresholdAbs); %call peakselect.m


selectData=[];
for i=1:size(selectPeaksRawMZ,1)
    x=find(selectPeaksRawMZ(i)==expPeaks(:,1));
    if min(size(x))>0
%         xx=find(data(:,1)>=PExt(x,1) & data(:,1)<=PExt(x,2));
        xx=find(data(:,1)>=(PFWHH(x,1)+PExt(x,1))/2 & data(:,1)<=(PFWHH(x,2)+PExt(x,2))/2);
        selectData=[selectData; data(xx,:)];
    end
end

h=figure;
plot(data(:,1),data(:,2),'k*-')
hold on
plot(selectData(:,1),selectData(:,2),'bo-')
SaveFigureName=['(',AnalyName,')_MSDFIT_raw data figure.fig'];
saveas(figure(h),SaveFigureName)


finalTable=[];
finalTable(1,1)=1;
finalTable(1,2)=size(pepSeq,2);
finalTable(1,3)=Charge;
finalTable(1,4)=peptideMass/finalTable(1,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton;
finalTable(1,11)=maxD;
finalTable(1,12)=1;
finalTable(1,20:19+size(selectPeaks,1))=selectPeaks(:,2);

finalDataSet={};
finalDataSet{1}=selectData;

may31_msdfit

DFit_Sort=sort(DFit)
FinalRecord=[DFit_Sort, resolutionFit, tElapsed, resNorm];


