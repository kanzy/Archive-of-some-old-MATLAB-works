%%%2011-05-24 revision: consider peak FWHH; also in msdfit should use Algo 4
%%%2011-05-09 may09.m:

clear
clear data textdata
close all

pepSeq='ALKDAQTRITK';
% pepSeq='QTRITK';
proSeq=pepSeq;

[peptideMass, distND, maxND, maxD]=pepinfo(pepSeq, 2); %call pepinfo.m

disp(' ')
disp('Now import the .csv simulated data file...')
uiimport
void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
AnalyName=input('Input the name of this analysis: ','s');

% expPeaks=exms_mspeakfind(data, 3);


[expPeaks, PFWHH, PExt]=mspeaks(data(:,1), data(:,2), 'PeakLocation', 0); %call mspeaks

% expPeaks_origin=expPeaks;
expPeaks(:,2)=expPeaks(:,2).*(PFWHH(:,2)-PFWHH(:,1));

selectPeaks=zeros((1+maxND+maxD),2); %pre-allocate
for i=0:(maxND+maxD)
    selectPeaks(i+1,1)=deltamass(i);
end

mzThresholdAbs=0.02;
[selectPeaksRawMZ, selectPeaks(:,2)]=may09_peakselect(selectPeaks(:,1), expPeaks, mzThresholdAbs); %call peakselect.m

h=figure;
plot(data(:,1),data(:,2)/max(data(:,2)))
hold on
% stem(expPeaks_origin(:,1),expPeaks_origin(:,2)/max(expPeaks_origin(:,2)),'m')
% hold on
stem(selectPeaks(:,1),selectPeaks(:,2)/max(selectPeaks(:,2)),'r:')
hold on
for i=1:size(PFWHH,1)
    fwhh=expPeaks(i,2)/(2*max(expPeaks(:,2)));
    plot(PFWHH(i,:),[fwhh,fwhh],'r:')
    hold on
%     stem(PFWHH(i,1),expPeaks(i,2)/max(expPeaks(:,2)),'y:')
%     hold on
%     stem(PFWHH(i,2),expPeaks(i,2)/max(expPeaks(:,2)),'y:')
%     hold on
end
% for i=1:size(PExt,1)
%     stem(PExt(i,1),expPeaks(i,2),'g:')
%     hold on
%     stem(PExt(i,2),expPeaks(i,2),'g:')
%     hold on
% end
SaveFigureName=['(',AnalyName,')_MSDFIT_raw data figure.fig'];
saveas(figure(h),SaveFigureName)

finalTable=[];
finalTable(1,1)=1;
finalTable(1,2)=size(pepSeq,2);
finalTable(1,3)=1;
finalTable(1,4)=peptideMass/finalTable(1,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton;
finalTable(1,11)=maxD;
finalTable(1,12)=1;
finalTable(1,20:19+size(selectPeaks,1))=selectPeaks(:,2);

%%%Save above result:
% SaveFileName='May09_MSDFIT_simFinalTable.mat';
% save(SaveFileName,'proSeq','data','finalTable')

may24_msdfit

DFit_Sort=sort(DFit)
FinalRecord=[DFit_Sort, tElapsed, resNorm];


