
%%%ApoAI sequence:
currSeq='DEPPQSPWDRVKDLATVYVDVLKDSGRDYVSQFEGSALGKQLNLKLLDNWDSVTSTFSKLREQLGPVTQEFWDNLEKETEGLRQEMSKDLEEVKAKVQPYLDDFQKKWQEEMELYRQKVEPLRAELQEGARQKLHELQEKLSPLGEEMRDRARAHVDALRTHLAPYSDELRQRLAARLEALKENGGARLAEYHAKATEHLSTLSEKAKPALEDLRQGLLPVLESFKVSFLSALEEYTKKLNTQ';

%%%from exms_preload.m:
disp(' ')
flagTheor=1; %input('Want to generate "theoryPool" for finding potential identical peptides outside experimental pool?(1=yes,0=skip)');
if flagTheor==1
    disp('Now program will generate "theoryPool"')
    peptideLengthMin=3; %input('Input the minimum peptide length(e.g. 3): ');
    peptideLengthMax=25; %input('Input the maximum peptide length(e.g. 40): ');
    peptideChargeMin=1; %input('Input the minimum peptide charge(e.g. 1): ');
    peptideChargeMax=1; %input('Input the maximum peptide charge(e.g. 5): ');
    mzDetectMin=200; %input('Input the minimum m/z detect limit(e.g. 200): ');
    mzDetectMax=20000; %input('Input the maximum m/z detect limit(e.g. 2000): ');
    disp('Establishing theoryPool... Please wait!')
    tpCt=0; %theoryPool count
    for i=1:size(currSeq,2)
        for j=peptideLengthMin:peptideLengthMax %peptide length loop
            if i+j-1<=size(currSeq,2) %sequence range check
                subSeq=currSeq(i:i+j-1);
                [peptideMass, distND, maxND, maxD]=pepinfo(subSeq, 2); %call my function pepinfo.m
                for k=peptideChargeMin:peptideChargeMax %peptide charge loop
                    monoMZ=peptideMass/k+1.007276; %1.007276 is the mass of proton
                    if monoMZ>=mzDetectMin && monoMZ<=mzDetectMax %m/z range check
                        theoryPool(tpCt+1,1)=i; %START
                        theoryPool(tpCt+1,2)=i+j-1; %END
                        theoryPool(tpCt+1,3)=k; %Charge
                        theoryPool(tpCt+1,4)=monoMZ; %m/z of mono
                        theoryPool(tpCt+1,5)=maxND; %the observable isotope peaks number of this peptide of ND(allH) sample
                        theoryPool(tpCt+1,6)=maxD; %the exchangable hydrogen number of this peptide
                        tpCt=tpCt+1 %theoryPool count
                    end
                end
            end
        end
    end
    disp('Done!')
    disp(['There are total ', num2str(size(theoryPool,1)), ' peptides in this established theoretical peptide pool.'])
else
    theoryPool=[];
end

%%%call simpep.m
mzThreshold=20; %ppm window
pepList_isobarSet=cell(size(pepList,1),1);
for i=1:size(pepList,1)
    disp(i)
    START=pepList(i,1);
    END=pepList(i,2);
    pepList_isobarSet{i,1}=simpep(START, END, 1, theoryPool, 1, mzThreshold);
end












