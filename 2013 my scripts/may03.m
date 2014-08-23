
%%%may03.m: adapted from 2013-04-18 msdfit_landscape.m, should first have
%%%['(',AnalyName,')_MSDFit Landscape(total ',num2str(feb22totalRunNum),'
%%%runs) Workspace Save.mat file in space



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%Figure 2A: peptides mass spectra obs/fit comparison
    
    runNum=input('Input the run number to be used: ');
    iterNum=input('Input the iteration number to be used: ');
    
    iterD=totalHistory{runNum,1}.D;
    DFit=iterD(iterNum,:);
    

    totalFigNum=ceil(size(usePeps,1)/(rowNum*colNum));
    for figNum=1:totalFigNum
        h2=figure;
        n=0;
        for i=(rowNum*colNum)*(figNum-1)+1:(rowNum*colNum)*figNum
            if i>size(usePeps,1)
                break
            end
            n=n+1;
            subplot(rowNum,colNum,n)
            START=usePeps(i,1);
            END=usePeps(i,2);
            
            
            
            %%%calculate simulated distribution
            pepD=zeros(1,END-START+1-XN);
            for j=(START+XN):END
                [r,c]=find(DIndex==j);
                if min(size(r))~=0
                    if flagBXC==0
                        pepD(j-START+1-XN)=DFit(r);
                    else %2012-01-06 added:
                        bxTime=useData{i,3}(1,1);
                        kcDH=fbmme_dh(proSeq(START:END), bxPH, bxTemp, 'poly');
                        pepD(j-START+1-XN)=DFit(r)*exp(-kcDH(j-START+1)*bxTime);
                    end
                end
            end
            [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN); %call pepinfo.m
            Distr=1;
            for j=(START+XN):END
                if proSeq(j)~='P'
                    Distr=conv(Distr, [1-pepD(j-START+1-XN), pepD(j-START+1-XN)]);
                end
            end
            distSim=conv(distND, Distr);
            distSim=distSim/sum(distSim); %normalization
            centSim=centroid([(0:size(distSim,2)-1)', distSim']); %2011-06-20 added
            
            %%%get normalized experimental distribution:
            distObs=useData{i,1}(1,5:(5+maxND+maxD))/sum(useData{i,1}(1,5:(5+maxND+maxD)));
            centObs=centroid([(0:size(distObs,2)-1)', distObs']);  %2011-06-20 added
            
            stem(0:maxND+maxD, distObs, 'fill', 'k', 'MarkerSize', 3)
            hold on
            stem(0:maxND+maxD, distSim, 'r', 'MarkerSize', 3)
            hold on
            v3=min(min(distObs),min(distSim));
            v4=1.1*max(max(distObs),max(distSim));
            plot([centObs, centObs], [v3, v4],'b:','LineWidth',2)
            hold on
            plot([centSim, centSim], [v3, v4],'r:','LineWidth',2)
            hold on
            axis([-1, 1+maxND+maxD, v3, v4])
            if rowNum*colNum>20
                set(gca,'xtick',[],'ytick',[])
            else
                set(gca,'ytick',[])
            end
            if i==size(usePeps,1)
                xlabel('Delta Mass Above Monoisotopic')
            end

                title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])

        end
    end

    