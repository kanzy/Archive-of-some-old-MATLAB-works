%%%2010-11-30 nov30.m: to make simulated finalTable for nhx_simfit use

finalTable_exp=finalTable; %save original 'finalTable'

proPF_sim=10.^(-3+4*rand(size(currSeq))); %artificial protection factor array

pepPara.proSeq=currSeq;
pepPara.iniD=1;

hxPara.Temp=2;
hxPara.pH=2.5;
hxPara.fractionD=0.01;
preTime=180;

%%%to modify peptides in 113~140 region:
noiseLevel=input('Input the noise level(%) want to be randomly added (e.g. 0.1=10%; 0=noise free) :');
% for pepNum=217:242
for pepNum=1:size(finalTable,1)
    if finalTable(pepNum,12)>=1
        
        pepPara.START=finalTable(pepNum,1); %Start residue# of the peptide
        pepPara.END=finalTable(pepNum,2); %End residue# of the peptide
        pepPara.Charge=finalTable(pepNum,3); %observing charge state of the peptide in MS spectrum
        pepPara.pepPF=proPF_sim(finalTable(pepNum,1)+1:finalTable(pepNum,2)); %protection factors(could be <1) array of the peptide(First two sites and Proline could be input any number except 0)
        
        hxPara.hxTime=preTime+mean(finalTable(pepNum,7:8))*60;
        
        [obsPeaks, deuPeaks]=hx2sim(pepPara,hxPara,0);
        
        finalTable(pepNum,20:19+size(obsPeaks,1))=obsPeaks(:,2)'+ noiseLevel*obsPeaks(:,2)'.*(rand(1,size(obsPeaks,1))-0.5);
%         if finalTable(pepNum,20+size(obsPeaks,1))~=0
%             error('Wrong size!')
%         end
    end
end

clear pepPara hxPara obsPeaks deuPeaks