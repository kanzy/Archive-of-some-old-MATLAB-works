
disp(' ')
disp('This program is to generate Excel files containing ExMS-CL results.')
disp(' ')

disp('Now import the previously saved ExMS-CL_sites.mat file:')
uiimport
void=input('Press "Enter" to continue...'); %just waiting for uiimport complete

SaveXlsFileName=['(',proteinName,'_',sampleName,') ExMS-CL_sites.xls'];
xlswrite(SaveXlsFileName, {'START','END','Charge','Modification','m/z(mono)','RT(start)','RT(end)','Intensity'}, 1);
xlswrite(SaveXlsFileName, goodPepSet, 1, 'A2');
xlswrite(SaveXlsFileName, {'START','END','Charge','Modification','m/z(mono)','RT(start)','RT(end)','Intensity','Sharing Times'}, 2);
xlswrite(SaveXlsFileName, goodModPepSet, 2, 'A2');
xlswrite(SaveXlsFileName, {'Residue#','Modification','START','END','Charge','1/(Sharing Times)'}, 3);
xlswrite(SaveXlsFileName, proModTable, 3, 'A2');
disp(' ')
disp([SaveXlsFileName, ' has been saved in MATLAB current directory!'])
disp('The 1st spreadsheet contains "goodPepSet";')
disp('The 2nd spreadsheet contains "goodModPepSet";')
disp('The 3rd spreadsheet contains "proModTable";')

disp(' ')
flag=input('Also have ExMS-CL_MSMS.mat result? (1=yes, 0=no) ');
if flag==1
    disp('Now import the previously saved ExMS-CL_MSMS.mat file:')
    uiimport
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    
    SaveXlsFileName=['(',proteinName,'_',sampleName,') ExMS-CL_MSMS.xls'];
    xlswrite(SaveXlsFileName, {'START','END','Charge','Modification','m/z(mono)','RT(start)','RT(end)','Intensity','MSMS scan#','MSMS RT','Residue# of Modification','MSMS Score'}, 1);
    xlswrite(SaveXlsFileName, goodPepSet_MSMS, 1, 'A2');
    xlswrite(SaveXlsFileName, {'START','END','Charge','Modification','m/z(mono)','RT(start)','RT(end)','Intensity','MSMS scan#','MSMS RT','Residue# of Modification','MSMS Score'}, 2);
    xlswrite(SaveXlsFileName, goodModPepSet_MSMS, 2, 'A2');
    xlswrite(SaveXlsFileName, {'Residue#','Modification','START','END','Charge','MSMS Score'}, 3);
    xlswrite(SaveXlsFileName, proModTable_MSMS, 3, 'A2');
    disp(' ')
    disp([SaveXlsFileName, ' has been saved in MATLAB current directory!'])
    disp('The 1st spreadsheet contains "goodPepSet_MSMS";')
    disp('The 2nd spreadsheet contains "goodModPepSet_MSMS";')
    disp('The 3rd spreadsheet contains "proModTable_MSMS";')
end


