for checkNum=45:size(wholeResults,1)
    if isfield(wholeResults{checkNum},'FitsResultSet')==0
        continue
    end
    
    disp('*************************************************************')
    START=wholeResults{checkNum}.peptide(1,1);
    END=wholeResults{checkNum}.peptide(1,2);
    Charge=wholeResults{checkNum}.peptide(1,3);

    disp(['Now check the peptide ' num2str(START) '-' num2str(END) 'cs' num2str(Charge) ':'])
    disp(['checkNum = ' num2str(checkNum)])
    
    %%%open '*_ScansAnalys.fig':
    figName=[num2str(START),'-',num2str(END),'cs',num2str(Charge),'(',proteinName,'_',sampleName,') ExMS_fig1_ScansAnalys.fig'];
    disp(['Open ', figName, '...'])
    open(figName)
    
    %%%open '*_PepScansView.fig':
    findScansRangesNum=size(wholeResults{checkNum}.findScansRanges,1);
    if findScansRangesNum>0
        for i=1:findScansRangesNum
            figName=[num2str(START),'-',num2str(END),'cs',num2str(Charge),'(',proteinName,'_',sampleName,') ExMS_fig',num2str(i+1),'_PepScansView.fig'];
            disp(['Open ', figName, '...'])
            open(figName)
        end
    end    
    
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    close all
end