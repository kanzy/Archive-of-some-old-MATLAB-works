%%%2011-06-20 msdfit_lev3.m:

DIndex=DIndex2; %to fit exchangable sites individually
M=size(DIndex2,1);
Dx0=[D0, 6e4]; %6e4 is the initial guess of mass resolution, may change here
lb  = [ones(1,M)*Dlb, 1e4]; %1.5e4 is the assumed lower limit of resolution, may change here;
ub  = [ones(1,M)*Dub, 3e6]; %3e5 is the assumed upper limit of resolution, may change here
fitSettings.Dx0=Dx0;
fitSettings.lb=lb;
fitSettings.ub=ub;

simPeaks_ND={};
for i=1:size(usePeps,1)
    pepSeq=proSeq(usePeps(i,1):usePeps(i,2));
    simPeaks_ND{i}=pepsim2a(pepSeq); %call pepsim2a.m to calculate 'simPeaks_ND'
    [peptideMass, distND, maxND, maxD]=pepinfo(pepSeq, XN); %call pepinfo.m
    peptidesMass(i)=peptideMass;
end

tic %start time counting
switch Algo
    case 1
        disp('Running nonlinear least-squares curve fitting of mass spectra... Please wait!')
        f = @(Dx)msdfit_fit3a(Dx, DIndex, useData, XN, simPeaks_ND, peptidesMass); %use simfit1_fita.m
        [DxFit,resnorm,residual,exitflag,output] = lsqnonlin(f,Dx0,lb,ub); %use MATLAB nonlinear least-squares curve fitting
        
    case 2
        disp('Running pattern search fitting of mass spectra... Please wait!')
        f = @(Dx)msdfit_fit3b(Dx, DIndex, useData, XN, simPeaks_ND, peptidesMass);
        [DxFit,fval,exitflag,output] = patternsearch(f, Dx0,[],[],[],[],lb,ub); %use MATLAB "pattern search" fitting method
        
    case 3
        k=50 %input('Input the number of start points to run (e.g. 50): ');
        disp('Running multi-start global fitting of mass spectra... Please wait!')
        f = @(Dx)msdfit_fit3a(Dx, DIndex, useData, XN, simPeaks_ND, peptidesMass);
        problem = createOptimProblem('lsqnonlin','objective',f,'x0',Dx0,'lb',lb,'ub',ub);
        ms = MultiStart;
        [DxFit,fval,exitflag,output,solutions] = run(ms,problem,k);
        
    case 4
        disp('Running global search fitting of mass spectra... Please wait!')
        f = @(Dx)msdfit_fit3b(Dx, DIndex, useData, XN, simPeaks_ND, peptidesMass);
        problem = createOptimProblem('fmincon','objective',f,'x0',Dx0,'lb',lb,'ub',ub);
        gs = GlobalSearch;
        [DxFit,fval,exitflag,output,solutions] = run(gs,problem);
        
    otherwise
        error('Unkown fitting method!')
end
tElapsed=toc %stop time counting(unit: sec)
DFit=DxFit(1:end-1);
DFit_sort=sort(DFit);
resolutionFit=DxFit(end); %at m/z 400
fitResults.DFit=DFit;
fitResults.resolutionFit=resolutionFit;
fitResults.output=output;
fitResults.exitflag=exitflag;
fitResults.tElapsed=tElapsed;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%Figure 2: peptides mass spectra obs/fit comparison
% h=figure;
% resSumVal=0;
% resSumNum=0;
% for i=1:size(usePeps,1)
%     subplot(rowNum,colNum,i)
%     START=usePeps(i,1);
%     END=usePeps(i,2);
%     Charge=usePeps(i,3);
%     %%%calculate simulated distribution
%     pepD=zeros(1,END-START+1-XN);
%     for j=(START+XN):END
%         [r,c]=find(DIndex==j);
%         if min(size(r))~=0
%             pepD(j-START+1-XN)=DFit(r);
%         end
%     end
%     monoMZ=peptidesMass(i)/Charge+1.007276; %1.007276 is the mass of proton
%     resolution=resolutionFit*(400/monoMZ).^0.5; %just for Orbitrap data: the resolution decreases with square root of mass (FT-ICR MS resolution decreases linearly with mass; TOF diff ...)
%     [~, simData]=pepsim(proSeq(START:END), Charge, [zeros(1,XN), pepD], XN, useData{i,2}(:,1)', resolution, 0);
%     useDataNorm=useData{i,2};
%     useDataNorm(:,2)=useDataNorm(:,2)/sum(useDataNorm(:,2));
%     plot(useDataNorm(:,1), useDataNorm(:,2), 'k.--')
%     hold on
%     plot(simData(:,1), simData(:,2), 'r.--')
%     set(gca,'xtick',[],'ytick',[])
%     axis([simData(1,1)-2/Charge,simData(end,1)+2/Charge,min(min(simData(:,2)),min(useDataNorm(:,2))),1.1*max(max(simData(:,2)),max(useDataNorm(:,2)))])
%     title([num2str(START),'--',num2str(END),'+',num2str(Charge)])
%     
%     resSumVal=resSumVal+sum((simData(:,2)-useDataNorm(:,2)).^2);
%     resSumNum=resSumNum+size(simData,1);
% end
% SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2.fig'];
% saveas(figure(h),SaveFigureName)
% disp(' ')
% disp([SaveFigureName,' has been saved in MATLAB current directory!'])
% 
% resNorm3=resSumVal/resSumNum;
% fitResults.resNorm3=resNorm3;

