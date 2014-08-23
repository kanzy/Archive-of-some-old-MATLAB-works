

XN=2 %exclude N-terminal 1 or 2 residues

% disp(' ')
% disp('Now import the ExMS_wholeResults_afterCheck.mat file of all-D control sample: ')
% uiimport
% void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
% proSeq=currSeq;

bxTemp=0
bxPH=2.5
bxIniD=0.9
bxTimePre=5 %unit: min

figure
record=zeros(size(proSeq,2),1);
  for i=1:size(finalTable,1)
     if finalTable(i,12)>=1
        START=peptidesPool(i,1);
        END=peptidesPool(i,2);
        CS=peptidesPool(i,3);
        meanRT=mean(finalTable(i,7:8));
        pepSeq=proSeq(START:END);
        pep_kcDH=fbmme_dh(pepSeq, bxPH, bxTemp, 'poly');
        for j=START+XN:END
bxD=bxIniD*(1-exp(-pep_kcDH(j-START+1)*(bxTimePre+meanRT)*60));
% bxD=bxIniD*(1-exp(-pep_kcDH(j-START+1)*(bxTimePre)*60));
            plot(j, bxD, 'o')
            hold on
            record(j,1)=record(j,1)+1;
            record(j,1+record(j,1))=bxD;
        end
     end
  end
   
  for i=1:size(record,1)
      Max=max(record(i,2:end));
      if Max>0
          Min=Max;
          for j=2:size(record,2)
              if record(i,j)>0 && record(i,j)<Min
                  Min=record(i,j);
              end
          end
          if Min~=Max
              plot([i,i],[Min,Max],':k')
              hold on
          end
      end
  end
  






% 
% 
% 
% bxTimeFitSet=-1*ones(size(finalTable,1),2);
% figure
% options=optimset('TolFun',1e-20, 'MaxFunEvals',1e4);
% XData=[];
% YData=[];
% n=0;
% for i=1:size(finalTable,1)
%     if finalTable(i,12)>=1
%         START=finalTable(i,1);
%         END=finalTable(i,2);
%         CS=finalTable(i,3);
%         deltaD=finalTable(i,10);
%         meanRT=mean(finalTable(i,7:8));
%         pepSeq=proSeq(START:END);
%         kcDH=fbmme_dh(pepSeq, bxPH, bxTemp, 'poly');
%         bxTime0=1; 
%         lb=0;
%         ub=Inf;
%         f = @(bxTime)msdfit_bxc_fit(bxTime, bxIniD, deltaD, kcDH, XN);
%         [bxTimeFitSet(i,1),resnorm,residual,exitflag,output] = lsqnonlin(f,bxTime0,lb,ub,options); %use MATLAB nonlinear least-squares curve fitting
%         plot(meanRT, bxTimeFitSet(i,1)/60, 'o')
%         hold on
% %         text(meanRT, bxTimeFitSet(i,1)/60, [num2str(START),'-',num2str(END),'+',num2str(CS)]);
% %         hold on
%         
%         n=n+1;
%         XData(n)=meanRT;
%         YData(n)=bxTimeFitSet(i,1)/60;
%         
%         fitD=0;
%         for j=(1+XN):size(kcDH,1)
%             if kcDH(j)~=0
%                 fitD=fitD+bxIniD*exp(-kcDH(j)*bxTimeFitSet(i,1));
%             end
%         end
%         bxTimeFitSet(i,2)=fitD-deltaD;
%     end
% end
% xlabel('mean RT (min)')
% ylabel('bxTimeFit (min)')
% 
% % cftool
%  