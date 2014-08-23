
HXtime=[1, 5, 10, 60, 120, 300];

% figure %Fig.1
% for i=1:13
%     subplot(3,5,i)
%     
%     semilogx(HXtime, Data(13,i)*ones(1,6),'g.:')
%     hold on
%     semilogx(HXtime, Data(14,i)*ones(1,6),'g.-')
%     hold on
%     
%     semilogx(HXtime, Data(15,i)*ones(1,6),'b.:')
%     hold on
%     semilogx(HXtime, Data(16,i)*ones(1,6),'b.-')
%     hold on
%     
%     semilogx(HXtime, Data(1:2:11,i),'r.:')
%     hold on
%     semilogx(HXtime, Data(2:2:12,i),'r.-')
%     hold on
%     
%     axis([0.3, 1e3, -0.05, 1.05])
%     set(gca,'XTick',[1,10,100])
%     set(gca,'XTickLabel',{'1','10','100'})
%     
%     if i==1
%        title(['Residue # ',num2str(DIndex2(i))],'FontWeight','bold') 
%        ylabel('D%')
%     else
%     title(['# ',num2str(DIndex2(i))],'FontWeight','bold')
%     end
%     if i==13
%         xlabel('HX Time (min)')
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pDread=7;
TempC=5;
kcHD = fbmme_hd(proSeq, pDread, TempC, 'poly', 0);


figure %Fig.2
for i=1:13
    subplot(3,5,i)
    
    kch=kcHD(DIndex2(i));
    HXtime2=0.01:0.01:300;
    Dch=1-exp(-kch*HXtime2*60);

    semilogx(HXtime2, Dch,'k:','LineWidth',2)
    hold on
    
    Dex=(Data(1:2:11,i)+Data(2:2:12,i))/2;
    allD=sum(Data(13:16,i))/4;
    Dcorr=Dex/allD;
    
    semilogx(HXtime, Dcorr,'r.-')
    hold on

    axis([0.1, 1e3, -0.05, 1.07])
    set(gca,'XTick',[0.1,1,10,100])
    set(gca,'XTickLabel',{'0.1','1','10','100'})
    
    if i==1
       title(['Residue # ',num2str(DIndex2(i))],'FontWeight','bold') 
       ylabel('Corr D%')
    else
    title(['# ',num2str(DIndex2(i))],'FontWeight','bold')
    end
    if i==13
        xlabel('HX Time (min)')
    end
end

















    