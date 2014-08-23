switch Algo
    case 1
        disp(' ')
        disp('Running nonlinear least-squares curve fitting of mass spectra... Please wait!')
        options=optimset('TolX',1e-9,'TolFun',1e-9,'MaxIter',1e4, 'MaxFunEvals',1e4);
        f = @(kex)mskfit_fit2a(kex, DIndex, wholeData, proSeq, XN, HXfactors); %use simfit1_fita.m
        [kexFit,resnorm,residual,exitflag,output] = lsqnonlin(f,kex0,lb,ub, options); %use MATLAB nonlinear least-squares curve fitting
        
    case 2
        disp(' ')
        disp('Running pattern search fitting of mass spectra... Please wait!')
        f = @(kex)mskfit_fit2b(kex, DIndex, wholeData, proSeq, XN, HXfactors);
        [kexFit,fval,exitflag,output] = patternsearch(f,kex0,[],[],[],[],lb,ub); %,options); %use MATLAB "pattern search" fitting method
        
    case 3
        disp(' ')
        disp('Running multi-start global fitting of mass spectra... Please wait!')
        f = @(kex)mskfit_fit2a(kex, DIndex, wholeData, proSeq, XN, HXfactors); %use simfit1_fita.m
        problem = createOptimProblem('lsqnonlin','objective',f,'x0',kex0,'lb',lb,'ub',ub);
        ms = MultiStart;
        [kexFit,fval,exitflag,output,solutions] = run(ms,problem,k_nsp);
        
    case 4
        disp(' ')
        disp('Running global search fitting of mass spectra... Please wait!')
        f = @(kex)mskfit_fit2b(kex, DIndex, wholeData, proSeq, XN, HXfactors);
        problem = createOptimProblem('fmincon','objective',f,'x0',kex0,'lb',lb,'ub',ub);
        gs = GlobalSearch;
        [kexFit,fval,exitflag,output,solutions] = run(gs,problem);
        
    case 5 
        disp(' ')
        disp('Running simulated annealing fitting of mass spectra... Please wait!')
        f = @(kex)mskfit_fit2b(kex, DIndex, wholeData, proSeq, XN, HXfactors);
        [kexFit,fval,exitflag,output] = simulannealbnd(f,kex0,lb,ub); %use MATLAB "simulated annealing" fitting method
        
    case 6 
        disp(' ')
        disp('Running genetic algorithm fitting of mass spectra... Please wait!')
        f = @(kex)mskfit_fit2b(kex, DIndex, wholeData, proSeq, XN, HXfactors);
        [kexFit,fval,exitflag] = ga(f,size(kex0,2),[],[],[],[],lb,ub);
        
    otherwise
        error('Unkown fitting method!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function F=mskfit_fit2a(kex, DIndex, wholeData, proSeq, XN, HXfactors)

global flagBXC 
bxTemp=0; 
bxPH=2.5;
HXdir=HXfactors.HXdir;
Dlb=HXfactors.Dlb; 
Dub=HXfactors.Dub; 

distSimAll=[];
distObsAll=[];

if flagBXC==1 
    flagBXClocal=1;
else
    flagBXClocal=0;
end
STARTset=zeros(1,size(wholeData,1));
ENDset=zeros(1,size(wholeData,1));
TPset=zeros(1,size(wholeData,1));
bxTimeSet=zeros(1,size(wholeData,1));
pepSeqSet=cell(1,size(wholeData,1));
distObsSet=cell(1,size(wholeData,1));
for i=1:size(wholeData,1)
    STARTset(i)=wholeData{i,1}(1,1);
    ENDset(i)=wholeData{i,1}(1,2);
    TPset(i)=wholeData{i,1}(1,4);
    bxTimeSet(i)=wholeData{i,3}(1,1);
    pepSeqSet{i}=proSeq(STARTset(i):ENDset(i));
    distObsSet{i}=wholeData{i,1}(1,6:end)/sum(wholeData{i,1}(1,6:end));
end

parfor i=1:size(wholeData,1)
    proSeq2=proSeq;
    START=STARTset(i);
    END=ENDset(i);
    currTP=TPset(i);
    if flagBXClocal==1 
        bxTime=bxTimeSet(i);
    end
    %%%calculate simulated distribution
    pepD=ones(1,END-START+1-XN);
    for j=(START+XN):END
        r=find(DIndex==j);
        if min(size(r))~=0
            kcDH=fbmme_dh(pepSeqSet{i}, bxPH, bxTemp, 'poly');
            if HXdir==1 %H->D
                pepD(j-START+1-XN)=((Dub-Dlb)*(1-exp(-kex(r)*currTP))+Dlb)*exp(-kcDH(j-START+1)*bxTime); %2013-11-14 added
            else %D->H
                pepD(j-START+1-XN)=((Dub-Dlb)*exp(-kex(r)*currTP)+Dlb)*exp(-kcDH(j-START+1)*bxTime);
            end
        end
    end
    [~, distND, ~, ~]=pepinfo(pepSeqSet{i}, XN); %call pepinfo.m
    Distr=1;
    for j=(START+XN):END
        if proSeq2(j)~='P'
            Distr=conv(Distr, [1-pepD(j-START+1-XN), pepD(j-START+1-XN)]);
        end
    end
    distSim=conv(distND, Distr);
    distSim=distSim/sum(distSim); 
    distObs=distObsSet{i};
   
    pepCorr=pepSumInten^0.5;
    noiseLevel=1000; %depends on Orbi data and number transformation in finalTable
    for j=6:(6+maxND+maxD)
        peakCorr=((wholeData{i,1}(1,j)+noiseLevel)/pepSumInten)^(-0.5);
        distSim(j-4)=distSim(j-4)*peakCorr;
        distObs(j-4)=distObs(j-4)*peakCorr;
    end

    distSimAll=[distSimAll distSim*pepCorr];
    distObsAll=[distObsAll distObs*pepCorr];
end

F=distSimAll-distObsAll;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function F=mskfit_fit2b(kex, DIndex, wholeData, proSeq, XN, HXfactors)
...    
F=sum((distSimAll-distObsAll).^2);



