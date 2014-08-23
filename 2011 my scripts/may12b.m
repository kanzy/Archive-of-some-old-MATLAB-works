%2011-05-17 for revising ExMS

disp(' ')
disp('This program is to generate Excel files containing ExMS results.')
disp(' ')

disp('Now import the previously saved ExMS_wholeResults_afterCheck.mat file:')
uiimport
void=input('Press "Enter" to continue...'); %just waiting for uiimport complete

SaveXlsFileName=['(',proteinName,'_',sampleName,') ExMS_finalTable.xls'];
xlswrite(SaveXlsFileName, {'START','END','Charge','Monoisotopic m/z',...
    'Scan Range(start)','Scan Range(end)','RT Range(start, unit: min)','RT Range(end)',...
    'Centroid m/z','Delta Mass','maxD',...
    'ExMS performance(1=find correct, 2=auto-detemined correct, 0=nothing, -1=all wrong, 0.5=not sure)',...
    'Fit Type(1=double Gaussian, 2=Gaussian+allH, 3=double Binomials, 4=all-H, 5=Polynomial)',...
    'Fit Value 1(in the order of [Amp,Mu,Sigma,Amp,Mu,Sigma] if available)','Fit Para 2','Fit Para 3','Fit Para 4','Fit Para 5','Fit Para 6',...
    'Isotopic Envelope Amplitudes(start from this column(the Monoisotopic) to nonzero end):'},1);
xlswrite(SaveXlsFileName, finalTable, 1, 'A2');
disp(' ')
disp([SaveXlsFileName, ' has been saved in MATLAB current directory!'])
