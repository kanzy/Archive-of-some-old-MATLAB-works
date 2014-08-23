

ModPepSet=goodPepSet;

matchSet=[];
n=1;
for i=1:size(ModPepSet,1)
    monoMZ=ModPepSet(i,5);
    Charge=ModPepSet(i,3);
    RTrange=ModPepSet(i,6:7);
    modType=ModPepSet(i,4);
    mzArray=zeros(1,4);
    for j=1:4
        mzArray(j)=monoMZ+deltamass(j-1)/Charge;
    end
    
    for j=1:size(MSMS,1)
        mz=MSMS(j,3);
        RT=MSMS(j,2);
        for k=1:4
            if abs(mzArray(k)-mz)<0.02 && RT>=RTrange(1)-1 && RT<=RTrange(2)+1
                matchSet(n,1)=j; %MSMS #
                matchSet(n,2)=i; %peptide #
                matchSet(n,3)=modType;
                n=n+1;
            end
        end
    end
end
matchSet=sortrows(matchSet,1);