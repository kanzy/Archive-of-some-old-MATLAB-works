%%%2010-07-07 renamed to simfit1_fita.m: for mass spectra fitting
%%%2010-07-01 simfit1_fit.m: should be called by simfit1.m

function F=may31_msdfit_algo2(Dx, DIndex, useData, proSeq, X)

% X=1; %exclude N-terminal 1 or 2 residues

simAll=[];
obsAll=[];

resolution=Dx(end);

for i=1:size(useData,1)
    
    START=useData{i,1}(1,1);
    END=useData{i,1}(1,2);
    Charge=useData{i,1}(1,3);
    
    %%%calculate simulated distribution
    pepD=zeros(1,END-START+1-X);
    for j=(START+X):END
        [r,c]=find(DIndex==j);
        if min(size(r))~=0
            pepD(j-START+1-X)=Dx(r); %2011-06-01: older version might be wrong here!
        end
    end
    
    [~, simData]=pepsim(proSeq(START:END), Charge, [zeros(1,X), pepD], X, useData{i,2}(:,1)', resolution, 0);

    %%%get normalized experimental distribution:
    obs=useData{i,2}(:,2)/sum(useData{i,2}(:,2));

    %%%combine:
    simAll=[simAll simData(:,2)'];
    obsAll=[obsAll obs'];
    
end

F=sum((simAll-obsAll).^2);


