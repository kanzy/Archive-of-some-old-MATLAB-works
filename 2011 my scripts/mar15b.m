%%%similar to mar08b.m:

clear theoryPool

% currSeq=aSyn_rev
currSeq=aSyn_E83K;

disp('Now program will generate "theoryPool"')
peptideLengthMin=3;
peptideLengthMax=140;
peptideChargeMin=1;
peptideChargeMax=6;
mzDetectMin=300;
mzDetectMax=2000;

disp('Establishing theoryPool... Please wait!')
tpCt=0; %theoryPool count
for i=1:size(currSeq,2)
    for j=peptideLengthMin:peptideLengthMax %peptide length loop
        if i+j-1<=size(currSeq,2) %sequence range check
            subSeq=currSeq(i:i+j-1);
            [peptideMass, distND, maxND, maxD]=pepinfo(subSeq); %call my function pepinfo.m
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
