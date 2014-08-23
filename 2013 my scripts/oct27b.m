%%%2012-09-19 revised
%%%2012-01-03 msdfit_bxc.m: fit on all-D ctrl for back exchange correction



XN_BXC=2
    
bxTemp=0; %input('Input the temperature (C) during back exchange: ');
bxPH=2.5; %input('Input pH value during back exchange: ');
disp(' ')
bxIniD0=input('Input the fraction of D (0~1) in this all-D sample: ');

bxTime0=5+0;

figure
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        START=finalTable(i,1);
        END=finalTable(i,2);
        CS=finalTable(i,3);
        
%         deltaD=finalTable(i,10);
        %%%2013-10-28 corrected:
        [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN_BXC);
        deltaD=(finalTable(i,9)-finalTable(i,4))*CS-centroid([(0:size(distND,2)-1)',distND']);
        

        
        meanRT=mean(finalTable(i,7:8));
        
        
        pepSeq=proSeq(START:END);
        kcDH=fbmme_dh(pepSeq, bxPH, bxTemp, 'poly');
        
        %%%see how good the above fits are:
        calD=0;
        m=0;
        for j=(1+XN_BXC):size(kcDH,1)
            if kcDH(j)~=0
                calD=calD+bxIniD0*exp(-kcDH(j)*(bxTime0+meanRT)*60);
            end
        end
        
        plot(deltaD, calD, 'o')
        hold on
    end
    
    plot([0 25], [0 25], 'k:')
    hold on
end
xlabel('Observed D')
ylabel('Expected D')


