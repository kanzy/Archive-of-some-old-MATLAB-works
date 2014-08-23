
currSeq='KITEGKLVIWINGDKGYNGLAEVGKKFEKDTGIKVTVEHPDKLEEKFPQVAATGDGPDIIFWAHDRFGGYAQSGLLAEITPDKAFQDKLYPFTWDAVRYNGKLIAYPIAVEALSLIYNKDLLPNPPKTWEEIPALDKELKAKGKSALMFNLQEPYFTWPLIAADGGYAFKYENGKYDIKDVGVDNAGAKAGLTFLVDLIKNKHMNADTDYSIAEAAFNKGETAMTINGPWAWSNIDTSKVNYGVTVLPTFKGQPSKPFVGVLSAGINAASPNKELAKEFLENYLLTDEGLEAVNKDKPLGAVALKSYEEELAKDPRIAATMENAQKGEIMPNIPQMSAFWYAVRTAVINAASGRQTVDEALKDAQTRITK'; %MBP sequence
proteinName='MBP';

for testNum=1:6
    
        disp(' ')
        disp(['Import the corresponding Oct22new_TwoPopSim.mat for Test #',num2str(testNum)])
        uiimport
        void=input('Enter to continue ...');
        
    for subPop=1:2
        disp(' ')
        sampleName=['Test#',num2str(testNum),'_Population#',num2str(subPop)];
        
        wholeResults=cell(size(finalTable));
        for i=1:size(finalTable,1)
            finalTable(i,10)=raw((i-1)*6+testNum, 2*(subPop+1))-raw((i-1)*6+testNum, 9);
            wholeResults{i,1}.selectData=[];
        end
        
        SaveFileName=['(Oct22_MBP Simulation_',sampleName,') ExMS_wholeResults_afterCheck.mat']; %2012-02-27 added from exms_whole_check1.m
        save(SaveFileName,'currSeq','proteinName','sampleName','wholeResults','finalTable')
        disp(' ')
        disp([SaveFileName, ' has been saved in MATLAB current directory!'])

 
    end
end