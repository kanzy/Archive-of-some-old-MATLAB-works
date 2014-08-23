

figure

mzMin=601;
mzMax=609;

xPos=0.85;
yPos=0.8;

subplot(4,1,1)
plot(FigData1(:,1),FigData1(:,2),'b')
hold on
maxInten=0;
for i=1:size(FigData1,1)
    if FigData1(i,1)>mzMin && FigData1(i,1)<mzMax && FigData1(i,2)>maxInten
        maxInten=FigData1(i,2);
    end
end
v=axis;
axis([mzMin,mzMax,v(3),maxInten*1.2/13.5])
title('Original Mass Spectra')
set(gca,'xtick',[],'ytick',[])
title('alpha-Synuclein Peptide 12-17 +1','FontWeight','bold')
v=axis;
text(mzMin+(mzMax-mzMin)*xPos, v(4)*yPos, 'All H','FontAngle','italic','FontWeight','bold','FontSize',10);



subplot(4,1,2)
plot(FigData2(:,1),FigData2(:,2),'b')
hold on
maxInten=0;
for i=1:size(FigData2,1)
    if FigData2(i,1)>mzMin && FigData2(i,1)<mzMax && FigData2(i,2)>maxInten
        maxInten=FigData2(i,2);
    end
end
v=axis;
axis([mzMin,mzMax,v(3),maxInten*1.2/10])
set(gca,'xtick',[],'ytick',[])
v=axis;
text(mzMin+(mzMax-mzMin)*xPos, v(4)*yPos, '5 min','FontAngle','italic','FontWeight','bold','FontSize',10);



subplot(4,1,3)
plot(FigData3(:,1),FigData3(:,2),'b')
hold on
maxInten=0;
for i=1:size(FigData3,1)
    if FigData3(i,1)>mzMin && FigData3(i,1)<mzMax && FigData3(i,2)>maxInten
        maxInten=FigData3(i,2);
    end
end
v=axis;
axis([mzMin,mzMax,v(3),maxInten*1.2/6.5])
set(gca,'xtick',[],'ytick',[])
v=axis;
text(mzMin+(mzMax-mzMin)*xPos, v(4)*yPos, '1 hr','FontAngle','italic','FontWeight','bold','FontSize',10);



subplot(4,1,4)
plot(FigData4(:,1),FigData4(:,2),'b')
maxInten=0;
for i=1:size(FigData4,1)
    if FigData4(i,1)>mzMin && FigData4(i,1)<mzMax && FigData4(i,2)>maxInten
        maxInten=FigData4(i,2);
    end
end
v=axis;
axis([mzMin,mzMax,v(3),maxInten*1.2/7.5])
set(gca,'ytick',[])
xlabel('m/z')
v=axis;
text(mzMin+(mzMax-mzMin)*xPos, v(4)*yPos, 'All D','FontAngle','italic','FontWeight','bold','FontSize',10);


















% 
% subplot(4,2,2)
% stem(0:23, distDeconv_allH,'fill','k','MarkerSize',5)
% hold on
% axis([-1,24,0,max(distDeconv_allH)*1.2])
% title('Deconvoluted Spectra')
% set(gca,'xtick',[],'ytick',[])
% 
% 
% subplot(4,2,3)
% plot(data_Fibril5min(:,1),data_Fibril5min(:,2),'k')
% hold on
% % ylabel('Intensity')
% v=axis;
% axis([v(1),v(2),v(3),max(data_Fibril5min(:,2))*1.2])
% v=axis;
% text(predictPeaks(1,1)+(similarPeptides(1,5)+similarPeptides(1,6))*xPos/similarPeptides(1,3), v(4)*yPos, '5 min','BackgroundColor',[.7 .9 .7],'FontAngle','italic','FontWeight','bold','FontSize',10);
% set(gca,'xtick',[],'ytick',[])
% 
% subplot(4,2,4)
% stem(0:23, distDeconv_Fibril5min,'fill','k','MarkerSize',5)
% hold on
% v=axis;
% axis([-1,24,v(3),max(distDeconv_Fibril5min)*1.2])
% set(gca,'xtick',[],'ytick',[])
% 
% subplot(4,2,5)
% plot(data_Fib1hr(:,1),data_Fib1hr(:,2),'k')
% hold on
% v=axis;
% axis([v(1),v(2),v(3),max(data_Fib1hr(:,2))*1.2])
% v=axis;
% text(predictPeaks(1,1)+(similarPeptides(1,5)+similarPeptides(1,6))*xPos/similarPeptides(1,3), v(4)*yPos, '1 hr','BackgroundColor',[.7 .9 .7],'FontAngle','italic','FontWeight','bold','FontSize',10);
% set(gca,'xtick',[],'ytick',[])
% 
% subplot(4,2,6)
% stem(0:23, distDeconv_Fib1hr,'fill','k','MarkerSize',5)
% hold on
% v=axis;
% axis([-1,24,v(3),max(distDeconv_Fib1hr)*1.2])
% set(gca,'xtick',[],'ytick',[])
% 
% subplot(4,2,7)
% plot(data_allD(:,1),data_allD(:,2),'k')
% hold on
% v=axis;
% axis([v(1),v(2),v(3),1.2e5])
% xlabel('m/z')
% v=axis;
% axis([v(1),v(2),v(3),max(data_allD(:,2))*1.2])
% v=axis;
% text(predictPeaks(1,1)+(similarPeptides(1,5)+similarPeptides(1,6))*xPos/similarPeptides(1,3), v(4)*yPos, 'All D','BackgroundColor',[.7 .9 .7],'FontAngle','italic','FontWeight','bold','FontSize',10);
% set(gca,'ytick',[])
% 
% subplot(4,2,8)
% stem(0:23, distDeconv_allD,'fill','k','MarkerSize',5)
% hold on
% v=axis;
% axis([-1,24,v(3),max(distDeconv_allD)*1.2])
% xlabel('Deuteron Number')
% set(gca,'ytick',[])
