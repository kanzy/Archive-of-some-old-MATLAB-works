XN=2

disp(' ')
disp('MSDFIT fitting algorithm may work on three levels: ')
disp('1: Using peptide delta mass (centroid) info only')
disp('2: Using peptide isotopic peaks gross structure (envelope) info')
disp('3: Using peptide isotopic peaks fine structure (lineshape) info')
disp(' ')
fitLevel=2 %input('Input the number of choice: ');
if fitLevel<1 || fitLevel>3
    error('Wrong input!')
end
fitSettings.fitLevel=fitLevel;

disp(' ')
disp('There are six fitting algorithms available: ')
disp('1: LsqNonLin')
disp('2: PatternSearch')
disp('3: MultiStart')
disp('4: GlobalSearch')
disp('5: SimulAnnealbnd')
disp('6: GeneticAlgo')
disp(' ')
Algo=input('Input the number of choice: ');
if Algo==3
    k_nsp=input('Input the number of start points to run (e.g. 50): ');
    fitSettings.k_nsp=k_nsp;
end
fitSettings.Algo=Algo;

fillFormSet=[];
totalPeps=16;
totalRuns=10;
for simPepNum=1:totalPeps
    SimEnd=4+simPepNum;
    for runNum=1:totalRuns
        if Algo==3
            AnalyName=['Jun26 Simulation SNase_1to',num2str(SimEnd),'_XN',num2str(XN),'_FL',num2str(fitLevel),'_Algo3k',num2str(k_nsp),'_runNum',num2str(runNum)];
        else
            AnalyName=['Jun26 Simulation SNase_1to',num2str(SimEnd),'_XN',num2str(XN),'_FL',num2str(fitLevel),'_Algo',num2str(Algo),'_runNum',num2str(runNum)];
        end
        jun26_msdfit
        fillFormSet=[fillFormSet; fillForm];
    end
end
        

figure
X=3:(2+totalPeps);
Y=zeros(1,totalPeps);
E=zeros(1,totalPeps);
for i=1:totalPeps
Y(i)=mean(fillFormSet((i-1)*totalRuns+1:i*totalRuns,7));
E(i)=std(fillFormSet((i-1)*totalRuns+1:i*totalRuns,7));
end
errorbar(X,Y,E) 
xlabel('Number of Fitted D Sites')
ylabel('RMSE of D%')
title({'jun26.m MSDFIT Single Peptide Simulation Test';
    ['(at FitLevel',num2str(fitLevel),' & FitAlgo',num2str(Algo),'; each point has ',num2str(totalRuns),' runs)']})

        
        
        
        
        
        
        
        
        
        
    