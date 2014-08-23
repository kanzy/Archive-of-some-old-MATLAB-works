%%%2011-06-20 msdfit_lev2.m:

DIndex=DIndex2; %to fit exchangable sites individually
M=size(DIndex2,1);
lb  = ones(1,M)*Dlb;
ub  = ones(1,M)*Dub;

tic %start time counting
switch Algo
    case 1
        disp('Running nonlinear least-squares curve fitting of mass spectra... Please wait!')
        f = @(D)msdfit_fit2a(D, DIndex, useData, proSeq, XN); %use simfit1_fita.m
        [DFit,resnorm,residual,exitflag,output] = lsqnonlin(f,D0,lb,ub); %use MATLAB nonlinear least-squares curve fitting
        
    case 2
        disp('Running pattern search fitting of mass spectra... Please wait!')
        f = @(D)msdfit_fit2b(D, DIndex, useData, proSeq, XN);
        [DFit,fval,exitflag,output] = patternsearch(f, D0,[],[],[],[],lb,ub); %use MATLAB "pattern search" fitting method
        
    case 3
        k=50 %input('Input the number of start points to run (e.g. 50): ');
        disp('Running multi-start global fitting of mass spectra... Please wait!')
        f = @(D)msdfit_fit2a(D, DIndex, useData, proSeq, XN);
        problem = createOptimProblem('lsqnonlin','objective',f,'x0',D0,'lb',lb,'ub',ub);
        ms = MultiStart;
        [DFit,fval,exitflag,output,solutions] = run(ms,problem,k); %not sure 30 is good
        
    case 4
        disp('Running global search fitting of mass spectra... Please wait!')
        f = @(D)msdfit_fit2b(D, DIndex, useData, proSeq, XN);
        problem = createOptimProblem('fmincon','objective',f,'x0',D0,'lb',lb,'ub',ub);
        gs = GlobalSearch;
        [DFit,fval,exitflag,output,solutions] = run(gs,problem);
        
    otherwise
        error('Unkown fitting method!')
end
tElapsed=toc %stop time counting(unit: sec)
fitResults.DFit=DFit;
fitResults.output=output;
fitResults.exitflag=exitflag;
fitResults.tElapsed=tElapsed;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%Figure 2: peptides mass spectra obs/fit comparison
% h=figure;
% resSumVal=0;
% resSumNum=0;
% for i=1:size(usePeps,1)
%     subplot(rowNum,colNum,i)
%     START=usePeps(i,1);
%     END=usePeps(i,2);
%     %%%calculate simulated distribution
%     pepD=zeros(1,END-START+1-XN);
%     for j=(START+XN):END
%         [r,c]=find(DIndex==j);
%         if min(size(r))~=0
%             pepD(j-START+1-XN)=DFit(r);
%         end
%     end
%     [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN); %call pepinfo.m
%     Distr=1;
%     for j=(START+XN):END
%         if proSeq(j)~='P'
%             Distr=conv(Distr, [1-pepD(j-START+1-XN), pepD(j-START+1-XN)]);
%         end
%     end
%     distSim=conv(distND, Distr);
%     distSim=distSim/sum(distSim); %normalization
%     %%%get normalized experimental distribution:
%     distObs=useData{i,1}(1,5:(5+maxND+maxD))/sum(useData{i,1}(1,5:(5+maxND+maxD)));
%     stem(0:maxND+maxD, distObs, 'fill', 'k', 'MarkerSize', 3)
%     hold on
%     stem(0:maxND+maxD, distSim, 'r', 'MarkerSize', 3)
%     hold on
%     axis([-1,1+maxND+maxD,min(min(distObs),min(distSim)),1.1*max(max(distObs),max(distSim))])
%     set(gca,'xtick',[],'ytick',[])
%     title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])
%     
%     resSumVal=resSumVal+sum((distObs-distSim).^2);
%     resSumNum=resSumNum+size(distObs,2);
% end
% SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2.fig'];
% saveas(figure(h),SaveFigureName)
% disp(' ')
% disp([SaveFigureName,' has been saved in MATLAB current directory!'])
% 
% resNorm2=resSumVal/resSumNum;
% fitResults.resNorm2=resNorm2;


