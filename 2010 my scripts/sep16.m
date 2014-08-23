
disp('This program is for merging two ExMS wholeResults(finalTable)...')

disp(' ')
disp('Now import the 1st exms_wholeResults_afterCheck.mat file of FD(allD)-control: ')
clear programSettings proteinName currSeq sampleName peptidesPool wholeResults finalTable
uiimport
void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
finalTable_1=finalTable;
wholeResults_1=wholeResults;

disp(' ')
disp('Now import the 2nd exms_wholeResults_afterCheck.mat file of FD(allD)-control: ')
clear programSettings proteinName currSeq sampleName peptidesPool wholeResults finalTable
uiimport
void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
finalTable_2=finalTable;
wholeResults_2=wholeResults;

disp(' ')
n=input('Input the end peptide# of 1st FD sample? (188)');


clear finalTable
finalTable=[finalTable_1(1:n,:); finalTable_2((n+1):end,:)];

clear wholeResults
for i=1:n
    wholeResults{i}=wholeResults_1{i};
end

for i=(n+1):size(wholeResults_2,1)
    wholeResults{i}=wholeResults_2{i};
end

sampleName=input('Input the sample name you want to use for the merging result: ', 's');

SaveFileName=['(',proteinName,'_',sampleName,') ExMS_wholeResults_afterCheck.mat'];
save SaveFileName
disp([SaveFileName, ' has been saved in MATLAB current directory!'])











