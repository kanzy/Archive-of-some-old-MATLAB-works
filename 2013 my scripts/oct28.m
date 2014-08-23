%%%oct28.m: merge oct27.m (left figure) & oct27b.m


XN_BXC=2;
    
bxTemp=0; %input('Input the temperature (C) during back exchange: ');
bxPH=2.5; %input('Input pH value during back exchange: ');
disp(' ')
bxIniD0=input('Input the fraction of D (0~1) in this all-D sample: ');

bxTime0=input('Input the estimated Prep + Wash time (min) at 0 C & pH 2.5: ');


%%%2013-10-27 added:
bxTimePro=0; %time after quench & before proteolysis////////////////////////////////////////////////////////////
kcDHpro=fbmme_dh(proSeq, bxPH, bxTemp, 'poly');

disp(' ')
disp('Please wait!...')

%%%calculate the effective back exchange time by fitting on all-D centroid:
bxTimeFitSet=NaN*ones(size(finalTable,1),4);
pepIntens=NaN*ones(size(finalTable,1),1); %2013-10-28 added
pepLens=NaN*ones(size(finalTable,1),1); %2013-10-28 added
options=optimset('TolFun',1e-20, 'MaxFunEvals',1e4, 'Display','off');
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        START=finalTable(i,1);
        END=finalTable(i,2);
        CS=finalTable(i,3);
        
%         deltaD=finalTable(i,10);
        %%%2013-10-28 corrected:
        [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN_BXC);
        deltaD=(finalTable(i,9)-finalTable(i,4))*CS-centroid([(0:size(distND,2)-1)',distND']);
        
        pepIntens(i)=sum(finalTable(i,20:end)); %2013-10-28 added
        pepLens(i)=END-START+1;
        
        meanRT=mean(finalTable(i,7:8));
        %meanRT=finalTable(i,7);
        
        %%%2013-10-27 added:
        bxIniD=zeros(1,END-START+1-XN_BXC);
        m=0;
        for j=(START+XN_BXC):END
            m=m+1;
            if kcDHpro(j)~=0
                bxIniD(m)=bxIniD0*exp(-kcDHpro(j)*bxTimePro*60);
            end
        end
        
        pepSeq=proSeq(START:END);
        kcDH=fbmme_dh(pepSeq, bxPH, bxTemp, 'poly');
        
        lb=-Inf;
        ub=Inf;
        f = @(bxTime)oct27_msdfit_bxc_fit(bxTime, bxIniD, deltaD, kcDH, XN_BXC); %XN value from msdfit.m
        [bxTimeFit,resnorm,residual,exitflag,output] = lsqnonlin(f, 1, lb, ub, options); %use MATLAB nonlinear least-squares curve fitting
        bxTimeFitSet(i,1)=meanRT;
        bxTimeFitSet(i,2)=bxTimeFit/60;
        bxTimeFitSet(i,3)=1;
                %%%see how good the above fits are:
                fitD=0;
                m=0;
                for j=(1+XN_BXC):size(kcDH,1)
                    m=m+1;
                    if kcDH(j)~=0
                        fitD=fitD+bxIniD(m)*exp(-kcDH(j)*bxTimeFit);
                    end
                end
                bxTimeFitSet(i,4)=fitD-deltaD;
    end
end


%%%plot BXT distribution (vs. exp RT) and filtering the outliers(probably wrong peptide ID):
figure

subplot(1,2,1)
plot(bxTimeFitSet(:,1), bxTimeFitSet(:,2), 'o')
hold on
x=bxTimeFitSet(:,1);
y=bxTimeFitSet(:,2);
[b,stats] = robustfit(x,y);
w=stats.w;
for i=1:size(w,1)
    %text(x(i),y(i),num2str(w(i)));
    text(x(i),y(i), num2str(i));
    hold on
end
plot(x,b(1)+b(2)*x,'r','LineWidth',1)
hold on
xlabel('Experimental Mean RT (min)')
ylabel('Effective BXT (min)')
title(['Robust Regression (Y=', num2str(b(2)), '*X + ', num2str(b(1)), ')'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(1,2,2)
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        START=finalTable(i,1);
        END=finalTable(i,2);
        CS=finalTable(i,3);
        
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
        
        plot(deltaD, calD, 'go')
        hold on
        
        text(deltaD, calD, num2str(i));
        hold on
    end
    
    plot([0 25], [0 25], 'k:')
    hold on
end
xlabel('Observed D')
ylabel('Expected D')
title(['With the estimated Prep + Wash time ', num2str(bxTime0), ' minutes at 0 C & pH 2.5']);


