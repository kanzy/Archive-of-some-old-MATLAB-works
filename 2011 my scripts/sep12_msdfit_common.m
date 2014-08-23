%%%2011-08-24 msdfit_common.m: to be called by msdfit.m

START=finalTable(pepIndex,1);
END=finalTable(pepIndex,2);
CS=finalTable(pepIndex,3);
pepSeq=proSeq(finalTable(pepIndex,1):finalTable(pepIndex,2));
[peptideMass, distND, maxND, maxD]=pepinfo(pepSeq, XN); %call pepinfo.m
selectPeaks=zeros(1+maxND+maxD,2);
monoMZ=peptideMass/CS+1.007276; %m/z of mono; 1.007276 is the mass of proton
for i=0:maxND+maxD
    selectPeaks(i+1,1)=monoMZ+deltamass(i)/CS;
end
finalTable=[finalTable, zeros(size(finalTable,1),2)]; %2011-09-09 added for inconsistent XN set problem
selectPeaks(:,2)=finalTable(pepIndex,20:(20+maxND+maxD))';
switch InputDataType
    case 1
        selectData=wholeResults{pepIndex}.selectData; %2011-07-18 revised
    case 2
        selectData=simDataSet{pepIndex}; %from prep of msdfit_siminput
    case 3
        selectData=wholeResults{pepIndex}.selectData; %2011-08-03 added
end

%%%manual check:
close all
h=figure;
plot(selectData(:,1), selectData(:,2)/max(selectData(:,2)), 'k.-')
hold on
stem(selectPeaks(:,1), selectPeaks(:,2)/max(selectPeaks(:,2)), 'r')
xlabel('m/z')
ylabel('Relative Amplitude')
title({['Peptide ',num2str(START),'--',num2str(END),' +',num2str(CS)]; '(Black: data points for fitLevel 3; Red: calculated isotopic peaks amplitude for fitLevel 2)'})

% SaveFigureName=['(',AnalyName,')_MassSpectrum.fig'];
% saveas(figure(h),SaveFigureName)
% disp(' ')
% disp([SaveFigureName,' has been saved in MATLAB current directory!'])


disp(' ')
disp(['See the mass spectrum of the peptide (',num2str(START),'--',num2str(END),' +',num2str(CS),') with its isotopic peaks gross (red) and fine (black) structure ...'])

if ifCheckEach==1
    flag=input('Is this peptide good to use? (1=yes, 0=no) ');
else
    flag=1;
end





