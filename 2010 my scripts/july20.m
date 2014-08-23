
% n=[0 0 0 0];
% figure
% for i=1:size(sumTable,1)
%     if min(size(find(sumTable(i,1)==peptidesPool_isobaricTable(:,1) & ...
%             sumTable(i,2)==peptidesPool_isobaricTable(:,2) & ...
%             sumTable(i,3)==peptidesPool_isobaricTable(:,3))))==0
%         if sumTable(i,10)==1 && sumTable(i,11)==1
%             semilogx(sumTable(i,8), sumTable(i,9),'b.')
%             n(1)=n(1)+1;
%         else
%             if sumTable(i,10)==1 && sumTable(i,11)~=1
%                 semilogx(sumTable(i,8), sumTable(i,9),'y.')
%                 n(2)=n(2)+1;
%             else
%                 if sumTable(i,10)~=1 && sumTable(i,11)==1
%                     semilogx(sumTable(i,8), sumTable(i,9),'c.')
%                     n(3)=n(3)+1;
%                 else
%                     semilogx(sumTable(i,8), sumTable(i,9),'r.')
%                     n(4)=n(4)+1;
%                 end
%             end
%         end
%         hold on
%     end
% end
% grid on
% axis([1e-15 10 0 7])
% xlabel('Sequest P Score')
% ylabel('Sequest XCorr Score')
% title({'2010-07-19 aSynWT MSMS2 test on all-H & half-D (Non-isobaric Set)'; '(blue=both good; yellow=bad in D; red=both bad)'})
% n
% 
% figure
% for i=1:size(sumTable,1)
%     if min(size(find(sumTable(i,1)==peptidesPool_isobaricTable(:,1) & ...
%             sumTable(i,2)==peptidesPool_isobaricTable(:,2) & ...
%             sumTable(i,3)==peptidesPool_isobaricTable(:,3))))==0
%         if sumTable(i,10)==1 && sumTable(i,11)==1
%             plot(sumTable(i,8), sumTable(i,9),'b.')
%         else
%             if sumTable(i,10)==1 && sumTable(i,11)~=1
%                 plot(sumTable(i,8), sumTable(i,9),'y.')
%             else
%                 if sumTable(i,10)~=1 && sumTable(i,11)==1
%                     semilogx(sumTable(i,8), sumTable(i,9),'c.')
%                 else
%                     plot(sumTable(i,8), sumTable(i,9),'r.')
%                 end
%             end
%         end
%         hold on
%     end
% end
% grid on
% axis([-0.05 1.05 0 7])
% xlabel('Sequest P Score')
% ylabel('Sequest XCorr Score')
% title({'2010-07-19 aSynWT MSMS2 test on all-H & half-D (Non-isobaric Set)'; '(blue=both good; yellow=bad in D; red=both bad)'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% n=1;
% subplot(2,1,1)
% plot(n,peptidesPool_isobaricTable(1,8),'ro')
% hold on
% subplot(2,1,2)
% plot(n,peptidesPool_isobaricTable(1,9),'ro')
% hold on
% for i=2:size(peptidesPool_isobaricTable,1)
%     
%     x=find(peptidesPool_isobaricTable(i,1)==sumTable(:,1) & ...
%         peptidesPool_isobaricTable(i,2)==sumTable(:,2) & ...
%         peptidesPool_isobaricTable(i,3)==sumTable(:,3));
%     y=sumTable(x,10:11);
%     
%     diff=abs(peptidesPool_isobaricTable(i,4)-peptidesPool_isobaricTable(i-1,4));
%     if diff<=0.02
%         subplot(2,1,1)
%         if y(1)==1 && y(2)==1
%         plot(n,peptidesPool_isobaricTable(i,8),'bo')
%         else
%             if y(1)==1 && y(2)~=1
%                 plot(n,peptidesPool_isobaricTable(i,8),'yo')
%             else
%                 if y(1)~=1 && y(2)==1
%                     plot(n,peptidesPool_isobaricTable(i,8),'co')
%                 else
%                 plot(n,peptidesPool_isobaricTable(i,8),'ro')
%                 end
%             end
%         end
%                 
%         hold on
%         plot([n,n],[peptidesPool_isobaricTable(i,8),peptidesPool_isobaricTable(i-1,8)],'k')
%         hold on
%         
%         subplot(2,1,2)
%         if y(1)==1 && y(2)==1
%         plot(n,peptidesPool_isobaricTable(i,9),'bo')
%         else
%             if y(1)==1 && y(2)~=1
%                 plot(n,peptidesPool_isobaricTable(i,9),'yo')
%             else
%                 if y(1)~=1 && y(2)==1
%                     plot(n,peptidesPool_isobaricTable(i,9),'co')
%                 else
%                 plot(n,peptidesPool_isobaricTable(i,9),'ro')
%                 end
%             end
%         end
%         hold on
%         plot([n,n],[peptidesPool_isobaricTable(i,9),peptidesPool_isobaricTable(i-1,9)],'k')
%         hold on
%     else
%         n=n+1;
%         subplot(2,1,1)
%         if y(1)==1 && y(2)==1
%         plot(n,peptidesPool_isobaricTable(i,8),'bo')
%         else
%             if y(1)==1 && y(2)~=1
%                 plot(n,peptidesPool_isobaricTable(i,8),'yo')
%             else
%                 if y(1)~=1 && y(2)==1
%                     plot(n,peptidesPool_isobaricTable(i,8),'co')
%                 else
%                 plot(n,peptidesPool_isobaricTable(i,8),'ro')
%                 end
%             end
%         end
%         hold on
%         
%         subplot(2,1,2)
%         if y(1)==1 && y(2)==1
%         plot(n,peptidesPool_isobaricTable(i,9),'bo')
%         else
%             if y(1)==1 && y(2)~=1
%                 plot(n,peptidesPool_isobaricTable(i,9),'yo')
%             else
%                 if y(1)~=1 && y(2)==1
%                     plot(n,peptidesPool_isobaricTable(i,9),'co')
%                 else
%                 plot(n,peptidesPool_isobaricTable(i,9),'ro')
%                 end
%             end
%         end
%         hold on
%     end
% end
% subplot(2,1,1)
% ylabel('P Score')
% title({'2010-07-19 aSynWT MSMS2 test on all-H & half-D (Isobaric Sets)'; '(blue=both good; cyan=bad in allH; yellow=bad in D; red=both bad)'})
% axis([-1, 90, -0.1 1.1])
% 
% subplot(2,1,2)
% xlabel('Index')
% ylabel('XCorr Score')
% axis([-1, 90, -0.5 8])



% figure
% n=1;
% subplot(2,1,1)
% plot(n,peptidesPool_isobaricTable(1,8),'ko')
% hold on
% subplot(2,1,2)
% plot(n,peptidesPool_isobaricTable(1,7),'ko')
% hold on
% for i=2:size(peptidesPool_isobaricTable,1)
%     diff=abs(peptidesPool_isobaricTable(i,4)-peptidesPool_isobaricTable(i-1,4));
%     if diff<=0.02
%         subplot(2,1,1)
%         plot(n,peptidesPool_isobaricTable(i,8),'ko')
%         hold on
%         plot([n,n],[peptidesPool_isobaricTable(i,8),peptidesPool_isobaricTable(i-1,8)],'k')
%         hold on
%         
%         subplot(2,1,2)
%         plot(n,peptidesPool_isobaricTable(i,7),'ko')
%         hold on
%         plot([n,n],[peptidesPool_isobaricTable(i,7),peptidesPool_isobaricTable(i-1,7)],'k')
%         hold on
%     else
%         n=n+1;
%         subplot(2,1,1)
%         plot(n,peptidesPool_isobaricTable(i,8),'ko')
%         hold on
%         
%         subplot(2,1,2)
%         plot(n,peptidesPool_isobaricTable(i,7),'ko')
%         hold on
%     end
% end
% subplot(2,1,1)
% ylabel('P Score')
% title('2010-07-19 aSynWT MSMS2 Isobaric Peptides Sets')
% axis([-1, 90, -0.1 1.1])
% 
% subplot(2,1,2)
% xlabel('Index')
% ylabel('Retention Time (min)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% bestPep=peptidesPool_isobaricTable(1,:);
% n=1;
% for i=2:size(peptidesPool_isobaricTable,1)
%     diff=abs(peptidesPool_isobaricTable(i,4)-peptidesPool_isobaricTable(i-1,4));
%     if diff<=0.02 
%         if peptidesPool_isobaricTable(i,8)<bestPep(1,8)
%             bestPep=peptidesPool_isobaricTable(i,:);
%         end
%     else
%         x=find(bestPep(1,1)==sumTable(:,1) & ...
%             bestPep(1,2)==sumTable(:,2) & ...
%             bestPep(1,3)==sumTable(:,3));
%         
%         if sumTable(x,10)==1 && sumTable(x,11)==1
%         semilogx(sumTable(x,8), sumTable(x,9),'b.')
%         else
%             if sumTable(x,10)==1 && sumTable(x,11)~=1
%                 semilogx(sumTable(x,8), sumTable(x,9),'y.')
%             else
%                 if sumTable(x,10)~=1 && sumTable(x,11)==1
%                     semilogx(sumTable(x,8), sumTable(x,9),'c.')
%                 else
%                 semilogx(sumTable(x,8), sumTable(x,9),'r.')
%                 end
%             end
%         end
%         
%         hold on
%         
%         bestPep(1,8)=1.1;
%         n=n+1;
%     end
% end
% n
%      
% grid on
% axis([1e-14 10 0 7.5])
% xlabel('Sequest P Score')
% ylabel('Sequest XCorr Score')
% title({'2010-07-19 aSynWT MSMS2 test on all-H & half-D (Best Isobaric Peptides)'; '(blue=both good; cyan=bad in allH; yellow=bad in D; red=both bad)'})

        
    


% figure
% bestPep=peptidesPool_isobaricTable(1,:);
% n=1;
% for i=2:size(peptidesPool_isobaricTable,1)
%     diff=abs(peptidesPool_isobaricTable(i,4)-peptidesPool_isobaricTable(i-1,4));
%     if diff<=0.02 
%         if peptidesPool_isobaricTable(i,9)>bestPep(1,9)
%             bestPep=peptidesPool_isobaricTable(i,:);
%         end
%     else
%         x=find(bestPep(1,1)==sumTable(:,1) & ...
%             bestPep(1,2)==sumTable(:,2) & ...
%             bestPep(1,3)==sumTable(:,3));
%         
%         if sumTable(x,10)==1 && sumTable(x,11)==1
%         semilogx(sumTable(x,8), sumTable(x,9),'b.')
%         else
%             if sumTable(x,10)==1 && sumTable(x,11)~=1
%                 semilogx(sumTable(x,8), sumTable(x,9),'y.')
%             else
%                 if sumTable(x,10)~=1 && sumTable(x,11)==1
%                     semilogx(sumTable(x,8), sumTable(x,9),'c.')
%                 else
%                 semilogx(sumTable(x,8), sumTable(x,9),'r.')
%                 end
%             end
%         end
%         
%         hold on
%         
%         bestPep(1,9)=-0.1;
%         n=n+1;
%     end
% end
% n
%      
% grid on
% axis([1e-14 10 0 7.5])
% xlabel('Sequest P Score')
% ylabel('Sequest XCorr Score')
% title({'2010-07-19 aSynWT MSMS2 test on all-H & half-D (Best Isobaric Peptides)'; '(blue=both good; cyan=bad in allH; yellow=bad in D; red=both bad)'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


x=find(sumTable(:,8)<2 & sumTable(:,8)>0.95 & ... %P
        sumTable(:,9)>0.1 & sumTable(:,9)<0.15 &... %XC
        sumTable(:,10)==1 & sumTable(:,11)==1)



















        