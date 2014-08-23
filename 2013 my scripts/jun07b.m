

figure
%subplot(2,4,[1 2 5 6])
subplot(1,2,1)
subVals=[];
Xdata=[];
Ydata=[];
CS=[];
n=0;
for i=1:size(finalTable2,1)
    if finalTable2(i,12)>=1 && finalTable6(i,12)>=1
        n=n+1;
        
        CS(n)=finalTable2(i,3);
        
        %         plot(finalTable2(i,4), finalTable2(i,10),'ro')
        %         hold on
        %         plot(finalTable6(i,4), finalTable6(i,10),'bo')
        %         hold on
        %         plot([finalTable2(i,4), finalTable6(i,4)], [finalTable2(i,10), finalTable6(i,10)],'k:')
        %         hold on
        
                plot(finalTable2(i,4), finalTable2(i,10)-finalTable6(i,10),'ko')
                hold on
        
        %Xdata(n)=mean([finalTable2(i,10), finalTable6(i,10)]);
        %Xdata(n)=(finalTable2(i,4)-1.007276)*finalTable2(i,3); %peptide mass
%         Xdata(n)=finalTable2(i,2)-finalTable2(i,1)+1; %peptide length
%         
%         Ydata(n)=finalTable2(i,10)-finalTable6(i,10);
        
        subVals(n)=finalTable2(i,10)-finalTable6(i,10);
    end
end
xlabel('Peptide Monoisotopic m/z')
% ylabel('Incorporated Deuterons (determined by ExMS)')

% plot(Xdata, Ydata,'ko')
% hold on
%xlabel('Incorporated Deuterons (determined by ExMS)')
% 
% Xdata1=Xdata(find(CS==1));
% Ydata1=Ydata(find(CS==1));
% plot(Xdata1, Ydata1, 'ro');
% hold on
% 
% Xdata2=Xdata(find(CS==2));
% Ydata2=Ydata(find(CS==2));
% plot(Xdata2, Ydata2, 'bo');
% hold on
% 
% Xdata3=Xdata(find(CS==3));
% Ydata3=Ydata(find(CS==3));
% plot(Xdata3, Ydata3, 'go');
% hold on
% 
% Xdata4=Xdata(find(CS>3));
% Ydata4=Ydata(find(CS>3));
% plot(Xdata4, Ydata4, 'co');
% hold on


%xlabel('Peptide Mass')
% xlabel('Peptide Length')
ylabel('delta D (15K-60K)')

subplot(1,2,2)
hist(subVals,-2:0.1:2)

% subplot(2,4,3)
% hist(Ydata1,-2:0.1:2)
% hold on
% subplot(2,4,4)
% hist(Ydata2,-2:0.1:2)
% hold on
% subplot(2,4,7)
% hist(Ydata3,-2:0.1:2)
% hold on
% subplot(2,4,8)
% hist(Ydata4,-2:0.1:2)
% hold on

xlabel('delta D (15K-60K)')
ylabel('Count')

