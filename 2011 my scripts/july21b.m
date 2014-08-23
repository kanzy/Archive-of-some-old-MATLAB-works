%%%refer to apr29.m

SNase='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';

pDread=9;
TempC=68;
molType='poly';
ifCorr=1;

kcHD = fbmme_hd(SNase, pDread, TempC, molType, ifCorr);

figure

subplot(2,1,1)
Colors=colormap(jet(149));
for i=1:149
    if kcHD(i)~=0
    points=0.95:-0.05:0.05;
        t=-log(points)/kcHD(i);
        semilogx(t/60,1-points,'color',Colors(i,:))
        hold on
        text(t(1)/60,0,num2str(i),'color',Colors(i,:))
        hold on
        text(t(end)/60,1,num2str(i),'color',Colors(i,:))
        hold on
    end
end
grid on
ylabel('D%')
title('H->D with Intrinsic Rate')

subplot(2,1,2)
Colors=colormap(jet(149));
for i=1:149
    if kcHD(i)~=0 && isnan(logPfList(i))==0
    points=0.95:-0.05:0.05;
        t=-log(points)/(kcHD(i)/(10^logPfList(i)));
        semilogx(t/60,1-points,'color',Colors(i,:))
        hold on
        text(t(1)/60,0,num2str(i),'color',Colors(i,:))
        hold on
        text(t(end)/60,1,num2str(i),'color',Colors(i,:))
        hold on
    end
end
grid on
xlabel('HX Time (min)')
ylabel('D%')
title('H->D with PF (provided by John)')


    