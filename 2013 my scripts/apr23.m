%%%apr23.m: should preload "Apr23 pre-matlab.mat" (containing 'peptidesPool' &'ssTable') just for Wenbing's MSDTCS test dataset use

cutSet=unique([peptidesPool(:,1)-1; peptidesPool(:,2)]);

Range=20;
MinPepLength=4;
ssPep1Set=[];
ssPep2Set=[];
n1=0;
n2=0;
for i=1:size(ssTable,1)
    s1=ssTable(i,1);
    s2=ssTable(i,2);
    for j=1:size(cutSet,1)
        
        if cutSet(j)>=s1-Range-1 && cutSet(j)<s1
            pep1start=cutSet(j)+1;
            for k=1:size(cutSet,1)
                if cutSet(k)>=s1 && cutSet(k)<=s1+Range
                    pep1end=cutSet(k);
                    if pep1end-pep1start+1>MinPepLength
                        n1=n1+1;
                        ssPep1Set(n1,1:3)=[pep1start, pep1end, i];
                    end
                end
            end
        end
        
        if cutSet(j)>=s2-Range-1 && cutSet(j)<s2
            pep2start=cutSet(j)+1;
            for k=1:size(cutSet,1)
                if cutSet(k)>=s2 && cutSet(k)<=s2+Range
                    pep2end=cutSet(k);
                    if pep2end-pep2start+1>MinPepLength
                        n2=n2+1;
                        ssPep2Set(n2,1:3)=[pep2start, pep2end, i];
                    end
                end
            end
        end
        
    end
end


ssPepTable=[];
n=0;
for i=1:size(ssPep1Set,1)
    pep1start=ssPep1Set(i,1);
    pep1end=ssPep1Set(i,2);
    ssNum=ssPep1Set(i,3);
    for j=1:size(ssPep2Set,1)
        if ssPep2Set(j,3)==ssNum;
            n=n+1;
            pep2start=ssPep2Set(j,1);
            pep2end=ssPep2Set(j,2);
            if pep1end<pep2start-1
                ssPepTable(n,1:5)=[pep1start, pep1end, pep2start, pep2end, 2]; %two peptides linked by S-S
                peptideMass1=pepinfo(currSeq(pep1start:pep1end), 2);
                peptideMass2=pepinfo(currSeq(pep2start:pep2end), 2);
                ssPepTable(n,6)=peptideMass1+peptideMass2-1.007825*2; %total mass equals (peptide1+peptide2)-2*H
                ssPepTable(n,7:9)=[ssNum, ssTable(ssNum,1), ssTable(ssNum,2)];
            else
                ssPepTable(n,1:5)=[pep1start, pep1end, pep2start, pep2end, 1]; %one peptide containing an S-S
                peptideMass=pepinfo(currSeq(pep1start:pep2end), 2);
                ssPepTable(n,6)=peptideMass-1.007825*2;
                ssPepTable(n,7:9)=[ssNum, ssTable(ssNum,1), ssTable(ssNum,2)];
            end
        end
    end
end
    





























