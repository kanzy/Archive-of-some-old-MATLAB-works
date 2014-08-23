
Data=sep14data;
HXtime=Data(1,4:13);

figure 
for i=1:14
    subplot(3,5,i)
    
    semilogx(HXtime, Data(i+1,3)*ones(1,10),'y--')
    hold on
    
    semilogx(HXtime, Data(i+1,2)*ones(1,10),'b--')
    hold on
    
    semilogx(HXtime, Data(i+1,4:13),'r.:')
    hold on
    
    axis([10, 1e5, -0.05, 1.05])
    set(gca,'XTick',[100,1000,10000])
    set(gca,'XTickLabel',{'1e2','1e3','1e4'})
    
    if i==1
       title(['Residue # ',num2str(Data(i+1,1)),' (',num2str(logPfList(Data(i+1,1)),'%3.1f'),')'],'FontWeight','bold')
       ylabel('D%')
    else
    title(['# ',num2str(Data(i+1,1)),' (',num2str(logPfList(Data(i+1,1)),'%3.1f'),')'],'FontWeight','bold')
    end
    if i==14
        xlabel('HX Time (sec)')
    end
end