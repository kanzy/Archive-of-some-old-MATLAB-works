%%%2012-09-19 revised
%%%2012-01-03 msdfit_bxc.m: fit on all-D ctrl for back exchange correction

% disp(' ')
% disp('This routine is to calculate the effective back exchange time for each peptide based on recovery of all-D control.')
% disp('Now import the ExMS_wholeResults_afterCheck.mat file of the all-D control sample: ')
% uiimport
% void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
% proSeq=currSeq;
% 
% disp(' ')
% if exist('XN','var')
%     flag=input(['There will be ',num2str(XN),' N-term residues (XN) to be excluded, what to change?(1=yes,0=no): ']);
%     if flag~=0
%         XN_BXC=input('Input the new XN value to be used: ');
%     else
%         XN_BXC=XN;
%     end
% else
%     XN_BXC=input('Input how many N-term residues (XN) to be excluded: ');
% end

XN_BXC=2
    

bxTemp=0; %input('Input the temperature (C) during back exchange: ');
bxPH=2.5; %input('Input pH value during back exchange: ');
disp(' ')
bxIniD=input('Input the fraction of D (0~1) in this all-D sample: ');
disp(' ')
disp('Please wait!...')

%%%calculate the effective back exchange time by fitting on all-D centroid:
bxTimeFitSet=NaN*ones(size(finalTable,1),4);
options=optimset('TolFun',1e-20, 'MaxFunEvals',1e4, 'Display','off');
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        START=finalTable(i,1);
        END=finalTable(i,2);
        CS=finalTable(i,3);
        deltaD=finalTable(i,10);
        meanRT=mean(finalTable(i,7:8));
        pepSeq=proSeq(START:END);
        kcDH=fbmme_dh(pepSeq, bxPH, bxTemp, 'poly');
        bxTime0=1;
        lb=-Inf;
        ub=Inf;
        f = @(bxTime)msdfit_bxc_fit(bxTime, bxIniD, deltaD, kcDH, XN_BXC); %XN value from msdfit.m
        [bxTimeFit,resnorm,residual,exitflag,output] = lsqnonlin(f,bxTime0,lb,ub,options); %use MATLAB nonlinear least-squares curve fitting
        bxTimeFitSet(i,1)=meanRT;
        bxTimeFitSet(i,2)=bxTimeFit/60;
        bxTimeFitSet(i,3)=1;
                %%%see how good the above fits are:
                fitD=0;
                for j=(1+XN_BXC):size(kcDH,1)
                    if kcDH(j)~=0
                        fitD=fitD+bxIniD*exp(-kcDH(j)*bxTimeFit);
                    end
                end
                bxTimeFitSet(i,4)=fitD-deltaD;
    end
end
bxTimeFitSet0=bxTimeFitSet;

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
plot(x,b(1)+b(2)*x,'g','LineWidth',2)
hold on
xlabel('Experimental Mean RT (min)')
ylabel('Effective BXT (min)')
title(['Robust Regression (Y=', num2str(b(2)), '*X + ', num2str(b(1)), ')'])

subplot(1,2,2)
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
plot(x,b(1)+b(2)*x,'g','LineWidth',2)
hold on
xlabel('Experimental Mean RT (min)')
title('Zoom In')





% wThreshold=0.5; %input('Input the weight threshold for filtering outlier points (e.g. 0.5): ');
% n=0;
% m=0;
% for i=1:size(w,1)
%     if w(i)<wThreshold
%         bxTimeFitSet(i,2)=NaN;
%         bxTimeFitSet(i,3)=0;
%     end
%     if w(i)>=wThreshold
%         n=n+1;
%         m=m+bxTimeFitSet(i,2);
%     end
% end
% bxTimeFitSet=[bxTimeFitSet(:,2)*60, bxTimeFitSet(:,3)];
% aveBXT=m*60/n;
% 
% %%%fill the missing BXT values:
% for i=1:size(w,1)
%     if bxTimeFitSet(i,2)~=1 %class1: original good
%         START=finalTable(i,1);
%         END=finalTable(i,2);
%         CS=finalTable(i,3);
%         meanRT=mean(finalTable(i,7:8));
%         x=find(START==finalTable(:,1) & END==finalTable(:,2));
%         n=0;
%         m=0;
%         for j=1:max(size(x))
%             if bxTimeFitSet(x(j),2)==1
%                 n=n+1;
%                 m=m+bxTimeFitSet(x(j),1);
%             end
%         end
%         if n>0
%             bxTimeFitSet(i,1)=m/n;
%             bxTimeFitSet(i,2)=2; %class2: BXT estimated by same peptide w. diff cs
%         else
%             if meanRT>0 %there is a RT for this peptide
%                 bxTimeFitSet(i,1)=(b(1)+b(2)*meanRT)*60;
%                 bxTimeFitSet(i,2)=3; %class3: BXT estimated by the robust regression line
%             else
%                 bxTimeFitSet(i,1)=aveBXT;
%                 bxTimeFitSet(i,2)=4; %class4: BXT estimated by average of all
%             end
%         end
%     end
% end
% bxTimeFitSet=[bxTimeFitSet, finalTable(:,1:3)]; %2012-09-19 added
% 
% disp(' ')
% disp('Done!')
% SaveName=input('To save for future use, give a name for this all-D BXC result: ','s');
% SaveFileName=['(',SaveName,')_HDsite_bxc.mat'];
% save(SaveFileName,'bxTemp','bxPH','bxIniD','proSeq','finalTable','XN_BXC','wThreshold','bxTimeFitSet','b','aveBXT')
% disp(' ')
% disp([SaveFileName,' has been saved in MATLAB current directory!'])
% 
% 
